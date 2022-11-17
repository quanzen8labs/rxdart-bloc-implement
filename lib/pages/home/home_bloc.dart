import 'dart:math';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart_bloc_implement/domain/entities/gallery.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_bloc_implement/domain/entities/top_list_category.dart';
import 'package:rxdart_bloc_implement/domain/usecases/get_front_page_galleries_usecase.dart';
import 'package:rxdart_bloc_implement/domain/usecases/get_popular_galleries_usecase.dart';
import 'package:rxdart_bloc_implement/domain/usecases/get_top_list_galleries_use_case.dart';

class HomeBloc extends BlocBase {
  final Function loadData;
  final Function reloadFrontPage;

  Stream<List<Gallery>> popularGalleries$;
  Stream<List<Gallery>> frontPageGalleries$;
  Stream<List<List<Gallery>>> topListGalleriesList$;
  Stream<int> galleriesCount$;

  HomeBloc._({
    required this.loadData,
    required this.reloadFrontPage,
    required this.popularGalleries$,
    required this.frontPageGalleries$,
    required this.topListGalleriesList$,
    required this.galleriesCount$,
  });

  factory HomeBloc(
    GetPopularGalleriesUseCase getPopularGalleries,
    GetFrontPageGalleriesUseCase getFrontPageGalleries,
    GetTopListGalleriesUseCase getTopListGalleries,
  ) {
    BehaviorSubject<void> load$ = BehaviorSubject<void>();
    BehaviorSubject<void> reloadFrontPage$ = BehaviorSubject<void>();
    final popularGalleries$ =
        load$.switchMap((_) => getPopularGalleries()).share();
    final frontPageGalleries$ = Rx.merge([load$, reloadFrontPage$])
        .switchMap((_) => getFrontPageGalleries())
        .share();
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
    }).share();

    final galleriesCount$ = Rx.combineLatestList(
            [popularGalleries$, frontPageGalleries$, topListGalleriesList$])
        .map<int>((galleriesList) {
      var amount = 0;
      for (var galleries in galleriesList) {
        amount += galleries.length;
      }
      return amount * 100 + Random().nextInt(10);
    });

    return HomeBloc._(
      loadData: () => load$.add(null),
      reloadFrontPage: () => reloadFrontPage$.add(null),
      popularGalleries$: popularGalleries$,
      frontPageGalleries$: frontPageGalleries$,
      topListGalleriesList$: topListGalleriesList$,
      galleriesCount$: galleriesCount$,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
