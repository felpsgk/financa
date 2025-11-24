import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionStorage {
  const SessionStorage();

  Future<void> writeString({required String key, required String value}) async {
    if (kIsWeb) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
      return;
    }
    const FlutterSecureStorage storage = FlutterSecureStorage();
    await storage.write(key: key, value: value);
  }

  Future<String?> readString({required String key}) async {
    if (kIsWeb) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    }
    const FlutterSecureStorage storage = FlutterSecureStorage();
    return storage.read(key: key);
  }

  Future<void> delete({required String key}) async {
    if (kIsWeb) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
      return;
    }
    const FlutterSecureStorage storage = FlutterSecureStorage();
    await storage.delete(key: key);
  }
}