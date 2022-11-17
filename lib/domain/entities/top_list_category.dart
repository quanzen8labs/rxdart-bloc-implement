enum TopListCategory {
  yesterday,
  pastMonth,
  pastYear,
  allTime,
}

extension RawValue on TopListCategory {
  int get rawValue {
    switch (this) {
      case TopListCategory.yesterday:
        return 15;
      case TopListCategory.pastMonth:
        return 13;
      case TopListCategory.pastYear:
        return 12;
      case TopListCategory.allTime:
        return 11;
    }
  }

  String get title {
    switch (this) {
      case TopListCategory.yesterday:
        return 'Yesterday';
      case TopListCategory.pastMonth:
        return 'Past Month';
      case TopListCategory.pastYear:
        return 'Past Year';
      case TopListCategory.allTime:
        return 'All Time';
    }
  }
}
