/// 向服务端发送的指令类别
enum TcpCommands {
  /// 鼠标操作
  mouseAction,

  /// 键盘操作
  keyboardAction,

  /// 语音操作
  speechAction,

  /// 其他
  otherAction,

  /// 心跳
  heartbeatAction,
}

/// 键盘事件
enum KeyboardAction {
  /// 按压组合键
  pressKeys,

  /// 网站缩放
  webpageZoom,
}

/// 语音事件
enum SpeechAction {
  /// 输入文字
  inputText,
}

/// 其他事件
enum OtherAction {
  /// 检查是否是锁屏页面
  checkLockScreen,

  /// 锁屏
  lockScreen,

  /// 复制文本到手机端
  copyText,

  /// 打开指定路径的应用
  openApplication,

  /// 定时关机
  timedShutdown,

  /// 复制翻译的目标文本至电脑端剪贴板
  copyTranslator
}
