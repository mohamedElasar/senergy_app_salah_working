import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senergy/managers/auth_manager.dart';

import '../../../../constants.dart';
import '../../httpexception.dart';

// ignore: camel_case_types
class Login_Form extends StatefulWidget {
  const Login_Form({Key? key}) : super(key: key);

  @override
  _Login_FormState createState() => _Login_FormState();
}

// ignore: camel_case_types
class _Login_FormState extends State<Login_Form> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  late FocusNode myFocusNode;

  var _isLoading = false;

  bool _rememberme = false;
  final Map<String, String> _authData = {
    'Email': '',
    'Password': '',
  };

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    // Provider.of<Auth_manager>(context, listen: false).testLogin();
    try {
      await Provider.of<Auth_manager>(context, listen: false).login(
          _authData['Email'].toString(), _authData['Password'].toString());
      if (_rememberme) {
        await Provider.of<Auth_manager>(context, listen: false).rememberMe();
      }
    } on HttpException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      print(error.toString());
      const errorMessage = 'try again later';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'ERROR',
          style: TextStyle(fontFamily: 'GE-Bold'),
        ),
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'GE-medium'),
        ),
        actions: <Widget>[
          Center(
            child: FlatButton(
              color: kbackgroundColor1,
              child: const Text(
                'OK',
                style: TextStyle(fontFamily: 'GE-medium'),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
            height: 55,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: kTextColor1,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextFormField(
              style: const TextStyle(
                  fontSize: 20, fontFamily: 'AraHamah1964R-Bold'),
              textAlign: TextAlign.left,
              textDirection: TextDirection.ltr,
              onEditingComplete: () => myFocusNode.requestFocus(),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please type your Email *';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email address *';
                }
                return null;
              },
              onSaved: (value) {
                _authData['Email'] = value!;
              },
              keyboardType: TextInputType.text,
              onChanged: (value) {},
              decoration: InputDecoration(
                focusedErrorBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                errorStyle: const TextStyle(
                  textBaseline: TextBaseline.ideographic,
                  decoration: TextDecoration.none,
                  fontSize: 12,
                ),
                hintText: "Email",
                hintStyle: TextStyle(
                    color: kTextColor2.withOpacity(1),
                    fontSize: 15,
                    fontFamily: 'GE-light'),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                // suffixIcon: SvgPicture.asset("assets/icons/search.svg"),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
            height: 55,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextFormField(
              textAlign: TextAlign.left,
              textDirection: TextDirection.ltr,
              focusNode: myFocusNode,
              onSaved: (value) {
                _authData['password'] = value!;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please type your password *';
                }

                return null;
              },
              obscureText: true,
              keyboardType: TextInputType.text,
              scrollPadding: const EdgeInsets.only(bottom: 32.0),
              onChanged: (value) {
                _authData['Password'] = value;
              },
              decoration: InputDecoration(
                focusedErrorBorder: InputBorder.none,

                errorStyle: const TextStyle(
                  textBaseline: TextBaseline.ideographic,
                  decoration: TextDecoration.none,
                  fontSize: 12,
                ),
                errorBorder: InputBorder.none,
                hintText: "Password",
                hintStyle: TextStyle(
                    color: kTextColor2.withOpacity(1),
                    fontSize: 15,
                    fontFamily: 'GE-light'),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                // suffixIcon: SvgPicture.asset("assets/icons/search.svg"),
              ),
            ),
          ),
          if (!_isLoading)
            SizedBox(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * .1),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: CheckboxListTile(
                    title: const Text(' Remember Me',
                        style: TextStyle(fontSize: 15, fontFamily: 'GE-light')),
                    value: _rememberme,
                    onChanged: (newval) {
                      setState(() {
                        _rememberme = newval!;
                      });
                    },
                    // selected: _rememberme,
                  ),
                ),
              ),
            ),
          if (_isLoading)
            const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: CircularProgressIndicator())
          else
            TextButton(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Text(
                    'Log In',
                    style: TextStyle(fontSize: 17, fontFamily: 'GE-medium'),
                  ),
                ),
                style: TextButton.styleFrom(
                  primary: kTextColor1,
                  backgroundColor: senergyColorb,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                ),
                onPressed: () => _submit())
        ],
      ),
    );
  }
}
