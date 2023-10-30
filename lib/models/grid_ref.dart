class GridRef {
  final int eastings;
  final int northings;

  GridRef(this.eastings, this.northings);

  String toSixFigure() {
    var e = eastings.toString().substring(2, 5);
    var n = northings.toString().substring(2, 5);

    return e + n;
  }
}
