import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shoppingapp/models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expirydate;
  String? _userId;

  bool get isAuth {
    return token != null;
  }

  String? get userId {
    return _userId;
  }

  String? get token {
    if (_expirydate != null &&
        _expirydate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authincate(
      String email, String password, String urlsegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlsegment?key=AIzaSyAIIToqSAqitbLu6q0tpnBTU6PZooPZacI');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      // print(
      //   json.decode(response.body),
      // );
      final resposedata = json.decode(response.body);
      if (resposedata['error'] != null) {
        throw HttpException(resposedata['error']['message']);
      }
      _token = resposedata['idToken'];
      _userId = resposedata['localId'];
      _expirydate = DateTime.now().add(
        Duration(
          seconds: int.parse(resposedata['expiresIn']),
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authincate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authincate(email, password, 'signInWithPassword');
  }
}
