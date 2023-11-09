import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart'; // new

import 'package:todo_list_app/screens/tasks.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providers: [
              EmailAuthProvider(),
              GoogleProvider(
                  clientId:
                      "31469000998-8ag6ubt8a4g7kqt7kaiq8oo7329tjiar.apps.googleusercontent.com"),
            ],
            // headerBuilder: (context, constraints, shrinkOffset) {
            //   return Padding(
            //     padding: const EdgeInsets.all(20),
            //      child: AspectRatio(
            //        aspectRatio: 1,
            //        child: Image.asset('flutterfire_300x.png'),
            //      ),
            //   );
            // },
            subtitleBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: action == AuthAction.signIn
                    ? const Text('Welcome to ToDo App, please sign in!')
                    : const Text('Welcome to ToDo App, please sign up!'),
              );
            },
            footerBuilder: (context, action) {
              return const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'By signing in, you agree to our terms and conditions.',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            },
            // sideBuilder: (context, shrinkOffset) {
            //   return Padding(
            //     padding: const EdgeInsets.all(20),
            //     child: AspectRatio(
            //       aspectRatio: 1,
            //       child: Image.asset('flutterfire_300x.png'),
            //     ),
            //   );
            // },
          );
        }

        return const Tasks();
      },
    );
  }
}
// import 'dart:convert';
// import 'dart:ui';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:todo_list_app/models/user.dart' as userModel;
// import 'package:todo_list_app/providers.dart';
// import 'package:todo_list_app/screens/tasks.dart';

// class LoginPage extends StatefulWidget {
//   LoginPage({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   bool _obscureText = true;

//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final FirebaseAuth _auth =
//       FirebaseAuth.instance; // Initialize Firebase Authentication

//   _handleOnPressedLogin() async {
//     try {
//       final UserCredential userCredential = await _auth.signInAnonymously();
//       final User? user = userCredential.user;

//       if (user != null) {
//         // User successfully signed in
//         print('User ID: ${user.uid}');

//         // Successful login
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const Tasks(),
//           ),
//         );
//       } else {
//         // ignore: use_build_context_synchronously
//         showErrorDialog(context, 'Invalid username or password.');
//       }
//     } catch (e) {
//       // Handle authentication errors
//       print('Error: $e');
//     }

//     // final userDataJson = await rootBundle.loadString('assets/user_data.json');
//     // final userJsonList = json.decode(userDataJson) as List<dynamic>;
//     // final userProvider = Provider.of<UserProvider>(context, listen: false);

//     // final enteredEmail = emailController.text;
//     // final enteredPassword = passwordController.text;
//     // for (var userData in userJsonList) {
//     //   final user = userModel.User.fromJson(userData);
//     //   print('Username: ${user.username}, Password: ${user.password}');
//     //   if (user.username == enteredEmail && user.password == enteredPassword) {
//     //     // Set the user in the provider
//     //     userProvider.setUser(user);
//     //     // Successful login
//     //     Navigator.pushReplacement(
//     //       context,
//     //       MaterialPageRoute(
//     //         builder: (context) => Tasks(),
//     //       ),
//     //     );
//     //     return; // Exit the loop since we found a matching user
//     //   }
//     // }
//     // // ignore: use_build_context_synchronously
//     // showErrorDialog(context, 'Invalid username or password.');
//   }

// //WIDGETS
//   Widget buildEmail() {
//     return Container(
//         alignment: Alignment.centerLeft,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(99),
//           border: Border.all(
//             color: Colors.deepPurpleAccent,
//             width: 0.5,
//           ),
//         ),
//         height: 50,
//         child: TextField(
//           controller: emailController,
//           keyboardType: TextInputType.emailAddress,
//           style: const TextStyle(
//             fontWeight: FontWeight.w400,
//           ),
//           decoration: const InputDecoration(
//               border: InputBorder.none,
//               contentPadding: EdgeInsets.symmetric(vertical: 10),
//               prefixIcon: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20),
//                 child: Icon(
//                   Icons.person_outline_outlined,
//                   color: Color(0xFFADA4A5),
//                 ),
//               ),
//               hintText: 'Username',
//               hintStyle: TextStyle(
//                   color: Color(0xFFADA4A5),
//                   fontSize: 13,
//                   fontWeight: FontWeight.w500)),
//         ));
//   }

//   Widget buildPassword() {
//     return Container(
//       alignment: Alignment.centerLeft,
//       decoration: BoxDecoration(
//         color: Colors.white, // Color(0xFFF7F8F8),
//         borderRadius: BorderRadius.circular(99),
//         border: Border.all(
//           color: Colors.deepPurpleAccent,
//           width: 0.5,
//         ),
//       ),
//       height: 50,
//       child: TextField(
//         controller: passwordController,
//         obscureText: _obscureText,
//         style: const TextStyle(
//           fontWeight: FontWeight.w400,
//         ),
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.symmetric(vertical: 10),
//           prefixIcon: const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20),
//             child: Icon(
//               Icons.lock_open_rounded,
//               color: Color(0xFFADA4A5),
//             ),
//           ),
//           suffixIcon: IconButton(
//             icon: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: Icon(
//                 _obscureText ? Icons.visibility : Icons.visibility_off,
//                 color: const Color(0xFFADA4A5),
//               ),
//             ),
//             onPressed: () {
//               setState(() {
//                 _obscureText = !_obscureText;
//               });
//             },
//           ),
//           hintText: 'Password',
//           hintStyle: const TextStyle(
//             color: Color(0xFFADA4A5),
//             fontSize: 13,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//     );
//   }

//   void showErrorDialog(BuildContext context, String text) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Attention!'),
//           content: Text(text),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget buildLoginButton(BuildContext context) {
//     return Material(
//       elevation: 5,
//       shadowColor: Colors.blue.withOpacity(0.45),
//       borderRadius: BorderRadius.circular(99),
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.60,
//         height: MediaQuery.of(context).size.height * 0.06,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(99),
//             gradient: const LinearGradient(
//                 begin: Alignment.centerLeft,
//                 end: Alignment.centerRight,
//                 colors: [Colors.deepPurpleAccent, Colors.deepPurple])),
//         child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               elevation: 5,
//               backgroundColor: Colors.transparent,
//               shadowColor: Colors.transparent,
//             ),
//             child: const Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'Connexion',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 Icon(
//                   Icons.login,
//                   color: Colors.white,
//                 ),
//               ],
//             ),
//             onPressed: _handleOnPressedLogin),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.03,
//             ),
//             const Text(
//               "Connectez-vous",
//               style: TextStyle(
//                 fontSize: 25,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.05,
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: buildEmail(),
//             ),
//             const SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: buildPassword(),
//             ),
//             const SizedBox(height: 60),
//             buildLoginButton(context),
//           ]),
//     );
//   }
// }
