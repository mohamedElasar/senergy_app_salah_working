import 'package:flutter/material.dart';

// ignore: camel_case_types
class Login_Logo extends StatelessWidget {
  const Login_Logo({Key? key, this.size}) : super(key: key);
  final size;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: size.height * .35,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 60),
      alignment: Alignment.center,
      child: Image.asset(
        'assets/images/senergy.png',
        fit: BoxFit.fill,
        width: double.infinity,
      ),
    );
  }
}
