import 'package:rxdart_bloc_implement/domain/entities/gallery.dart';
import 'package:rxdart_ext/single.dart';

abstract class GalleryRepository {
  Single<List<Gallery>> getTopListGalleries({
    required int catIndex,
    int? pageNum,
  });
}
