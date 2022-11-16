import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'app.dart';

void main() {
  testParser();
  runApp(const RBIApp());
}

void testParser() async {
  String htmlString = await rootBundle.loadString('assets/htmls/ehentai.html');
  print(htmlString);
}
