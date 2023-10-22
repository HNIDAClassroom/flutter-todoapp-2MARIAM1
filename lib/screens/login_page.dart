import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/models/user.dart';
import 'package:todo_list_app/providers.dart';
import 'package:todo_list_app/screens/tasks.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  _handleOnPressedLogin() async {
    final userDataJson = await rootBundle.loadString('assets/user_data.json');
    final userJsonList = json.decode(userDataJson) as List<dynamic>;
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final enteredEmail = emailController.text;
    final enteredPassword = passwordController.text;
    for (var userData in userJsonList) {
      final user = User.fromJson(userData);
      print('Username: ${user.username}, Password: ${user.password}');
      if (user.username == enteredEmail && user.password == enteredPassword) {
        // Set the user in the provider
        userProvider.setUser(user);
        // Successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Tasks(),
          ),
        );
        return; // Exit the loop since we found a matching user
      }
    }
    // ignore: use_build_context_synchronously
    showErrorDialog(context, 'Invalid username or password.');
  }

//WIDGETS
  Widget buildEmail() {
    return Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: Colors.deepPurpleAccent,
            width: 0.5,
          ),
        ),
        height: 50,
        child: TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(
                  Icons.person_outline_outlined,
                  color: Color(0xFFADA4A5),
                ),
              ),
              hintText: 'Username',
              hintStyle: TextStyle(
                  color: Color(0xFFADA4A5),
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
        ));
  }

  Widget buildPassword() {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.white, // Color(0xFFF7F8F8),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(
          color: Colors.deepPurpleAccent,
          width: 0.5,
        ),
      ),
      height: 50,
      child: TextField(
        controller: passwordController,
        obscureText: _obscureText,
        style: TextStyle(
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(
              Icons.lock_open_rounded,
              color: Color(0xFFADA4A5),
            ),
          ),
          suffixIcon: IconButton(
            icon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                color: Color(0xFFADA4A5),
              ),
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
          hintText: 'Password',
          hintStyle: TextStyle(
            color: Color(0xFFADA4A5),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void showErrorDialog(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Attention!'),
          content: Text(text),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildLoginButton(BuildContext context) {
    return Material(
      elevation: 5,
      shadowColor: Colors.blue.withOpacity(0.45),
      borderRadius: BorderRadius.circular(99),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.60,
        height: MediaQuery.of(context).size.height * 0.06,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(99),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.deepPurpleAccent, Colors.deepPurple])),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5,
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Connexion',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.login,
                  color: Colors.white,
                ),
              ],
            ),
            onPressed: _handleOnPressedLogin),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Text(
              "Connectez-vous",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: buildEmail(),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: buildPassword(),
            ),
            SizedBox(height: 60),
            buildLoginButton(context),
          ]),
    );
  }
}
