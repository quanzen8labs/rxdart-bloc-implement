import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart_bloc_implement/domain/entities/gallery.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_bloc_implement/domain/entities/top_list_category.dart';
import 'package:rxdart_bloc_implement/domain/usecases/get_front_page_galleries_usecase.dart';
import 'package:rxdart_bloc_implement/domain/usecases/get_popular_galleries_usecase.dart';
import 'package:rxdart_bloc_implement/domain/usecases/get_top_list_galleries_use_case.dart';

class HomeBloc extends BlocBase {
  final Function loadData;

  Stream<List<Gallery>> popularGalleries$;
  Stream<List<Gallery>> frontPageGalleries$;
  Stream<List<List<Gallery>>> topListGalleriesList$;

  HomeBloc._(
      {required this.loadData,
      required this.popularGalleries$,
      required this.frontPageGalleries$,
      required this.topListGalleriesList$});

  factory HomeBloc(
    GetPopularGalleriesUseCase getPopularGalleries,
    GetFrontPageGalleriesUseCase getFrontPageGalleries,
    GetTopListGalleriesUseCase getTopListGalleries,
  ) {
    BehaviorSubject<void> load$ = BehaviorSubject<void>();
    final popularGalleries$ = load$.switchMap((_) => getPopularGalleries());
    final frontPageGalleries$ = load$.switchMap((_) => getFrontPageGalleries());
    final topListGalleriesList$ = load$.switchMap((_) {
      return Rx.combineLatestList([
        TopListCategory.yesterday,
        TopListCategory.pastMonth,
        TopListCategory.pastYear,
        TopListCategory.allTime
      ].map((topListCategory) {
        return getTopListGalleries(catIndex: topListCategory.rawValue)
            .map((galleries) => galleries.take(3).toList());
      }));
    });

    return HomeBloc._(
      loadData: () => load$.add(null),
      popularGalleries$: popularGalleries$,
      frontPageGalleries$: frontPageGalleries$,
      topListGalleriesList$: topListGalleriesList$,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
