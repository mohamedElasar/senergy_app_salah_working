// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:senergy/Screens/LogIN/login_logo.dart';
import 'package:senergy/constants.dart';
import '../../Navigation/screens.dart';
import 'login_form.dart';

// ignore: camel_case_types
class Login_Screen extends StatelessWidget {
  static MaterialPage page() {
    return MaterialPage(
      name: Senergy_Screens.loginpath,
      key: ValueKey(Senergy_Screens.loginpath),
      child: const Login_Screen(),
    );
  }

  const Login_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: senergyColorg,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Login_Logo(
                size: size,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
              ),
              const Login_Form()
            ],
          ),
        ),
      ),
    );
  }
}
