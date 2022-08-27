import 'package:connect/controller/services/tcp_service_controller.dart';
import 'package:connect/controller/text_field_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  static SettingsController get to => Get.find();

  late SharedPreferences prefs;
  RxString ipAddress = ''.obs;
  RxString macAddress = ''.obs;
  String? lockPassword = '';

  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    init();
  }

  /// 初始化设置
  void init() {
    ipAddress.value =
        '${prefs.getString('host') ?? '192.168.0.10'}:${prefs.getInt('port') ?? 8888}';
    macAddress.value = prefs.getString('mac') ?? '34:7D:F6:56:C1:5F';
    lockPassword = prefs.getString('lockPwd');
  }

  /// 更新IP地址
  void updateIpAddress() async {
    List data = TextFieldController.to.editController.text.split(':');
    TcpServiceController.to.host = data[0];
    TcpServiceController.to.port = int.parse(data[1]);
    ipAddress.value = TextFieldController.to.editController.text;

    // 持久化保存
    await prefs.setString('host', data[0]);
    await prefs.setInt('port', int.parse(data[1]));
  }

  /// 更新MAC地址
  void updateMacAddress() async {
    macAddress.value = TextFieldController.to.editController.text;

    await prefs.setString('mac', macAddress.value);
  }

  /// 更新锁屏密码
  void updateLockPassword() async {
    lockPassword = TextFieldController.to.editController.text;

    await prefs.setString('lockPwd', lockPassword!);
  }
}
