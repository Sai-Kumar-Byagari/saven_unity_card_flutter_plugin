import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'saven_unity_card_flutter_plugin_platform_interface.dart';

/// An implementation of [SavenUnityCardFlutterPluginPlatform] that uses method channels.
class MethodChannelSavenUnityCardFlutterPlugin extends SavenUnityCardFlutterPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('saven_unity_card_flutter_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
