import 'package:flutter/material.dart';
import 'package:mediapad_app/models/book.dart';
import 'package:mediapad_app/state/application_state.dart';
import 'package:mediapad_app/widgets/book_list_item.dart';
import 'package:provider/provider.dart';

class SearchResults extends StatefulWidget {
  const SearchResults({
    super.key,
    required this.results,
    required this.mediaType,
  });

  final List<dynamic> results;
  final String mediaType;

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  Future<void> _editBook(Book book) async {
    final result = await Navigator.pushNamed(
      context,
      '/book-details',
      arguments: book,
    );
    if (result == true && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, data, child) {
        return ListView.separated(
          itemCount: widget.results.length,
          separatorBuilder: (_, _) => const Divider(),
          itemBuilder: (context, index) {
            final book = widget.results[index];
            return BookListItem(book: book, onTap: () => {_editBook(book)});
          },
        );
      },
    );
  }
}
