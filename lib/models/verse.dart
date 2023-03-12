class Verse {
  int id;
  double verse;
  String book, unformatted;

  Verse({
    required this.id,
    required this.book,
    required this.verse,
    required this.unformatted,
  });

  static Verse fromMap(Map<String, dynamic> map) {
    return Verse(
      id: map['id'],
      book: map['book'],
      verse: map['verse'],
      unformatted: map['unformatted'],
    );
  }

  @override
  String toString() {
    return "$book $verse $unformatted";
  }
}
