import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:rxdart_bloc_implement/domain/usecases/login_use_case.dart';

class RBIApp extends StatelessWidget {
  const RBIApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routes = <String, WidgetBuilder>{};

    return MaterialApp(
      title: 'Flutter Demo',
      routes: routes,
    );
  }
}
