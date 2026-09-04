import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import 'dart:convert';
import 'fcm_config.dart';

class NotificationService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // 1. Permission request
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted notification permission');
      
      String? token = await _fcm.getToken();
      if (token != null) {
        await _saveTokenToSupabase(token);
      }
    }

    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await _localNotifications.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
    });
  }

  static Future<void> _saveTokenToSupabase(String token) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      try {
        await Supabase.instance.client.from('users').update({
          'fcm_token': token,
        }).eq('id', user.id);
      } catch (e) {
        print('Error saving token to Supabase: $e');
      }
    }
  }

  static void _showLocalNotification(RemoteMessage message) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'dynetix_channel', 'Dynetix Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    _localNotifications.show(
      0,
      message.notification?.title ?? 'Dynetix Update',
      message.notification?.body ?? '',
      platformChannelSpecifics,
    );
  }

  /// Get OAuth 2.0 Access Token for FCM V1
  static Future<String> _getAccessToken() async {
    final accountCredentials = ServiceAccountCredentials.fromJson(FcmConfig.serviceAccountJson);
    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    
    final client = await clientViaServiceAccount(accountCredentials, scopes);
    final credentials = client.credentials;
    return credentials.accessToken.data;
  }

  /// Modern FCM V1 Broadcast Method
  static Future<void> sendNotificationToAll({required String title, required String body}) async {
    try {
      // 1. Get all tokens from Supabase
      final response = await Supabase.instance.client.from('users').select('fcm_token');
      final List<String> tokens = (response as List)
          .map((e) => e['fcm_token']?.toString() ?? '')
          .where((t) => t.isNotEmpty)
          .toList();

      if (tokens.isEmpty) {
        print('No FCM tokens found in database.');
        return;
      }

      // 2. Get Access Token
      final String accessToken = await _getAccessToken();
      final String projectId = FcmConfig.serviceAccountJson['project_id'];
      final String endpoint = 'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';

      int successCount = 0;
      for (String token in tokens) {
        final res = await http.post(
          Uri.parse(endpoint),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode({
            'message': {
              'token': token,
              'notification': {'title': title, 'body': body},
              'data': {
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'status': 'done',
              },
            }
          }),
        );
        if (res.statusCode == 200) successCount++;
        else print('Failed to send to $token: ${res.body}');
      }
      print('Notifications sent successfully to $successCount/${tokens.length} devices via FCM V1');
    } catch (e) {
      print('Error broadcasting notification: $e');
    }
  }

  static Future<void> updateDeviceToken() async {
    try {
      String? token = await _fcm.getToken();
      if (token != null) {
        await _saveTokenToSupabase(token);
      }
    } catch (e) {
      print('Failed to update device token: $e');
    }
  }
}
