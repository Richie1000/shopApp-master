import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/http_exeption.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  static const apiKey = 'AIzaSyBSCyDq_1t6N7GPj74ZObVi4FkyfuYCKts';

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId{
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String address) async {
    Uri url = Uri.parse('${address}${apiKey}');
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      //print(json.decode(response.body));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> Signup(String email, String password) async {
    final String address =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=';
    return _authenticate(email, password, address);
  }

  Future<void> Signin(String email, String password) async {
    final String address =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=';
    return _authenticate(email, password, address);
  }
}
