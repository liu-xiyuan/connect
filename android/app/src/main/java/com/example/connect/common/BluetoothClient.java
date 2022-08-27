package com.example.connect.common;


import android.annotation.SuppressLint;
import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothHidDevice;
import android.bluetooth.BluetoothHidDeviceAppQosSettings;
import android.bluetooth.BluetoothHidDeviceAppSdpSettings;
import android.bluetooth.BluetoothProfile;
import android.content.Context;

import java.util.concurrent.Executor;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.BinaryMessenger;


@SuppressLint("MissingPermission")
public class BluetoothClient extends BluetoothHidDevice.Callback {
    MethodChannel mChannel;     // Android<=>Flutter 通信通道
    BluetoothHidDevice mHidDevice;
    BluetoothDevice mHostDevice;
    BinaryMessenger mMessenger;
    Activity mActivity;

    public BluetoothClient(Activity mActivity, BinaryMessenger mMessenger) {
        this.mActivity = mActivity;
        this.mMessenger = mMessenger;
        this.mChannel = new MethodChannel(mMessenger, "android.flutter/Bluetooth"); // 初始化通信通道名称
    }

    // 初始化蓝牙HID, 将设备注册为蓝牙HID设备
    @SuppressLint("MissingPermission")
    public void initHidDevice(Context context) {

        // 初始化监听事件, 客户端连接到服务或断开服务连接时向其发送通知。
        BluetoothProfile.ServiceListener mProfileServiceListener = new BluetoothProfile.ServiceListener() {
            @Override
            public void onServiceConnected(int profile, BluetoothProfile proxy) {
                if (profile == BluetoothProfile.HID_DEVICE) {
                    mHidDevice = (BluetoothHidDevice) proxy;

                    // 服务发现协议(SDP)设置. 应用注册时添加SDP记录, 以便安卓设备可以被发现为蓝牙HID设备。
                    BluetoothHidDeviceAppSdpSettings sdp = new BluetoothHidDeviceAppSdpSettings(
                            HidConsts.NAME,
                            HidConsts.DESCRIPTION,
                            HidConsts.PROVIDER,
                            BluetoothHidDevice.SUBCLASS1_COMBO,
                            HidConsts.DESCRIPTOR
                    );

                    BluetoothHidDeviceAppQosSettings outQos = new BluetoothHidDeviceAppQosSettings(
                            BluetoothHidDeviceAppQosSettings.SERVICE_BEST_EFFORT,
                            800, 9, 0, 11250,
                            BluetoothHidDeviceAppQosSettings.MAX);

                    // 将应用注册为HID设备
                    mHidDevice.registerApp(sdp, null, outQos, new Executor() {
                                @Override
                                public void execute(Runnable command) {
                                    command.run();
                                }
                            }, BluetoothClient.this);
                }
            }

            @Override
            public void onServiceDisconnected(int profile) {
                // 服务中断
                if (profile == BluetoothProfile.HID_DEVICE) {
                    mHidDevice = null;
                }
            }
        };

        // 建立与代理的连接
        BluetoothAdapter.getDefaultAdapter().getProfileProxy(context, mProfileServiceListener, BluetoothProfile.HID_DEVICE);
    }


    // 通过MAC地址连接蓝牙
    public void connect(String macAddress) {
        if (mHidDevice != null) {
            mHidDevice.connect(BluetoothAdapter.getDefaultAdapter().getRemoteDevice(macAddress));
        }
    }

    // 断开蓝牙连接
    public void stop() {
        if (mHidDevice != null) {
            mHidDevice.unregisterApp();
        }
    }

    // 向Flutter端发送消息
    public void sendToFlutter(String method, Object arguments) {
        // 需要切换到主线程中
        mActivity.runOnUiThread(() -> mChannel.invokeMethod(method, arguments));
    }

    // 向主机端发送报告描述符
    public void sendData(int id, byte[] data) {
        if (mHostDevice != null && mHidDevice != null) {
            mHidDevice.sendReport(mHostDevice, id, data);
        }

    }

    /*
    -------------------------------------
    蓝牙HID 键盘按键
    -------------------------------------
    */

    // 键盘按键按压
    public void sendKeyWithRelease(String key) {
        byte b1 = 0;
        if (key.length() <= 1) {
            char keyChar = key.charAt(0);
            if ((keyChar >= 65) && (keyChar <= 90)) {
                b1 = 2;
            }
        }

        if (BluetoothKeyboard.SHITBYTE.containsKey(key)) {
            b1 = 2;
        }

        sendData(8, new byte[]{b1, 0, BluetoothKeyboard.KEY2BYTE.get(key.toUpperCase())});  // 按下对应键
        sendData(8, new byte[]{0, 0, 0});   // 松开对应键
    }

    /*
    -------------------------------------
    蓝牙HID 媒体控制
    -------------------------------------
    */

    public void mediaControl(String action){
        // 1:播放 2:打开win10的Groove音乐 4~6:下一首 8~14:上一首 16~31:音量- 32~62:音量+ 64~:静音
        byte[] data = new byte[]{};
        switch (action){
            case "MediaControl.playOrPause":
                data = new byte[]{(byte) 0x01};
                break;
            case "MediaControl.nextTrack":
                data = new byte[]{(byte) 0x04};
                break;
            case "MediaControl.previousTrack":
                data = new byte[]{(byte) 0x0D};
                break;
            case "MediaControl.volumeDown":
                data = new byte[]{(byte) 0x10};
                break;
            case "MediaControl.volumeUp":
                data = new byte[]{(byte) 0x20};
                break;
            case "MediaControl.mute":
                data = new byte[]{(byte)0x40};
                break;
            default:
                break;
        }
        sendData(3,data);
        sendData(3,new byte[]{0});
    }


    /*
    -------------------------------------
    蓝牙连接的监听事件
    -------------------------------------
    */

    // 应用注册状态改变时的回调
    // 一般在 mHidDevice.registerApp() 和 mHidDevice.unregisterApp()方法之后回调
    @Override
    public void onAppStatusChanged(BluetoothDevice pluggedDevice, boolean registered) {
        super.onAppStatusChanged(pluggedDevice, registered);

        // registered 表示是否注册成功
        if (registered) {
            sendToFlutter("hidStatusCall", true);
        } else {
            sendToFlutter("hidStatusCall", false);
        }
    }


    // 与远程主机的连接状态发生更改时的回调
    @Override
    public void onConnectionStateChanged(BluetoothDevice device, int state) {
        super.onConnectionStateChanged(device, state);
        if (state == BluetoothProfile.STATE_CONNECTED) {
            // 已连接
            if (device != null) {
                mHostDevice = device;
                sendToFlutter("blueStatusCall", true);
            }
        } else if (state == BluetoothProfile.STATE_DISCONNECTED) {
            mHostDevice = null;
            sendToFlutter("blueStatusCall", false);
        } else {
            mHostDevice = null;
        }
    }

}
