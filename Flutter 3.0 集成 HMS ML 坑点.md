# Flutter 3.0 集成 HMS ML 坑点

### 使用Flutter3.0构建项目时, 提示`需要使用JAVA 11`

https://www.icode9.com/content-1-1387460.html



### 1. AGCPluginTask 中 randomEncryptComponent 属性不应使用 @Optional 进行注释

- **原因**: 当前使用的HMS的 **Marven** 库版本较低，与升级后的 **Gradle** 不兼容；

- **解决**: 在 `android\build.gradle` 文件中将`classpath 'com.huawei.agconnect:agcp:1.4.2.301'` 更改为 `classpath 'com.huawei.agconnect:agcp:1.5.2.300'`

```
buildscript {
    ext.kotlin_version = '1.6.10'
    repositories {
        google()
        jcenter()        
        maven { url 'https://developer.huawei.com/repo/' }
    }

    dependencies {
        classpath 'com.android.tools.build:gradle:7.1.2'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        classpath 'com.huawei.agconnect:agcp:1.5.2.300'
    }
}

allprojects {
	....
```

### 2.应用在debug模式下闪退

- 原因: flutter 3.0下的编译的Android api版本有问题
- 解决: 在`android\app\build.gradle`文件中, 尝试指定`targetSdkVersion` 和 `minSdkVersion` 版本

```
    defaultConfig {
		...
		
        minSdkVersion 19
        targetSdkVersion 30
        
        ...
    }
```

### 3. 集成ML Language 语音识别API 后, 应用闪退.

- 原因: 检查是否在调用服务之前设置了APP的 apiKey
- 解决: 在使用服务前调用` MLLanguageApp().setApiKey(apiKey)`, 来设置apiKey

```dart
MLLanguageApp().setApiKey(apiKey);
```

> 你的apiKey可以在 **agconnect-services.json**文件里找到, 或者进入 **AppGallery Connect** 查看









