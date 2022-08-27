# Connect

[TOC]

## 关于Connect



**[温馨提示]**

1. 手机端必须基于Android 9.0 及以上版本
2. 手机端和电脑端需支持蓝牙连接
3. App大部分功能实现基于蓝牙HID协议, 请检查手机是否适配蓝牙HID



## 安装

### Connect App

1. 在项目目录下输入命令, 下载项目所需依赖 :

```dart
flutter pub get
```

2. 接入 HUAWEI HMS Core 服务 :

  - [快速开始](https://developer.huawei.com/consumer/en/doc/development/HMS-Plugin-Guides/prepare-dev-env-0000001052511642)
  - [API参考](https://developer.huawei.com/consumer/en/doc/development/HMS-Plugin-References/overview-0000001052975193?ha_source=hms1)
  - [这是我接入HMS Core 遇到的问题, 或许能帮助到你.]()

3. 将`lib\controller\services\speech_recognition_controller.dart` 的`setApikey()`的对应字符串替换为自己的API密钥 :

   API密钥信息可以在 **AppGallery Connect**  的 **我的项目** 中找到.

```dart
/// 设置APP的HMS ML apiKey
void setApiKey() {
	MLLanguageApp().setApiKey(
      '你的API密钥',
    );
}
```

4. 将你的一张面部照片复制到`assets\images\`目录下, 并重命名为`face_template.jpg` , 用以面部解锁. (建议使用 1 : 1的图片比例, 并确保面部清晰).

5. 在项目目录下输入命令, 将项目打包为Android apk :

   - 本项目没有对ios端进行适配, 有能力的同学可自行适配并打包为ios应用

   - APK文件位置: `build\app\outputs\flutter-apk\app-release.apk`

```
flutter build apk
```

​	

### Connect Server



## 帮助

### 常见问题

#### 1. 为什么手机端无法与电脑进行蓝牙配对?

在手机端和电脑端，分别取消对应端的蓝牙配对。 然后重启App重新操作。



#### 2. 蓝牙配对成功但连接失败？

部分国内手机厂商的机型不兼容蓝牙HID，请在使用App之前检查你的设备是否支持蓝牙HID协议。

推荐谷歌商店下载应用: [Bluetooth HID Profile Tester](https://play.google.com/store/apps/details?id=com.rdapps.bluetoothhidtester) 检测。



#### 3. 为什么App有些功能无法使用?

大多数功能仅需使用TCP服务，部分功能需同时使用TCP和蓝牙服务。确保你的两个服务都处于连接状态。



#### 4. 为什么App切后台, TCP连接就断开

在手机设置的电池管理中将App设为[允许后台高耗电]



### 手势操作

#### 主页指示条

模拟Enter键

> 双击指示条





模拟上下左右方向键

> 在指示条区域内上下左右滑动



调出App快捷功能栏

> 长按指示条



#### 主页空白区域

打开多桌面切换页面

> 在空白区域内, 双指捏合



新建桌面

> 在空白区域内, 双指张开



切换桌面

> 在空白区域内, 长按并左右滑动



?

> 在空白区域内双指轻旋



从电脑复制选中的文本至手机剪切板

> 在空白区域内双击





## 更新日志

**[1.1.0]**

------

[新增] 文本复制手势 

