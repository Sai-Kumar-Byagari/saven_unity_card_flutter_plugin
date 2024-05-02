
import 'saven_unity_card_flutter_plugin_platform_interface.dart';

class SavenUnityCardFlutterPlugin {
  Future<String?> getPlatformVersion() {
    return SavenUnityCardFlutterPluginPlatform.instance.getPlatformVersion();
  }
}
