import 'package:epic_bible/models/book.dart';
import 'package:epic_bible/screens/chapters.dart';
import 'package:epic_bible/state/db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BooksScreen extends ConsumerStatefulWidget {
  const BooksScreen({super.key});

  @override
  ConsumerState<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends ConsumerState<BooksScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            primary: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Epic Bible',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              centerTitle: true,
            ),
          ),
          SliverAppBar(
            floating: true,
            snap: true,
            primary: false,
            toolbarHeight: 24,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(kTextTabBarHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _textEditingController,
                  onChanged: (value) {
                    // Rebuild the screen so the FutureBuilder redraws with new data
                    setState(() {});
                  },
                  maxLines: 1,
                  decoration: InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32)),
                      prefixIcon: IconButton(
                          onPressed: () {
                            // Lose focus
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          icon: const Icon(Icons.search)),
                      suffixIcon: IconButton(
                          onPressed: () {
                            _textEditingController.clear();
                            // rebuld screen
                            setState(() {});
                          },
                          icon: const Icon(Icons.close)),
                      hintText: 'Search Books'),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: booksList()),
        ],
      ),
    );
  }

  Widget booksList() {
    return FutureBuilder<List<Book>>(
      future:
          ref.read(dbState).loadBooks(searchText: _textEditingController.text),
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
        if (snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No books found'),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            spacing: 12.0,
            alignment: WrapAlignment.center,
            children: List.generate(
              snapshot.data!.length,
              (index) => GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) =>
                          ChaptersScreen(book: snapshot.data![index])));
                },
                child: Chip(
                  label: Text(snapshot.data![index].human!),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
