import 'package:rxdart_bloc_implement/utils/app_utils.dart';

class URLUtils {
  static Uri toplistList({required int catIndex, int? pageNum}) {
    var path = 'toplist.php?tl=$catIndex';
    if (pageNum != null) {
      path += '&$pageNum';
    }
    String fullUri = AppUtil.ehentai + path;
    return Uri.parse(fullUri);
  }

  static Uri popularList() {
    var path = 'popular';
    String fullUri = AppUtil.ehentai + path;
    return Uri.parse(fullUri);
  }

  static const String torrentDownload = "https://ehgt.org/g/t.png";
  static const String torrentDownloadInvalid = "https://ehgt.org/g/td.png";
}
