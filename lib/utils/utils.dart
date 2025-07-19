String capitalizeFirstLetter(String s) => s[0].toUpperCase() + s.substring(1);

String truncateText(String text, int maxLength) {
  if (text.length <= maxLength) {
    return text;
  }
  return '${text.substring(0, maxLength)}...';
}
