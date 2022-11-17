import 'dart:ffi';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rxdart_bloc_implement/domain/entities/gallery.dart';
import 'package:rxdart_bloc_implement/pages/home/home_bloc.dart';
import 'package:rxdart_bloc_implement/pages/home/widgets/front_page_galleries_widget.dart';
import 'package:rxdart_bloc_implement/pages/home/widgets/populart_galleries_widget.dart';
import 'package:rxdart_bloc_implement/pages/home/widgets/top_list_galleries_widget.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final homeBloc = BlocProvider.getBloc<HomeBloc>();
    homeBloc.loadData();
  }

  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.getBloc<HomeBloc>();
    const padding = EdgeInsets.symmetric(horizontal: 24, vertical: 0);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
              onPressed: () {
                final homeBloc = BlocProvider.getBloc<HomeBloc>();
                homeBloc.loadData();
              },
              icon: Icon(LineIcons.recycle))
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 32),
          StreamBuilder<List<Gallery>>(
            stream: homeBloc.popularGalleries$,
            builder: (context, snapshot) {
              final galleries = snapshot.data ?? [];
              if (galleries.isNotEmpty) {
                return PopularGalleriesWidget(galleries: galleries);
              }
              return Container();
            },
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: padding,
            child: Text(
              'Front Page',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          StreamBuilder<List<Gallery>>(
            stream: homeBloc.frontPageGalleries$,
            builder: (context, snapshot) {
              final galleries = snapshot.data ?? [];
              if (galleries.isEmpty) {
                return Container();
              }
              return FrontPageGalleriesWidget(
                galleries: galleries,
                padding: padding,
              );
            },
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: padding,
            child: Text(
              'Top List',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          StreamBuilder<List<List<Gallery>>>(
            stream: homeBloc.topListGalleriesList$,
            builder: (context, snapshot) {
              final galleries = snapshot.data ?? [];
              if (galleries.isEmpty) {
                return Container();
              }
              return TopListGalleriesWidget(
                galleriesList: galleries,
                padding: padding,
              );
            },
          )
        ],
      ),
    );
  }
}
