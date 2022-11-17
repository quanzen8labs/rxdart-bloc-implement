import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:rxdart_bloc_implement/data/gallery_repository_impl.dart';
import 'package:rxdart_bloc_implement/domain/entities/gallery.dart';
import 'package:rxdart_bloc_implement/utils/parser.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  testParser();
  runApp(const RBIApp());
}

void testParser() async {
  // String htmlString = await rootBundle.loadString('assets/htmls/ehentai.html');
  // Parser parser = Parser();
  // List<Gallery> galleries = parser.parseGalleries(htmlString);
  GalleryRepositoryImpl().getPopularListGalleries().stream.listen((event) {
    print(event);
  });
}
