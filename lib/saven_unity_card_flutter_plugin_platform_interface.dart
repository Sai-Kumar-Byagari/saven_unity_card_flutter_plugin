import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'saven_unity_card_flutter_plugin_method_channel.dart';

abstract class SavenUnityCardFlutterPluginPlatform extends PlatformInterface {
  /// Constructs a SavenUnityCardFlutterPluginPlatform.
  SavenUnityCardFlutterPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static SavenUnityCardFlutterPluginPlatform _instance = MethodChannelSavenUnityCardFlutterPlugin();

  /// The default instance of [SavenUnityCardFlutterPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelSavenUnityCardFlutterPlugin].
  static SavenUnityCardFlutterPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SavenUnityCardFlutterPluginPlatform] when
  /// they register themselves.
  static set instance(SavenUnityCardFlutterPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
