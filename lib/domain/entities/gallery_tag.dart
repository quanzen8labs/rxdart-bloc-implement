import 'package:flutter/material.dart';

class GalleryTag {
  String nameSpace;
  List<GalleryTagContent> contents;

  GalleryTag({required this.nameSpace, required this.contents});
}

class GalleryTagContent {
  String rawNamespace;
  String text;
  bool isVotedUp;
  bool isVotedDown;
  Color? textColor;
  Color? backgroundColor;

  GalleryTagContent({
    required this.rawNamespace,
    required this.text,
    required this.isVotedUp,
    required this.isVotedDown,
    required this.textColor,
    required this.backgroundColor,
  });
}
