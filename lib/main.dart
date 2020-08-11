import 'package:flutter/material.dart';
import 'package:flutter_test_work/List.dart';

void main() => runApp(Loader());

class Loader extends StatelessWidget{
@override
  Widget build(BuildContext context) {
      return MaterialApp(
      title: 'Test work',
        theme: ThemeData(
          primarySwatch: Colors.blue
        ),
        home: CList(),
      );
  }
}