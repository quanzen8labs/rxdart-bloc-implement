import 'package:flutter/material.dart';
import 'package:rxdart_bloc_implement/domain/entities/gallery.dart';
import 'package:rxdart_bloc_implement/domain/entities/top_list_category.dart';
import 'package:transparent_image/transparent_image.dart';

class TopListGalleriesWidget extends StatelessWidget {
  final List<List<Gallery>> galleriesList;
  final EdgeInsets padding;
  const TopListGalleriesWidget(
      {Key? key, required this.galleriesList, required this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topListCategories = [
      TopListCategory.yesterday,
      TopListCategory.pastMonth,
      TopListCategory.pastYear,
      TopListCategory.allTime
    ];

    List<Widget> widgets = [];
    for (var i = 0; i < topListCategories.length; i++) {
      widgets.add(_buildList(topListCategories[i], galleriesList[i]));
    }
    return Container(
      height: 400,
      child: ListView(
        padding: padding,
        scrollDirection: Axis.horizontal,
        children: widgets
            .expand((element) => [
                  element,
                  SizedBox(
                    width: 20,
                  )
                ])
            .toList(),
      ),
    );
  }

  Widget _buildList(TopListCategory topListCategory, List<Gallery> galleries) {
    return Container(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            topListCategory.title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ...galleries
              .map((e) => Expanded(child: _buildGalleryWidget(e)))
              .expand((e) => [
                    e,
                    SizedBox(
                      height: 16,
                    )
                  ])
              .toList()
        ],
      ),
    );
  }

  Widget _buildGalleryWidget(Gallery gallery) {
    return Row(
      children: [
        AspectRatio(
          aspectRatio: 9.0 / 12,
          child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: gallery.coverURL.toString(),
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
            child: Column(
          children: [
            Expanded(child: Text(gallery.title)),
            SizedBox(height: 8),
            Text(gallery.category.name),
          ],
        )),
      ],
    );
  }
}
