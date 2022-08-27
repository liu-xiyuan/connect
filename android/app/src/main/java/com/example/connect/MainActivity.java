package com.example.connect;

import android.os.Bundle;

import androidx.annotation.Nullable;

import com.example.connect.common.BluetoothClient;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    BluetoothClient bluetoothClient;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        bluetoothClient = new BluetoothClient(this, flutterEngine.getDartExecutor().getBinaryMessenger());

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

                                case "sendKey":
                                    bluetoothClient.sendKeyWithRelease((String) call.arguments);
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
                        }
                );
    }


}
