import 'package:rxdart_bloc_implement/domain/entities/gallery.dart';
import 'package:rxdart_bloc_implement/domain/repositories/gallery_repository.dart';
import 'package:rxdart_ext/single.dart';

class GetTopListGalleriesUseCase {
  final GalleryRepository _galleryRepository;
  GetTopListGalleriesUseCase(this._galleryRepository);

  Single<List<Gallery>> call({
    required int catIndex,
    int? pageNum,
  }) =>
      _galleryRepository.getTopListGalleries(
          catIndex: catIndex, pageNum: pageNum);
}
