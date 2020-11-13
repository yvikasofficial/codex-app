import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NotificationProvider extends ChangeNotifier {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final FirebaseFirestore _firebaseDb = FirebaseFirestore.instance;
  final String serverToken =
      'AAAAXBAJfMU:APA91bGi26brFRU_8-sv6fHnJKj8k0phjMUFf7w5lGVxPyJakSVhmseW5AtLGJnQdhOvjouWnYwz-jPiLAON8lv1irUZPhjSIMUuhR6NZ6-rZ_sl5Eru53fSS62EuPnJJxZS4R5B8cz6';

  Future<void> subscribeTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  Future<void> unSubscribeTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  Future<void> saveUserDeviceToken(String uid) async {
    //Saving the user's device token to the firebase
    try {
      await _firebaseDb.collection("devices").doc(uid).set({
        "uid": uid,
        "token": await _firebaseMessaging.getToken(),
        "timestamp": Timestamp.now(),
      });
    } catch (e) {
      throw Exception(e.message ?? e.toString());
    }
  }

  Future<void> sendNotificationToUser(
      String uid, String title, String body) async {
    try {
      //Fetchs the device token associated to the uid(User ID)
      final doc = await _firebaseDb.collection("devices").doc(uid).get();

      //Sending the notification using Cloud Messaging APIs
      final res = await http.post(
        'https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            },
            'to': doc.data()['token'],
          },
        ),
      );
      print(res.statusCode);
    } catch (e) {
      throw Exception(e.message ?? e.toString());
    }
  }
}
