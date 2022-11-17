import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rxdart_bloc_implement/domain/entities/gallery.dart';
import 'package:transparent_image/transparent_image.dart';

class PopularGalleriesWidget extends StatelessWidget {
  final List<Gallery> galleries;
  const PopularGalleriesWidget({Key? key, required this.galleries})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
        itemCount: galleries.length,
        itemBuilder: (context, index, realIndex) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  AspectRatio(
                    aspectRatio: 9.0 / 12,
                    child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: galleries[index].coverURL.toString(),
                        fit: BoxFit.cover),
                  ),
                  SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                            child: Text(
                          galleries[index].title,
                          style: TextStyle(fontSize: 20),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                        )),
                        SizedBox(height: 12),
                        RatingBarIndicator(
                          itemSize: 24,
                          rating: galleries[index].ratting,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
        options: CarouselOptions(
          aspectRatio: 2.0,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
          autoPlay: true,
        ));
  }
}
