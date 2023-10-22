import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/providers.dart';
import 'package:todo_list_app/screens/login_page.dart';
import 'package:todo_list_app/screens/tasks.dart';

void main() async {
  runApp(ChangeNotifierProvider(
    create: (context) => UserProvider(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(elevation: 0),
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  }
}
