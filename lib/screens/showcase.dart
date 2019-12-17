import 'package:flutter/material.dart';
import '../widgets/main_drawer.dart';
import '../const/fake_data.dart' show items, kinds;
import '../widgets/showcase_card.dart';

class ShowcaseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: kinds.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Showcase'),
          bottom: TabBar(
            tabs: kinds
                .map((kind) => Tab(
                      text: kind.name,
                      icon: Icon(kind.icon),
                    ))
                .toList(),
          ),
        ),
        drawer: MainDrawer('/showcase'),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return ShowcaseCard(index);
          },
        ),
      ),
    );
  }
}
