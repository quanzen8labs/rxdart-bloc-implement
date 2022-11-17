import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rxdart_bloc_implement/data/gallery_repository_impl.dart';
import 'package:rxdart_bloc_implement/domain/usecases/get_front_page_galleries_usecase.dart';
import 'package:rxdart_bloc_implement/domain/usecases/get_popular_galleries_usecase.dart';
import 'package:rxdart_bloc_implement/domain/usecases/get_top_list_galleries_use_case.dart';
import 'package:rxdart_bloc_implement/pages/home/home_bloc.dart';
import 'package:rxdart_bloc_implement/pages/home/home_page.dart';

class RootPage extends StatelessWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [
        Bloc(
          (inject) => HomeBloc(
            inject.get<GetPopularGalleriesUseCase>(),
            inject.get<GetFrontPageGalleriesUseCase>(),
            inject.get<GetTopListGalleriesUseCase>(),
          ),
        ),
      ],
      dependencies: [
        Dependency(
          (inject) => GetPopularGalleriesUseCase(GalleryRepositoryImpl()),
        ),
        Dependency(
          (inject) => GetFrontPageGalleriesUseCase(GalleryRepositoryImpl()),
        ),
        Dependency(
          (inject) => GetTopListGalleriesUseCase(GalleryRepositoryImpl()),
        ),
      ],
      child: Scaffold(
        body: Column(
          children: [
            Expanded(child: HomePage()),
            GNav(tabs: [
              GButton(
                icon: LineIcons.home,
                text: 'Home',
              ),
              GButton(
                icon: LineIcons.heart,
                text: 'Likes',
              ),
              GButton(
                icon: LineIcons.search,
                text: 'Search',
              ),
              GButton(
                icon: LineIcons.user,
                text: 'Profile',
              )
            ]),
          ],
        ),
      ),
    );
  }
}
