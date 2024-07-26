class Utils {
  static bool isProductName(String text) {
    final words = text.split(' ');
    return words.isNotEmpty && !text.contains('Price') && text.length > 5;
  }
}
