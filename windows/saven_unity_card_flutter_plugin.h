#ifndef FLUTTER_PLUGIN_SAVEN_UNITY_CARD_FLUTTER_PLUGIN_H_
#define FLUTTER_PLUGIN_SAVEN_UNITY_CARD_FLUTTER_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace saven_unity_card_flutter_plugin {

class SavenUnityCardFlutterPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  SavenUnityCardFlutterPlugin();

  virtual ~SavenUnityCardFlutterPlugin();

  // Disallow copy and assign.
  SavenUnityCardFlutterPlugin(const SavenUnityCardFlutterPlugin&) = delete;
  SavenUnityCardFlutterPlugin& operator=(const SavenUnityCardFlutterPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace saven_unity_card_flutter_plugin

#endif  // FLUTTER_PLUGIN_SAVEN_UNITY_CARD_FLUTTER_PLUGIN_H_
