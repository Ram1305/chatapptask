import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/message.dart';
import '../constants/app_constants.dart';

class StorageService {
  static Future<void> saveUsers(List<User> users) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = users.map((u) => json.encode(u.toJson())).toList();
    await prefs.setStringList(AppConstants.usersKey, jsonList);
  }

  static Future<List<User>> loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(AppConstants.usersKey) ?? [];
    return jsonList.map((s) => User.fromJson(json.decode(s))).toList();
  }

  static Future<void> saveMessages(String userId, List<Message> messages) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = messages.map((m) => json.encode(m.toJson())).toList();
    await prefs.setStringList('${AppConstants.messagesKey}_$userId', jsonList);
  }

  static Future<List<Message>> loadMessages(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('${AppConstants.messagesKey}_$userId') ?? [];
    return jsonList.map((s) => Message.fromJson(json.decode(s))).toList();
  }
}

