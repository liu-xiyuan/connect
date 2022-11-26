package com.example.connect;

import android.app.admin.DevicePolicyManager;
import android.content.Context;
import android.os.Bundle;
import android.os.PowerManager;
import android.view.WindowManager;

import androidx.annotation.Nullable;

import com.example.connect.common.AwarenessController;
import com.example.connect.common.BluetoothClient;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    BluetoothClient bluetoothClient;
    AwarenessController awareness;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }
    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        bluetoothClient = new BluetoothClient(this, flutterEngine.getDartExecutor().getBinaryMessenger());
//        awareness = new AwarenessController(getSystemService(Context.POWER_SERVICE));
//        awareness.init();

        DevicePolicyManager mDevicePolicyManager = (DevicePolicyManager) getSystemService(Context.DEVICE_POLICY_SERVICE);


        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "android.flutter/Awareness")
                .setMethodCallHandler(
                        (call, result) -> {
                            switch (call.method){
                                case "closeScreen":
//                                    awareness.releaseLock();
                                    mDevicePolicyManager.lockNow();
//                                    this.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);//灭屏
                                    break;

                                case "openScreen":

//                                    awareness.lock();
                                    break;

                                case "onDestroy":
                                    awareness.onDestroy();

                                default:
                                    result.notImplemented();
                                    break;
                            }
                        });

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "android.flutter/Bluetooth")
                .setMethodCallHandler(
                        (call, result) -> {
                            switch (call.method) {
                                case "initHidDevice":
                                    bluetoothClient.initHidDevice(getContext());
                                    break;

                                case "connect":
                                    bluetoothClient.connect((String) call.arguments);
                                    break;

                                case "sendKeyWithRelease":
                                    bluetoothClient.sendKeyWithRelease((String) call.arguments);
                                    break;

                                case "sendKey":
                                    bluetoothClient.sendKey((String) call.arguments);
                                    break;

                                case "sendKeyRelease":
                                    bluetoothClient.sendKeyRelease();
                                    break;

                                case "mediaControl":
                                    bluetoothClient.mediaControl((String) call.arguments);
                                    break;
                                case "test":
                                    break;
                                default:
                                    result.notImplemented();
                                    break;
                            }
                        });
    }


}
