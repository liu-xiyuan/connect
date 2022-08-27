import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutController extends GetxController {
  late PackageInfo packageInfo;

  var appName = ''.obs;
  var packageName = ''.obs;
  var version = ''.obs;
  var buildNumber = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    initPackageInfo();
  }

  // /// 初始化App信息
  void initPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();

    appName.value = packageInfo.appName;
    packageName.value = packageInfo.packageName;
    version.value = packageInfo.version;
    buildNumber.value = packageInfo.buildNumber;
    // log('appName:$appName | packageName:$packageName | version:$version | buildNumber:$buildNumber');
  }
}
