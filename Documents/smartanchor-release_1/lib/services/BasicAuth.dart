import 'dart:convert';

import '../configurations/AppConfigs.dart';

String basicAuth =
    'Basic ${base64Encode(utf8.encode('${AppConfigs.username}:${AppConfigs.password}'))}';
