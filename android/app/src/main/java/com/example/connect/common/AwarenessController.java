package com.example.connect.common;
import android.accessibilityservice.AccessibilityService;
import android.annotation.SuppressLint;
import android.app.admin.DevicePolicyManager;
import android.content.Context;
import android.os.PowerManager;
import android.view.WindowManager;

public class AwarenessController  {
    private Object mSystemService;
    private PowerManager.WakeLock localWakeLock = null;//电源锁

    public AwarenessController(Object mSystemService){
        this.mSystemService = mSystemService;
    }

    @SuppressLint("InvalidWakeLockTag")

    public void init(){
        //获取系统服务POWER_SERVICE，返回一个PowerManager对象
        //屏幕开关
        //电源管理对象
        PowerManager localPowerManager = (PowerManager) mSystemService;
        //获取PowerManager.WakeLock对象,后面的参数|表示同时传入两个值,最后的是LogCat里用的Tag
        localWakeLock = localPowerManager.newWakeLock(PowerManager.PROXIMITY_SCREEN_OFF_WAKE_LOCK, "MyPower");//第一个参数为电源锁级别，第二个是日志ta
    }

    public void releaseLock(){
            localWakeLock.setReferenceCounted(false);
            localWakeLock.release(); // 释放设备电源锁


    }


    public void lock(){
            localWakeLock.acquire();// 申请设备电源锁
    }

    // 释放电源锁
    public void onDestroy(){
        localWakeLock.release();
    }


}