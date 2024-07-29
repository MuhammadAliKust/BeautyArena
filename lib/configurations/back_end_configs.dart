import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../application/remote_config_provider.dart';

class BackendConfigs {
  static String apiUrl(BuildContext context) {
    var remoteConfigProvider = Provider.of<RemoteConfigProvider>(context,listen: false);
    return remoteConfigProvider.getRemoteConfig()!.baseUrl.toString() +
        '/api/v1/';
  }
}
