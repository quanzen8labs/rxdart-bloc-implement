import 'package:rxdart/rxdart.dart';
import 'package:rxdart_bloc_implement/domain/entities/gallery.dart';
import 'package:rxdart_bloc_implement/domain/repositories/gallery_repository.dart';
import 'package:rxdart_bloc_implement/utils/url_utils.dart';
// ignore: implementation_imports
import 'package:rxdart_ext/src/single/single.dart';
import 'package:http/http.dart' as http;

class GalleryRepositoryImpl extends GalleryRepository {
  @override
  Single<List<Gallery>> getTopListGalleries(
      {required int catIndex, int? pageNum}) {
    return Single.fromCallable(() async {
      http.Response response =
          await http.get(URLUtils.toplistList(catIndex: catIndex));

      return [];
    });
  }
}
