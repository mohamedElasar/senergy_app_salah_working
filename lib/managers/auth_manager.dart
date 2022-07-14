// ignore_for_file: file_names, unused_import

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../httpexception.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// ignore: camel_case_types
class Auth_manager extends ChangeNotifier {
  String? token;
  int? _userId;
  String? _userEmail;
  String? _username;
  bool? _isAdmin;

  bool get isLoggedIn => token != null;
  int? get userid => _userId;
  String? get useremail => _userEmail;
  String? get username => _username;
  bool? get isAdmin => _isAdmin;

  late FirebaseMessaging messaging;

  Future<void> login(String email, String password) async {
    var url = Uri.http('10.0.2.2:5000', '/api/users/signin/');
    try {
      var response = await http.post(
        url,
        body: {'email': email, 'password': password},
        headers: {'Accept': 'application/json'},
      );
      final responseData = json.decode(response.body);
      postDeviceToken();

      if (responseData['message'] != null) {
        throw HttpException(responseData['message']);
      }
      token = responseData['token'];
      _userId = responseData['_id'];
      _userEmail = responseData['email'];
      _username = responseData['name'];
      _isAdmin = responseData['isAdmin'];
    } catch (error) {
      rethrow;
    }

    notifyListeners();
  }

  void logout() async {
    token = null;
    _userEmail = null;

    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<void> rememberMe() async {
    final prefs = await SharedPreferences.getInstance();

    final userData = json.encode(
      {
        'token': token,
        'userId': _userId,
        'userEmail': _userEmail,
        'isAdmin': _isAdmin,
        'username': _username,
        // 'student': _studentUser!.toJson()
      },
    );
    prefs.setString('userData', userData);
  }

  Future<bool> tryAutoLogin() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      print('object');
      return false;
    }
    final extractedData = prefs.getString('userData');
    final data = (json.decode(extractedData!));
    print(data);

    token = data['token'];
    _userId = data['userId'];
    _userEmail = data['userEmail'];
    _username = data['username'];
    _isAdmin = data['isAdmin'];

    notifyListeners();
    return true;
  }

  void testLogin() {
    token = '123';
    notifyListeners();
  }

  void postDeviceToken() async {
    var url = Uri.http('10.0.2.2:5000', '/api/notifications/token/admin/');

    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) async {
      try {
        var response = await http.post(
          url,
          body: {
            'token': value,
            'isAdmin': _isAdmin.toString(),
            '_id': _userId.toString()
          },
          headers: {'Accept': 'application/json'},
        );
        // print(response.body);
      } catch (e) {
        print(e);
      }
    });
    notifyListeners();
  }

  Future<void> sendNotification(String title, String message) async {
    var url = Uri.http('10.0.2.2:5000', '/api/notifications/token/admin/send');

    try {
      var response = await http.post(
        url,
        body: {'title': title, 'message': message},
        headers: {'Accept': 'application/json'},
      );
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }
}
