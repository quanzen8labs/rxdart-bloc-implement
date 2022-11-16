import 'package:rxdart_bloc_implement/utils/app_utils.dart';

class URLUtils {
  static Uri toplistList({required int catIndex, int? pageNum}) {
    var path = 'toplist.php?tl=$catIndex&';
    if (pageNum != null) {
      path += '&$pageNum';
    }
    return Uri.https(AppUtil.ehentai, path);
  }
}
