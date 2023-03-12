class Chapter {
  int id;
  String referenceOsis,
      referenceHuman,
      content,
      previousReferenceOsis,
      previousReferenceHuman,
      nextReferenceOsis,
      nextReferenceHuman;

  Chapter({
    required this.id,
    required this.referenceOsis,
    required this.referenceHuman,
    required this.content,
    required this.previousReferenceOsis,
    required this.previousReferenceHuman,
    required this.nextReferenceOsis,
    required this.nextReferenceHuman,
  });

  static Chapter fromMap(Map<String, dynamic> map) {
    return Chapter(
      id: map['id'],
      referenceOsis: map['reference_osis'],
      referenceHuman: map['reference_human'],
      content: map['content'],
      previousReferenceOsis: map['previous_reference_osis'],
      previousReferenceHuman: map['previous_reference_human'],
      nextReferenceOsis: map['next_reference_osis'],
      nextReferenceHuman: map['next_reference_human'],
    );
  }

  @override
  String toString() {
    return "$referenceOsis Next: $nextReferenceOsis Prev: $previousReferenceOsis";
  }
}
