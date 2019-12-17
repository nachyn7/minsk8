import "package:flutter/material.dart";
import '../widgets/main_drawer.dart';

class UnderwayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Underway'),
      ),
      drawer: MainDrawer('/underway'),
      body: Center(
        child: Text('xxx'),
      ),
    );
  }
}
