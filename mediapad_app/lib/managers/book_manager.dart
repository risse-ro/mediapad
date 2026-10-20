import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mediapad_app/models/book.dart';

String? bookKey = dotenv.env['BOOK_KEY'];

const bookApi = 'https://www.googleapis.com/books/v1/volumes';

// returns JSON data of books and converts it to a dynamic object
Future<dynamic> getBooksByQuery({required String query}) async {
  try {
    // endpoint uri
    var uri = Uri.parse('$bookApi?q=$query&key=$bookKey');

    // response status code
    var response = await http.get(uri);

    // handle status code errors
    if (response.statusCode != 200) {
      throw Exception('Status ${response.statusCode} received');
    }

    // decode json into object
    var bookJson = jsonDecode(response.body);

    // return object
    return bookJson;
  } catch (e) {
    throw Exception('An error occured: $e');
  }
}

// returns JSON data of a single book and converts it to a dynamic object
Future<dynamic> getBookById({required String id}) async {
  try {
    // endpoint uri
    var uri = Uri.parse('$bookApi/$id?&key=$bookKey');

    // response status code
    var response = await http.get(uri);

    // handle status code errors
    if (response.statusCode != 200) {
      throw Exception('Status ${response.statusCode} received');
    }

    // decode json into object
    var bookJson = jsonDecode(response.body);

    // return object
    return bookJson;
  } catch (e) {
    throw Exception('An error occurred: $e');
  }
}

// filters a book list and returns one with completed books only
List<Book> getCompletedBookList(List<Book> bookList) {
  List<Book>? filteredBooks = bookList.where((book) => book.isRead).toList();
  return filteredBooks;
}

// filters a book list and returns one with incompleted books only
List<Book> getUnreadBookList(List<Book> bookList) {
  List<Book>? filteredBooks = bookList.where((book) => !book.isRead).toList();
  return filteredBooks;
}
