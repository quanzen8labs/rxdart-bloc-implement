import 'dart:ui';

import 'package:rxdart_bloc_implement/utils/app_utils.dart';

enum Category {
  doujinshi,
  manga,
  artistCG,
  gameCG,
  western,
  nonH,
  imageSet,
  cosplay,
  asianPorn,
  misc,
  private
}

extension CategoryHelper on Category {
  String get rawValue {
    switch (this) {
      case Category.doujinshi:
        return 'Doujinshi';
      case Category.manga:
        return 'Manga';
      case Category.artistCG:
        return 'Artist CG';
      case Category.gameCG:
        return 'Game CG';
      case Category.western:
        return 'Western';
      case Category.nonH:
        return 'Non-H';
      case Category.imageSet:
        return 'Image Set';
      case Category.cosplay:
        return 'Cosplay';
      case Category.asianPorn:
        return 'Asian Porn';
      case Category.misc:
        return 'Misc';
      case Category.private:
        return 'Private';
    }
  }
}
