import 'dart:io';

import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied()
abstract class Env {
  @EnviedField(varName: 'firebaseiOSApiKey')
  static const String firebaseiOSApiKey = _Env.firebaseiOSApiKey;

  @EnviedField(varName: 'firebaseAndroidApiKey')
  static const String firebaseAndroidApiKey = _Env.firebaseAndroidApiKey;

  @EnviedField(varName: 'firebaseiOSAppId')
  static const String firebaseiOSAppId = _Env.firebaseiOSAppId;

  @EnviedField(varName: 'firebaseAndroidAppId')
  static const String firebaseAndroidAppId = _Env.firebaseAndroidAppId;

  @EnviedField(varName: 'firebaseMessagingSenderId')
  static const String firebaseMessagingSenderId =
      _Env.firebaseMessagingSenderId;

  @EnviedField(varName: 'firebaseProjectId')
  static const String firebaseProjectId = _Env.firebaseProjectId;

  @EnviedField(varName: 'encryptKey')
  static const String encryptKey = _Env.encryptKey;

  @EnviedField(varName: 'encryptIV')
  static const String encryptIV = _Env.encryptIV;

  static String get firebaseAppId =>
      Platform.isIOS ? _Env.firebaseiOSAppId : _Env.firebaseAndroidAppId;

  static String get firebaseApiKey =>
      Platform.isIOS ? _Env.firebaseiOSApiKey : _Env.firebaseAndroidApiKey;
}
