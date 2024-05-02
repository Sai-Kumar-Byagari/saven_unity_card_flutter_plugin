#include "include/saven_unity_card_flutter_plugin/saven_unity_card_flutter_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "saven_unity_card_flutter_plugin.h"

void SavenUnityCardFlutterPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  saven_unity_card_flutter_plugin::SavenUnityCardFlutterPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
