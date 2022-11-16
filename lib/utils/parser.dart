import 'package:rxdart_bloc_implement/domain/entities/gallery.dart';
import 'package:xml/xml.dart';

class Parser {
  List<Gallery> parseGalleries(String doc) {
    XmlDocument document = XmlDocument.parse(doc);

    return [];
  }

  List<Gallery> _parseCompactModeGalleries(XmlDocument doc) {
    List<Gallery> galleries = [];
    for (var link in doc.findAllElements('tr')) {
      try {
        final tds = link.findElements('td');
        final g12cNode = tds
            .firstWhere((element) => element.getAttribute('class') == 'g12c');
        final g13cNode = tds.firstWhere(
            (element) => element.getAttribute('class') == 'gl3c glname');
      } catch (e) {
        continue;
      }
    }

    return galleries;
  }
}
