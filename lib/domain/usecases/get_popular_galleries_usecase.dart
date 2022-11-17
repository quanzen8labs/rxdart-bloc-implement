import 'package:rxdart_bloc_implement/domain/entities/gallery.dart';
import 'package:rxdart_bloc_implement/domain/repositories/gallery_repository.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

class GetPopularGalleriesUseCase {
  final GalleryRepository _galleryRepository;
  GetPopularGalleriesUseCase(this._galleryRepository);

  Single<List<Gallery>> call() => _galleryRepository.getPopularListGalleries();
}
