import 'package:flutter/material.dart';
import 'package:rxdart_bloc_implement/domain/entities/gallery.dart';
import 'package:transparent_image/transparent_image.dart';

class FrontPageGalleriesWidget extends StatelessWidget {
  final List<Gallery> galleries;
  final EdgeInsets padding;
  const FrontPageGalleriesWidget(
      {Key? key, required this.galleries, required this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: GridView.count(
        padding: padding,
        scrollDirection: Axis.horizontal,
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 12.0 / 9,
        children: galleries.map((gallery) {
          return FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: gallery.coverURL.toString(),
              fit: BoxFit.cover);
        }).toList(),
      ),
    );
    ;
  }
}
