import 'package:epic_bible/models/book.dart';
import 'package:epic_bible/models/chapter.dart';
import 'package:epic_bible/state/db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_html/flutter_html.dart';

import '../models/verse.dart';

class ViewChapterScreen extends ConsumerStatefulWidget {
  const ViewChapterScreen(
      {super.key, required this.book, required this.chapter});
  final Book book;
  final int chapter;

  @override
  ConsumerState<ViewChapterScreen> createState() => _ViewChapterScreenState();
}

class _ViewChapterScreenState extends ConsumerState<ViewChapterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.book.human} ${widget.chapter}"),
      ),
      body: FutureBuilder<Chapter>(
        future: ref
            .read(dbState)
            .loadChapter(book: widget.book, chapterNo: widget.chapter),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error occurred'),
            );
          }
          return Scrollbar(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 64),
                child: Html(
                  data: snapshot.data!.content,
                  style: {
                    "h4": Style(
                      fontSize: const FontSize(24),
                    ),
                    "p": Style(
                      fontSize: const FontSize(18),
                    ),
                    "sup": Style(
                      fontSize: const FontSize(14),
                      fontWeight: FontWeight.w900,
                    ),
                  },
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: Consumer(builder: (context, ref, __) {
        var dbRef = ref.watch(dbState);
        return Row(
          children: [
            const SizedBox(width: kFloatingActionButtonMargin * 2),
            dbRef.hasPrevChapter
                ? FloatingActionButton(
                    heroTag: 'prevChapter',
                    child: const Icon(Icons.navigate_before_rounded),
                    onPressed: () {
                      var currentChapter = dbRef.lastChapter!;
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (_) => ViewChapterScreen(
                          book: Book(
                            osis: currentChapter.previousReferenceOsis
                                .split(".")
                                .first,
                            human: currentChapter.previousReferenceHuman,
                          ),
                          chapter: int.parse(currentChapter
                              .previousReferenceOsis
                              .split(".")
                              .last),
                        ),
                      ));
                    },
                  )
                : const SizedBox.shrink(),
            const Spacer(),
            dbRef.hasNextChapter
                ? FloatingActionButton(
                    heroTag: 'nextChapter',
                    child: const Icon(Icons.navigate_next_rounded),
                    onPressed: () {
                      var currentChapter = dbRef.lastChapter!;
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (_) => ViewChapterScreen(
                          book: Book(
                            osis: currentChapter.nextReferenceOsis
                                .split(".")
                                .first,
                            human: currentChapter.nextReferenceHuman,
                          ),
                          chapter: int.parse(
                              currentChapter.nextReferenceOsis.split(".").last),
                        ),
                      ));
                    },
                  )
                : const SizedBox.shrink(),
          ],
        );
      }),
    );
  }

  Widget verseWidget(Verse verse) {
    return Text(
      verse.unformatted,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}
