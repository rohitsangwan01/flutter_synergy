class RectObj {
  double left, top, right, bottom;
  final double width;
  final double height;

  RectObj({
    this.left = 0,
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
    required this.width,
    required this.height,
  });

  @override
  String toString() {
    return 'RectObj{left: $left, top: $top, right: $right, bottom: $bottom, width: $width, height: $height}';
  }
}
