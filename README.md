# Connect



- [Connect](#connect)
  - [关于Connect](#关于connect)
  - [安装](#安装)
    - [配置Connect App端](#配置connect-app端)
    - [配置Connect Server端](#配置connect-server端)
  - [使用](#使用)
  - [帮助](#帮助)
    - [常见问题](#常见问题)
      - [1. 为什么手机端无法与电脑进行蓝牙配对?](#1-为什么手机端无法与电脑进行蓝牙配对)
      - [2. 蓝牙配对成功但连接失败？](#2-蓝牙配对成功但连接失败)
      - [3. 为什么App有些功能无法使用?](#3-为什么app有些功能无法使用)
      - [4. 为什么App切后台, TCP连接就断开](#4-为什么app切后台-tcp连接就断开)
    - [手势操作](#手势操作)
      - [主页指示条](#主页指示条)
      - [主页空白区域](#主页空白区域)
  - [更新日志](#更新日志)



## 关于Connect

![IMG_20220827_212155](https://gitee.com/liuxiyuan_2022/flutter_test/raw/master/lib/assets/imgs/202208272125829.jpg)



**[温馨提示]**

1. 手机端必须基于Android 9.0 及以上版本
2. 电脑端和手机端需支持蓝牙连接
3. App大部分功能实现基于蓝牙HID协议, 请检查手机是否适配蓝牙HID



## 安装

先将项目克隆到本地: 

```bash
git clone https://github.com/liuxiyuan-2022/connect.git
```

> 以下步骤需配置Flutter环境, 详细环境配置请参考[Flutter官方文档](https://docs.flutter.dev/get-started/install)



### 配置Connect App端

> Flutter=3.0.4

1. 在项目目录下执行命令, 安装项目所需依赖 :

   ```bash
   flutter pub get
   ```



2. 接入HUAWEI HMS Core服务 :

  - [快速开始](https://developer.huawei.com/consumer/en/doc/development/HMS-Plugin-Guides/prepare-dev-env-0000001052511642)
  - [API参考](https://developer.huawei.com/consumer/en/doc/development/HMS-Plugin-References/overview-0000001052975193?ha_source=hms1)
  - [这是我接入HMS Core 遇到的问题, 或许能帮助到你.](https://github.com/liuxiyuan-2022/connect/blob/main/Flutter%203.0%20%E9%9B%86%E6%88%90%20HMS%20ML%20%E5%9D%91%E7%82%B9.md)




2. 将`lib\controller\services\speech_recognition_controller.dart` 的`setApikey()`的对应字符串替换为自己的API密钥 :

   ```dart
	/// 设置APP的HMS ML apiKey
   void setApiKey() {
   	MLLanguageApp().setApiKey('你的API密钥');
   }
   ```
   
   > 你的ApiKey可以在 **agconnect-services.json**文件里找到, 或者进入 **AppGallery Connect** 查看.
   
   
   
3. 将你的一张面部照片复制到`assets\images\`目录下, 并重命名为`face_template.jpg` , 用以面部解锁. 

   > 建议使用 1 : 1的图片比例, 并确保面部清晰.




4. 将项目打包为Android apk :

  ```bash
  flutter build apk
  ```

  > 本项目没有对ios端进行适配, 有能力的同学可自行适配并打包为ios应用.
  >
  > APK文件位置: `build\app\outputs\flutter-apk\app-release.apk`

  

### 配置Connect Server端

> python=3.7

1. 安装pyhook

   - 访问[网址链接](https://www.lfd.uci.edu/~gohlke/pythonlibs/), 在搜索栏搜索`pyHook`, 下载对应文件`pyHook‑1.5.1‑cp37‑cp37m‑win_amd64.whl`并保存到本地.
   - 运行`pip install D:\Download\pyHook-1.5.1-cp37-cp37m-win_amd64.whl(本地文件路径)`命令




2. 安装其他python所需的第三方库

   ```bash
   pip install pyperclip
   pip install win32 //如果使用Anaconda3则无需安装
   pip install PyUserInput	// 需先安装pyHook和win32
   ```



3. 用记事本打开`connect\connectServer`目录下的`connectServer.bat`文件.

   然后将`python D:\DeveloperTools\code\Flutter\connect\connectServer\main.py` 的路径修改为当前`main.py`所在的路径 : 

	```
	@echo off
	if "%1" == "h" goto begin
	mshta vbscript:createobject("wscript.shell").run("""%~0"" h",0)			(window.close)&&exit
	:begin

	python 当前main.py的路径
	pause
	```
	
	> 如果使用Anaconda3配置Python环境, 则在`:begin`字段下行添加`CALL activate 环境名`
	
	
	
4. 将`connectServer.bat`文件复制到`C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp`目录下 : 

	> 此步骤杀毒软件会阻止，选择允许，然后重启电脑即可.
  
  

5. Connect Server服务可以在**任务管理器**的**启动**中找到: `connectServer.bat`



## 帮助

### 常见问题

> 使用前请确保App正确设置 `IP Address` 和 `MAC Address`



#### 1. 为什么手机端无法与电脑进行蓝牙配对?

- 在手机端和电脑端，分别取消对应端的蓝牙配对。 然后重启App等待自动配对。
- 若App无法自动配对, 尝试保持App位于前台, 在电脑端手动搜索手机进行蓝牙配对.



#### 2. 蓝牙配对成功但连接失败？

- 部分国内手机厂商的机型不兼容蓝牙HID，请在使用App之前检查你的设备**是否兼容蓝牙HID协议**。
- 检查电脑端和手机端是否支持蓝牙连接。
- 检查App的`Settings`中的`MAC Address`是否正确。
- 尝试分别删除蓝牙设备, 并重启应用进行蓝牙配对连接。

> 推荐谷歌商店下载应用: [Bluetooth HID Profile Tester](https://play.google.com/store/apps/details?id=com.rdapps.bluetoothhidtester) 检测手机是否兼容蓝牙HID。



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

> 在空白区域内, 三指捏合



新建桌面

> 在空白区域内, 双指张开



切换桌面

> 在空白区域内, 长按并左右滑动



null

> 在空白区域内双指轻旋



从电脑复制选中的文本至手机剪切板

> 在空白区域内双击





## 更新日志

[点击查看](https://github.com/liuxiyuan-2022/connect/blob/main/CHANGELOG.md)

