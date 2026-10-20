import 'package:flutter/material.dart';
import 'package:mediapad_app/models/book.dart';

class BookListItem extends StatelessWidget {
  const BookListItem({super.key, required this.book, required this.onTap});

  final Book book;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        book.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text('${book.authorsToString()} - ${book.publishDate}')],
      ),
      onTap: onTap,
    );
  }
}
