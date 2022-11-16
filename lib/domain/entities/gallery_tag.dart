import 'package:flutter/material.dart';

class GalleryTag {
  String nameSpace;
  List<GalleryTagContent> content;

  GalleryTag({required this.nameSpace, required this.content});
}

class GalleryTagContent {
  String rawNamespace;
  String text;
  bool isVotedUp;
  bool isVotedDown;
  Color textColor;
  Color backgroundColor;

  GalleryTagContent({
    required this.rawNamespace,
    required this.text,
    required this.isVotedUp,
    required this.isVotedDown,
    required this.textColor,
    required this.backgroundColor,
  });
}
