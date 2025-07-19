/// to be utilized later
class Poem {
  final String title;
  final String content;

  Poem({required this.title, required this.content});

  @override
  String toString() => '$title\n$content';
}
