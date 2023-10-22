import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/providers.dart';
import 'package:todo_list_app/screens/login_page.dart';
import 'package:todo_list_app/screens/tasks.dart';

class CustomSideBar extends StatelessWidget {
  const CustomSideBar({super.key});

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    final loggedInUser = userProvider.loggedInUser;
    return Padding(
      padding: const EdgeInsets.only(right: 60),
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: const EdgeInsets.only(right: 20, top: 60),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30.0, bottom: 20),
              child: Text(
                loggedInUser != null
                    ? 'Hello, ${loggedInUser.fullName}' // Replace 'name' with the actual field in your user model
                    : 'Hello, Guest',
                style: TextStyle(fontSize: 24),
              ),
            ),
            ListTile(
              leading: SizedBox(
                  height: 31, width: 31, child: Icon(Icons.menu_open_rounded)),
              title: const Text(
                'My to-do list',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context); // Close the sidebar menu
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Tasks()),
                );
              },
            ),
            ListTile(
              leading: SizedBox(
                  height: 30, width: 30, child: Icon(Icons.logout_rounded)),
              title: const Text(
                'Logout',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              onTap: () async {
                Navigator.pop(context); // Close the sidebar menu

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => LoginPage(),
                  ),
                ); // Navigate to the profile page

                _showMessage(context, 'You just logged out');
              },
            ),
          ],
        ),
      ),
    );
  }
}
