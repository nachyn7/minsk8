import 'package:flutter/material.dart';
import 'package:minsk8/import.dart';

class PayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pay'),
      ),
      drawer: MainDrawer('/pay'),
      body: Center(
        child: Text('xxx'),
      ),
    );
  }
}
