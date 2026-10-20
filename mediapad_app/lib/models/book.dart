import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  // properties
  // ID for the database
  late String? _id;
  // google book specific ID
  late String? _googleBooksId;
  late String _title;
  late List<String> _authors;
  late String _publishDate;
  late DateTime _dateAdded;
  late DateTime? _dateCompleted;
  late String? _imageUrl;
  late int? _rating;
  late bool _isRead;
  late bool _favorite;
  late String? _notes;

  // constructors
  Book({
    String? id,
    String? googleBooksId,
    required String title,
    required List<String> authors,
    required String publishDate,
    required DateTime dateAdded,
    required bool isRead,
    DateTime? dateCompleted,
    String? imageUrl,
    int? rating,
    bool? favorite,
    String? notes,
  }) {
    this.id = id;
    this.googleBooksId = googleBooksId;
    this.title = title;
    this.authors = authors;
    this.publishDate = publishDate;
    this.dateAdded = dateAdded;
    this.isRead = isRead;
    this.favorite = favorite;
    this.dateCompleted = dateCompleted;
    this.imageUrl = imageUrl;
    this.rating = rating;
    this.notes = notes;
  }

  // factory constructors
  // book API to Book
  factory Book.fromBookApiData(dynamic bookJson) {
    return Book(
      googleBooksId: bookJson['id'],
      title: bookJson['volumeInfo']['title'],
      authors: getAuthors(bookJson['volumeInfo']['authors']),
      publishDate: bookJson['volumeInfo']['publishedDate'],
      imageUrl: bookJson['volumeInfo']['imageLinks']['thumbnail'],
      rating: 0,
      dateAdded: DateTime.now(),
      isRead: false,
      favorite: false,
    );
  }

  // factory constructor to convert from firestore to Book
  factory Book.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Book(
      googleBooksId: data!['googleBooksId'],
      imageUrl: data['imageUrl'],
      title: data['title'],
      authors: getAuthors(data['authors']),
      publishDate: data['publishDate'],
      dateAdded: data['dateAdded'].toDate(),
      dateCompleted: getCompletedDate(data['dateCompleted']),
      isRead: data['isRead'],
      favorite: data['favorite'],
      notes: data['notes'],
      id: snapshot.id,
    );
  }

  // getters and setters
  String? get id => _id;

  set id(String? value) {
    if (value == null) {
      _id = null;
    } else {
      _id = value;
    }
  }

  String? get googleBooksId => _googleBooksId;

  set googleBooksId(String? value) {
    _googleBooksId = value;
  }

  String get title => _title;

  set title(String value) {
    if (value.trim().isEmpty) {
      throw Exception('Title cannot be empty');
    }
    _title = value;
  }

  List<String> get authors => _authors;

  set authors(List<String> authors) {
    if (authors.isEmpty) {
      throw Exception('There must be at least 1 author');
    }
    _authors = authors;
  }

  String get publishDate => _publishDate;

  set publishDate(String value) {
    if (value.trim().isEmpty) {
      throw Exception('Publish date cannot be empty');
    }
    _publishDate = value;
  }

  DateTime get dateAdded => _dateAdded;

  set dateAdded(DateTime value) {
    if (value.isAfter(DateTime.now())) {
      throw Exception('Date added cannot be in the future');
    }
    _dateAdded = value;
  }

  DateTime? get dateCompleted => _dateCompleted;

  set dateCompleted(DateTime? value) {
    if (value == null) {
      _dateCompleted = null;
    } else {
      if (value.isAfter(DateTime.now())) {
        throw Exception('Date completed cannot be in the future');
      }
      _dateCompleted = value;
    }
  }

  // maybe this can be removed
  bool get isRead => _isRead;

  set isRead(bool value) {
    _isRead = value;
  }

  bool get favorite => _favorite;

  set favorite(bool? value) {
    if (value == null) {
      _favorite = false;
    } else {
      _favorite = value;
    }
  }

  String? get imageUrl => _imageUrl;

  set imageUrl(String? value) {
    _imageUrl = value;
  }

  int? get rating => _rating;

  set rating(int? value) {
    if (value == null) {
      _rating = 0;
    } else {
      if (value < 0) {
        throw Exception('Rating cannot be under 0');
      }
      if (value > 5) {
        throw Exception('Rating cannot be more than 5');
      }
      _rating = value;
    }
  }

  String? get notes => _notes;

  set notes(String? value) {
    _notes = value;
  }

  // methods
  static List<String> getAuthors(dynamic json) {
    List<String> authorList = [];
    for (int i = 0; i < json.length; i++) {
      authorList.add(json[i]);
    }
    return authorList;
  }

  // this method exists to handle the potential of a null completion date
  // otherwise it would throw an error when using ToDate
  static DateTime? getCompletedDate(dynamic value) {
    if (value == null) {
      return null;
    } else {
      return value.toDate();
    }
  }

  String authorsToString() {
    var authorString = '';
    for (int i = 0; i < authors.length; i++) {
      // if it is the last author, just add it to string
      // else, add a comma and space for the next author to be appended
      if (authors[i] == authors[authors.length - 1]) {
        authorString += authors[i];
      } else {
        authorString += '${authors[i]}, ';
      }
    }
    return authorString;
  }

  @override
  String toString() {
    // takes the author list and places them all into a string
    var authorString = authorsToString();
    return 'Book $title by $authorString published on $publishDate was added on $dateAdded. Completion status is $isRead.';
  }

  // toMap function for firestore inserts
  Map<String, dynamic> toMap() {
    return {
      'googleBooksId': googleBooksId,
      'title': title,
      'authors': authors,
      'publishDate': publishDate,
      'dateAdded': dateAdded,
      'dateCompleted': dateCompleted,
      'rating': rating,
      'isRead': isRead,
      'favorite': favorite,
      'notes': notes,
      'imageUrl': imageUrl,
    };
  }
}
