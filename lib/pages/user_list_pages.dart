import 'package:flutter/material.dart';

class UserListPage extends StatelessWidget {
  static const String routeName = '/users';
  const UserListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
    );
  }
}
