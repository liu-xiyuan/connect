import 'package:connect/controller/text_field_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  static SettingsController get to => Get.find();

  late SharedPreferences prefs;
  String? lockPassword = '';

  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    init();
  }

  /// 初始化设置
  void init() {
    lockPassword = prefs.getString('lockPwd');
  }

  /// 更新锁屏密码
  void updateLockPassword() async {
    lockPassword = TextFieldController.to.editController.text;

    await prefs.setString('lockPwd', lockPassword!);
  }
}
