class Book {
  int? number, chapters;
  String? osis, human;

  Book({
    this.number,
    this.chapters,
    this.osis,
    this.human,
  });

  static Book fromMap(Map<String, dynamic> map) {
    return Book(
      number: map['number'],
      chapters: map['chapters'],
      osis: map['osis'],
      human: map['human'],
    );
  }

  @override
  String toString() {
    return "$human";
  }
}
