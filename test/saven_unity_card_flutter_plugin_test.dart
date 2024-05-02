import 'package:flutter_test/flutter_test.dart';
import 'package:saven_unity_card_flutter_plugin/saven_unity_card_flutter_plugin.dart';
import 'package:saven_unity_card_flutter_plugin/saven_unity_card_flutter_plugin_platform_interface.dart';
import 'package:saven_unity_card_flutter_plugin/saven_unity_card_flutter_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSavenUnityCardFlutterPluginPlatform
    with MockPlatformInterfaceMixin
    implements SavenUnityCardFlutterPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SavenUnityCardFlutterPluginPlatform initialPlatform = SavenUnityCardFlutterPluginPlatform.instance;

  test('$MethodChannelSavenUnityCardFlutterPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSavenUnityCardFlutterPlugin>());
  });

  test('getPlatformVersion', () async {
    SavenUnityCardFlutterPlugin savenUnityCardFlutterPlugin = SavenUnityCardFlutterPlugin();
    MockSavenUnityCardFlutterPluginPlatform fakePlatform = MockSavenUnityCardFlutterPluginPlatform();
    SavenUnityCardFlutterPluginPlatform.instance = fakePlatform;

    expect(await savenUnityCardFlutterPlugin.getPlatformVersion(), '42');
  });
}
