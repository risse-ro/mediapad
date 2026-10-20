import 'package:mediapad_app/managers/book_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediapad_app/models/book.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  group('Book Class/Model Tests', () {
    // test valid book
    test('Create a new valid book', () {
      var date = DateTime.now();

      final book = Book(
        title: "Test",
        authors: ["Cherisse Rogers"],
        publishDate: "2022-05-16",
        dateAdded: date,
        isRead: false,
      );

      expect(book.title, "Test");
      expect(book.authors, ["Cherisse Rogers"]);
      expect(book.publishDate, "2022-05-16");
      expect(book.dateAdded, date);
      expect(book.isRead, false);
      expect(book.dateCompleted, null);
      expect(book.favorite, false);
    });

    // test that empty title throws error
    test('Empty title throws exception', () {
      var date = DateTime.now();

      expect(
        () => Book(
          title: "",
          authors: ["Cherisse Rogers"],
          publishDate: "2022-05-16",
          dateAdded: DateTime.now(),
          isRead: false,
        ),
        throwsA(isA<Exception>()),
      );
    });

    // test that empty authors throws error
    test('Empty author throws exception', () {
      var date = DateTime.now();

      expect(
        () => Book(
          title: "Test",
          authors: [],
          publishDate: "2022-05-16",
          dateAdded: DateTime.now(),
          isRead: false,
        ),
        throwsA(isA<Exception>()),
      );
    });

    // test that future publish date throws error
    test('Empty publish date throws exception', () {
      expect(
        () => Book(
          title: "Title",
          authors: ["Cherisse Rogers"],
          publishDate: "",
          dateAdded: DateTime.now(),
          isRead: false,
        ),
        throwsA(isA<Exception>()),
      );
    });

    // test that future date added throws error
    test('Future date added throws exception', () {
      var date = DateTime.now();

      expect(
        () => Book(
          title: "Title",
          authors: ["Cherisse Rogers"],
          publishDate: "2022-05-16",
          dateAdded: DateTime(2029, 5, 16),
          isRead: false,
        ),
        throwsA(isA<Exception>()),
      );
    });

    // test the setters for the other properties (dateCompleted, notes, rating)
    test('Setters for optional properties set correctly', () {
      var date = DateTime.now();

      final book = Book(
        title: "Test",
        authors: ["Cherisse Rogers"],
        publishDate: "2022-05-16",
        dateAdded: date,
        isRead: false,
      );

      book.dateCompleted = DateTime(2026, 4, 9);
      book.isRead = true;
      book.notes = "I liked this book soooo much";
      book.rating = 3;

      expect(book.dateCompleted, DateTime(2026, 4, 9));
      expect(book.isRead, true);
      expect(book.notes, "I liked this book soooo much");
      expect(book.rating, 3);
    });

    // out of range book rating throws error
    test('Out of range book rating throws exception', () {
      var date = DateTime.now();

      final book = Book(
        title: "Test",
        authors: ["Cherisse Rogers"],
        publishDate: "2022-05-16",
        dateAdded: date,
        isRead: false,
      );

      expect(() => book.rating = 7, throwsA(isA<Exception>()));
    });

    // completion date in the future throws error
    test('Future completion date throws exception', () {
      var date = DateTime.now();

      final book = Book(
        title: "Test",
        authors: ["Cherisse Rogers"],
        publishDate: "2022-05-16",
        dateAdded: date,
        isRead: false,
      );

      expect(() => book.rating = 7, throwsA(isA<Exception>()));
    });

    // test toString method override
    test('ToString method returns expected string', () {
      var date = DateTime.now();

      final book = Book(
        title: "Test",
        authors: ["Cherisse Rogers", "Kelli Belli"],
        publishDate: "2022-05-16",
        dateAdded: date,
        isRead: false,
      );

      expect(
        book.toString(),
        "Book Test by Cherisse Rogers, Kelli Belli published on 2022-05-16 was added on $date. Completion status is false.",
      );
    });
  });

  group('Book API tests', () {
    // test factory constructor from API
    test('Create a book from the Book API successfully', () async {
      await dotenv.load(fileName: "assets/.env");
      var bookData = await getBookById(id: 'zyTCAlFPjgYC');

      var book = Book.fromBookApiData(bookData);

      expect(book.googleBooksId, 'zyTCAlFPjgYC');
      expect(book.title, 'The Google Story (2018 Updated Edition)');
      expect(book.authors, ["David A. Vise", "Mark Malseed"]);
      expect(book.publishDate, "2005-11-15");
    });

    // testing getBookByQuery method
    test(
      'Count of book search results is correct and books are created properly',
      () async {
        await dotenv.load(fileName: "assets/.env");
        var bookData = await getBooksByQuery(query: 'Twilight');
        var bookResults = bookData['items'];
        var bookList = [];

        for (int i = 0; i < bookResults.length; i++) {
          var bookObject = Book.fromBookApiData(bookResults[i]);
          bookList.add(bookObject);
        }

        expect(bookResults.length, 10);
        expect(bookList.length, 10);
      },
    );
  });
}
