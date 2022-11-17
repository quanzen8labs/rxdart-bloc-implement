import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:rxdart_bloc_implement/domain/entities/gallery_tag.dart';
import 'category.dart' as domain;

class Gallery {
  String id;
  String gid;
  String token;
  String title;
  double ratting;
  List<GalleryTag> tags;
  domain.Category category;
  String? uploader;
  int pageCount;
  DateTime postedDate;
  Uri? coverURL;
  Uri? galleryURL;
  DateTime? lastOpenDate;

  Gallery({
    required this.id,
    required this.gid,
    required this.token,
    required this.title,
    required this.ratting,
    required this.tags,
    required this.category,
    this.uploader,
    required this.pageCount,
    required this.postedDate,
    this.coverURL,
    this.galleryURL,
    this.lastOpenDate,
  });
}
