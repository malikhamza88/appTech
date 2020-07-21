import 'dart:convert';

import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:login_example/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../utils/custom_route.dart';
import 'dashboard_screen.dart';
import '../models/users.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  static const routeName = '/auth';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  Future<void> _loginUser(LoginData data) async {
//    return Future.delayed(loginTime).then((_) {
//      if (!mockUsers.containsKey(data.name)) {
//        return 'Username not exists';
//      }
//      if (mockUsers[data.name] != data.password) {
//        return 'Password does not match';
//      }
//      return null;
//    });
  }

  Future<String> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      if (!mockUsers.containsKey(name)) {
        return 'nom n\'est pas valide';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);

    final inputBorder = BorderRadius.vertical(
      bottom: Radius.circular(10.0),
      top: Radius.circular(20.0),
    );

    return FlutterLogin(
      title: Constants.appName,
      logo: 'assets/images/ecorp.png',
      logoTag: Constants.logoTag,
      titleTag: Constants.titleTag,
      emailValidator: (value) {
//        if (!value.contains('@') || !value.endsWith('.com')) {
//          return "Email must contain '@' and end with '.com'";
//        }
        return null;
      },
      passwordValidator: (value) {
        return null;
      },
      onLogin: (loginData) async {
        if (loginData.name.isEmpty) {
          return 'nom n\'est pas valide';
        }
        if (loginData.password.isEmpty) {
          return "mot de passe vide !!";
        }
        String token =
            await provider.loginUser(loginData.name, loginData.password);
        return token;
      },
      onSignup: (loginData) {
        print('Registre');
        print('Name: ${loginData.name}');
        print('Mot de passe: ${loginData.password}');
        return _loginUser(loginData);
      },
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(
          FadePageRoute(
            builder: (context) => DashboardScreen(),
          ),
        );
      },
      onRecoverPassword: (name) {
        print('Recover password info');
        print('Name: $name');
        return _recoverPassword(name);
        // Show new password dialog
      },
      showDebugButtons: true,
    );
  }
}
