import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../models/user.dart';
import '../models/message.dart';

class ApiService {
  static Future<Map<String, dynamic>> fetchCommentsData() async {
    try {
      final response = await http.get(
        Uri.parse(AppConstants.commentsApi),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      }
    } catch (e) {
      print('API Error: $e');
    }
    return {};
  }

  static Future<List<User>> fetchUsersFromComments() async {
    try {
      final data = await fetchCommentsData();
      if (data['comments'] != null && data['comments'] is List) {
        final comments = data['comments'] as List;
        final Map<String, User> usersMap = {};
        
        for (var comment in comments) {
          if (comment['user'] != null) {
            final userData = comment['user'];
            final userId = userData['id'].toString();
            final userName = userData['fullName'] ?? userData['username'] ?? 'Unknown';
            
            if (!usersMap.containsKey(userId)) {
              usersMap[userId] = User(
                id: userId,
                name: userName,
                isOnline: false,
              );
            }
          }
        }
        
        return usersMap.values.toList();
      }
    } catch (e) {
      print('Error fetching users: $e');
    }
    return [];
  }

  static Future<Map<String, List<Message>>> fetchMessagesFromComments() async {
    try {
      final data = await fetchCommentsData();
      final Map<String, List<Message>> messagesMap = {};
      
      if (data['comments'] != null && data['comments'] is List) {
        final comments = data['comments'] as List;
        
        for (var comment in comments) {
          if (comment['user'] != null && comment['body'] != null) {
            final userData = comment['user'];
            final userId = userData['id'].toString();
            final commentBody = comment['body'] as String;
            final commentId = comment['id'].toString();
            
         
            final message = Message(
              text: commentBody,
              isSender: false,
              timestamp: DateTime.now().subtract(
                Duration(minutes: Random().nextInt(1440)),
              ),
              userId: userId,
            );
            
            if (!messagesMap.containsKey(userId)) {
              messagesMap[userId] = [];
            }
            messagesMap[userId]!.add(message);
          }
        }
      }
      
      return messagesMap;
    } catch (e) {
      print('Error fetching messages: $e');
    }
    return {};
  }

  static Future<String> getRandomMessage() async {
    try {
      final data = await fetchCommentsData();
      if (data['comments'] != null && data['comments'] is List) {
        final comments = data['comments'] as List;
        if (comments.isNotEmpty) {
          
          final randomIndex = Random().nextInt(comments.length);
          final comment = comments[randomIndex];
          return comment['body'] ?? AppConstants.defaultMessage;
        }
      }
    } catch (e) {
      print('API Error: $e');
    }
    return AppConstants.defaultMessage;
  }
}

