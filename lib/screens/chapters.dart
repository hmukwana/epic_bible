import 'package:epic_bible/models/book.dart';
import 'package:epic_bible/screens/view_chapter.dart';
import 'package:flutter/material.dart';

class ChaptersScreen extends StatelessWidget {
  const ChaptersScreen({super.key, required this.book});
  final Book book;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.human!),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Wrap(
              spacing: 12.0,
              children: List.generate(
                  book.chapters!,
                  (index) => GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => ViewChapterScreen(
                                  book: book,
                                  chapter: index + 1,
                                )));
                      },
                      child: Chip(label: Text("${index + 1}")))),
            ),
          ),
        ),
      ),
    );
  }
}
