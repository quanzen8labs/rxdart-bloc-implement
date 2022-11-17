import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:rxdart_bloc_implement/domain/entities/gallery.dart';
import 'package:html/parser.dart';
import 'package:rxdart_bloc_implement/domain/entities/gallery_tag.dart';
import 'package:rxdart_bloc_implement/utils/url_utils.dart';
import 'package:rxdart_bloc_implement/domain/entities/category.dart' as domain;

class Parser {
  List<Gallery> parseGalleries(String doc) {
    dom.Document document = parse(doc);
    final displayMode = parseDisplayMode(document) ?? "";
    List<Gallery> galleries = [];
    switch (displayMode) {
      case 'Minimal':
        galleries = parseMinimalModeGalleries(document, false);
        break;
      case 'Minimal+':
        galleries = parseMinimalModeGalleries(document, true);
        break;
      case 'Compact':
        galleries = parseCompactModeGalleries(document);
        break;
      case 'Extended':
        galleries = parseExtendedModeGalleries(document);
        break;
      case 'Thumbnail':
        galleries = parseThumbnailModeGalleries(document);
        break;
      default:
        galleries = parseCompactModeGalleries(document);
        break;
    }

    return galleries;
  }

  String? parseDisplayMode(dom.Document doc) {
    var containerNode = doc.getElementById("dms");
    if (containerNode == null) {
      try {
        containerNode = doc.getElementsByClassName("searchnav").first;
      } catch (e) {}
    }
    if (containerNode == null) return null;
    dom.Element? dmsNode;
    for (var select in containerNode.getElementsByTagName("select")) {
      final onchange = select.attributes["onchange"];
      if (onchange != null && onchange.contains("inline_set=dm_")) {
        dmsNode = select;
        break;
      }
    }
    if (dmsNode == null) return null;

    for (var option in dmsNode.getElementsByTagName("option")) {
      final selected = option.attributes["selected"];
      if (selected != null && selected == "selected") {
        if (option.text.isNotEmpty) {
          return option.text;
        }
      }
    }
  }

  List<Gallery> parseMinimalModeGalleries(dom.Document doc, bool parseTags) {
    List<Gallery> galleries = [];
    for (var link in doc.getElementsByTagName("tr")) {
      try {
        final gltNode = link.getElementsByClassName("gltm").first;
        final tags = parseGalleryTags(gltNode);
        final gl2mNodes = link.getElementsByClassName("gl2m");
        final gl3mNodes = link.getElementsByClassName("gl3m");
        if (gl2mNodes.length > 0 && gl3mNodes.length > 0) {
          final gl2mNode = gl2mNodes.first;
          final gl3mNode = gl3mNodes.first;
          final thumbnailData = parseThumbnail(gl2mNode);
          final titleData = parseTitle(gl3mNode);
          if (thumbnailData != null && titleData != null) {
            final galleryUri = titleData.url;
            final gallery = Gallery(
              id: "",
              gid: galleryUri.pathSegments[2],
              token: galleryUri.pathSegments[3],
              title: titleData.title,
              ratting: thumbnailData.rating,
              tags: tags,
              category: thumbnailData.category,
              pageCount: thumbnailData.pageCount,
              postedDate: thumbnailData.publishedDate,
              coverURL: thumbnailData.url,
              galleryURL: galleryUri,
            );
            galleries.add(gallery);
          }
        }
      } catch (e) {}
    }
    return galleries;
  }

  List<Gallery> parseExtendedModeGalleries(dom.Document doc) {
    List<Gallery> galleries = [];
    for (var link in doc.getElementsByTagName("tr")) {
      try {
        final divs = doc.getElementsByTagName("div");
        final gl3eSiblingNode = divs
            .firstWhere((element) => element.className == "gl3e")
            .nextElementSibling;
        if (gl3eSiblingNode == null) {
          continue;
        }

        final thumbnailData = parseThumbnail(link);
        final titleData = parseTitle(gl3eSiblingNode);
        if (thumbnailData != null && titleData != null) {
          final galleryUri = titleData.url;
          final gallery = Gallery(
            id: "",
            gid: galleryUri.pathSegments[2],
            token: galleryUri.pathSegments[3],
            title: titleData.title,
            ratting: thumbnailData.rating,
            tags: parseGalleryTags(gl3eSiblingNode),
            category: thumbnailData.category,
            pageCount: thumbnailData.pageCount,
            postedDate: thumbnailData.publishedDate,
            coverURL: thumbnailData.url,
            galleryURL: galleryUri,
          );
          galleries.add(gallery);
        }
      } catch (e) {}
    }
    return galleries;
  }

  List<Gallery> parseCompactModeGalleries(dom.Document doc) {
    List<Gallery> galleries = [];
    for (var tr in doc.getElementsByTagName("tr")) {
      final gl2cNodes = tr.getElementsByClassName("gl2c");
      final gl3cNodes = tr.getElementsByClassName("gl3c glname");
      List<GalleryTag> tags = [];
      ParseThumbnailData? thumbnailData;
      ParseGalleryTitleData? titleData;
      if (gl2cNodes.length > 0 && gl3cNodes.length > 0) {
        tags = parseGalleryTags(gl3cNodes.first);
        thumbnailData = parseThumbnail(gl2cNodes.first);
        titleData = parseTitle(gl3cNodes.first);
      }

      if (thumbnailData != null && titleData != null) {
        Uri galleryUri = titleData.url;
        final pathSegments = galleryUri.pathSegments;
        galleries.add(
          Gallery(
            id: "",
            gid: pathSegments[2],
            token: pathSegments[3],
            title: titleData.title,
            ratting: thumbnailData.rating,
            tags: tags,
            category: thumbnailData.category,
            pageCount: thumbnailData.pageCount,
            postedDate: thumbnailData.publishedDate,
            coverURL: thumbnailData.url,
            galleryURL: galleryUri,
          ),
        );
      }
    }

    return galleries;
  }

  List<Gallery> parseThumbnailModeGalleries(dom.Document doc) {
    List<Gallery> galleries = [];

    for (var link in doc.getElementsByClassName("gl1t")) {
      try {
        final gl6tNode = link.getElementsByClassName("gl6t").first;
        final thumbnailData = parseThumbnail(gl6tNode);
        final titleData = parseTitle(link);
        if (thumbnailData != null && titleData != null) {
          Uri galleryUri = titleData.url;
          final pathSegments = galleryUri.pathSegments;
          galleries.add(
            Gallery(
              id: "",
              gid: pathSegments[2],
              token: pathSegments[3],
              title: titleData.title,
              ratting: thumbnailData.rating,
              tags: parseGalleryTags(gl6tNode),
              category: thumbnailData.category,
              pageCount: thumbnailData.pageCount,
              postedDate: thumbnailData.publishedDate,
              coverURL: thumbnailData.url,
              galleryURL: galleryUri,
            ),
          );
        }
      } catch (e) {}
    }

    return galleries;
  }

  List<GalleryTag> parseGalleryTags(dom.Element gltm) {
    List<GalleryTag> tags = [];
    for (var tagLink in gltm.getElementsByTagName("div")) {
      final className = tagLink.className;
      final title = tagLink.attributes["title"];
      if (["gt", "gtl"].contains(className) &&
          title != null &&
          title.isNotEmpty) {
        final titleComponents = title.split(":");
        if (titleComponents.length == 2) {
          Color? contentTextColor;
          Color? contentBackgroundColor;
          final nameSpace = titleComponents[0].toString();
          final contentText = titleComponents[1].toString();
          try {
            final existTagIndex =
                tags.indexWhere((element) => element.nameSpace == nameSpace);
            final existTag = tags[existTagIndex];
            final contents = existTag.contents;
            final galleryTagContent = GalleryTagContent(
                rawNamespace: nameSpace,
                text: contentText,
                isVotedUp: false,
                isVotedDown: false,
                textColor: contentTextColor,
                backgroundColor: contentBackgroundColor);
            final newContents = contents + [galleryTagContent];
            tags[existTagIndex] =
                GalleryTag(nameSpace: nameSpace, contents: newContents);
          } catch (e) {
            final galleryTagContent = GalleryTagContent(
                rawNamespace: nameSpace,
                text: contentText,
                isVotedUp: false,
                isVotedDown: false,
                textColor: contentTextColor,
                backgroundColor: contentBackgroundColor);
            tags.add(GalleryTag(
                nameSpace: nameSpace, contents: [galleryTagContent]));
          }
        }
      }
    }
    return tags;
  }

  ParseThumbnailData? parseThumbnail(dom.Element node) {
    Uri? tmpCoverURL;
    domain.Category? tmpCategory;
    DateTime? tmpPublishedDate;
    int? tmpPageCount;
    String? uploader;

    for (var div in node.getElementsByTagName("div")) {
      final imgs = div.getElementsByTagName("img");
      if (imgs.length > 0) {
        final img = imgs[0];
        final urlString = img.attributes["data-src"] ?? img.attributes["src"];
        if (urlString != null &&
            ![URLUtils.torrentDownload, URLUtils.torrentDownloadInvalid]
                .contains(urlString) &&
            img.attributes["alt"] != "T") {
          tmpCoverURL = Uri.tryParse(urlString);
        }
      }

      final category = domain.CategoryFactory.parse(div.text);
      if (category != null) {
        tmpCategory = category;
      }

      final onclick = div.attributes["onclick"];
      if (onclick != null && onclick.isNotEmpty) {
        final dateString = div.text;
        tmpPublishedDate = parseDate(dateString);
      }

      final components = div.text.split(" ");
      if (components.length == 2 && ["page", "pages"].contains(components[1])) {
        tmpPageCount = int.tryParse(components[0]);
      }
      final aLinks = div.getElementsByTagName("a");
      for (var aLink in aLinks) {
        final href = aLink.attributes["href"];
        if (href != null && href.contains("uploader")) {
          uploader = aLink.text;
        }
      }

      if ((uploader == null || uploader.isEmpty) && div.text == "(Disowned)") {
        uploader = div.text;
      }
    }

    final rating = parseRating(node);

    if (tmpCoverURL != null &&
        tmpCategory != null &&
        tmpPublishedDate != null &&
        rating != null &&
        tmpPageCount != null) {
      return ParseThumbnailData(
        url: tmpCoverURL,
        category: tmpCategory,
        rating: rating,
        publishedDate: tmpPublishedDate,
        pageCount: tmpPageCount,
        uploader: uploader,
      );
    }
  }

  double? parseRating(dom.Element node) {
    String? tmpRatingString;
    var containsUserRating = false;

    for (var link in node.getElementsByTagName("div")) {
      final style = link.attributes["style"];
      if (link.className.contains("ir") && style != null && style.isNotEmpty) {
        if (tmpRatingString != null) break;
        tmpRatingString = style;
        containsUserRating = link.className != "ir";
      }
    }
    if (tmpRatingString == null) return null;
    double? tmpRating;
    if (tmpRatingString.contains("0px")) {
      tmpRating = 5.0;
    } else if (tmpRatingString.contains("-16px")) {
      tmpRating = 4.0;
    } else if (tmpRatingString.contains("-32px")) {
      tmpRating = 3.0;
    } else if (tmpRatingString.contains("-48px")) {
      tmpRating = 2.0;
    } else if (tmpRatingString.contains("-64px")) {
      tmpRating = 1.0;
    } else if (tmpRatingString.contains("-64px")) {
      tmpRating = 0.0;
    }

    if (tmpRatingString.contains("-21px")) {
      if (tmpRating != null) {
        tmpRating -= 0.5;
      }
    }

    return tmpRating;
  }

  DateTime? parseDate(String dateString) {
    try {
      return DateTime.tryParse(dateString);
    } catch (e) {
      return null;
    }
  }

  ParseGalleryTitleData? parseTitle(dom.Element node) {
    ParseGalleryTitleData? findTitle(dom.Element gLink) {
      dom.Element? glinkParentNode = gLink.parent;
      dom.Element? glinkGrandParentNode = glinkParentNode?.parent;
      String title = gLink.text;
      final urlString = glinkParentNode?.attributes["href"] ??
          glinkGrandParentNode?.attributes["href"];

      if (title != null && urlString != null) {
        final uri = Uri.tryParse(urlString);
        if (uri != null && uri.pathSegments.length >= 4) {
          return ParseGalleryTitleData(title: title, url: uri);
        }
      }
    }

    for (var glink in node.getElementsByTagName("div")) {
      if (glink.className.contains("glink")) {
        final data = findTitle(glink);
        if (data != null) return data;
      }
    }

    for (var glink in node.getElementsByTagName("span")) {
      if (glink.className.contains("glink")) {
        final data = findTitle(glink);
        if (data != null) return data;
      }
    }

    return null;
  }
}

class ParseThumbnailData {
  Uri url;
  domain.Category category;
  double rating;
  DateTime publishedDate;
  int pageCount;
  String? uploader;

  ParseThumbnailData(
      {required this.url,
      required this.category,
      required this.rating,
      required this.publishedDate,
      required this.pageCount,
      this.uploader});
}

class ParseGalleryTitleData {
  String title;
  Uri url;

  ParseGalleryTitleData({required this.title, required this.url});
}
