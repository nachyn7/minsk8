import 'package:flutter/material.dart';
import 'package:minsk8/import.dart';

class ItemMapScreen extends StatefulWidget {
  ItemMapScreen(this.arguments);

  final ItemMapRouteArguments arguments;

  @override
  _ItemMapScreenState createState() {
    return _ItemMapScreenState();
  }
}

class _ItemMapScreenState extends State<ItemMapScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}

class ItemMapRouteArguments {
  ItemMapRouteArguments(this.item);

  final ItemModel item;
}
