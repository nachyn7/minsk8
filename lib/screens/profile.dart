import 'package:flutter/material.dart';
import 'package:minsk8/import.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      drawer: MainDrawer('/profile'),
      body: Center(
        child: Text('xxx'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: buildAddButton(context),
      bottomNavigationBar: NavigationBar(currentRouteName: '/profile'),
      extendBody: true,
    );
  }
}
