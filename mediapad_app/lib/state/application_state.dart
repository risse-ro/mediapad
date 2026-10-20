import 'package:flutter/material.dart';
import 'package:mediapad_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
// hide EmailAuthProvider to prevent import collisions
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;

import 'package:mediapad_app/models/book.dart';
import 'package:mediapad_app/models/goal.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  var _loggedIn = false;
  bool get loggedIn => _loggedIn;

  User? _user;
  User? get user => _user;
  set user(User? user) {
    if (user == null) {
      throw ArgumentError('User cannot be set to null');
    }
    _user = user;
  }

  // firestore
  // tracks the current books for the logged in user
  List<Book>? _books;
  List<Book> get books {
    if (user == null) {
      throw StateError('Cannot get books when user is null');
    }

    return _books ?? [];
  }

  set books(List<Book> books) {
    if (user == null) {
      throw StateError('Cannot set books when user is null');
    }

    _books = books;
  }

  void _fetchBooks() {
    if (user == null) {
      throw StateError('Cannot fetch books when user is null');
    }

    // Access the firestore instance
    FirebaseFirestore.instance
        // Get the doc/collection of docs
        .collection('/database/${user!.uid}/books')
        .get()
        // Update the app state to match
        .then((bookCollection) {
          // Convert the docs to Book Model
          books = bookCollection.docs
              .map((doc) => Book.fromFirestore(doc))
              .toList();
          sortBooks(books);
        });
  }

  void addBook(Book book) async {
    // Make sure user is not null
    if (user == null) {
      throw StateError('Cannot add books when user is null');
    }

    // Access firestore instance
    FirebaseFirestore.instance
        .collection('/database/${user!.uid}/books')
        .add(book.toMap())
        .then((_) {
          books.add(book);
          sortBooks(books);
          notifyListeners();
        });
  }

  void updateBook(Book book) async {
    // Make sure user is not null
    if (user == null) {
      throw StateError('Cannot update books when user is null');
    }

    // Access firestore instance
    FirebaseFirestore.instance
        .collection('/database/${user!.uid}/books')
        .doc(book.id)
        // Replace the values in that document
        .update(book.toMap())
        .then((_) {
          sortBooks(books);
          notifyListeners();
        });
  }

  void deleteBook(Book book) async {
    if (user == null) {
      throw StateError('Cannot delete books when user is null');
    }

    FirebaseFirestore.instance
        .collection('/database/${user!.uid}/books')
        .doc(book.id)
        .delete()
        .then((_) {
          // Once the delete occurs in the backend update the app state
          books.remove(book);
          notifyListeners();
        });
  }

  // sorts the book list by favorites, and then by date added
  void sortBooks(List<Book> books) {
    books.sort((a, b) {
      // put favorites at the top
      if (a.favorite && !b.favorite && a.favorite != b.favorite) {
        return -1;
      } else if (!a.favorite && b.favorite && a.favorite != b.favorite) {
        return 1;
      } else {
        // compare by added date next
        return a.dateAdded.compareTo(b.dateAdded);
      }
    });
  }

  // Goals
  List<Goal>? _goals;
  List<Goal> get goals {
    if (user == null) {
      throw StateError('Cannot get goals when user is null');
    }

    return _goals ?? [];
  }

  set goals(List<Goal> goals) {
    if (user == null) {
      throw StateError('Cannot set goals when user is null');
    }

    _goals = goals;
  }

  void _fetchGoals() {
    if (user == null) {
      throw StateError('Cannot fetch goals when user is null');
    }

    // Access the firestore instance
    FirebaseFirestore.instance
        // Get the doc/collection of docs
        .collection('/database/${user!.uid}/goals/')
        .get()
        // Update the app state to match
        .then((goalCollection) {
          // Convert the docs to Book Model
          goals = goalCollection.docs
              .map((doc) => Goal.fromFirestore(doc))
              .toList();
        });
  }

  void addGoal(Goal goal) async {
    // Make sure user is not null
    if (user == null) {
      throw StateError('Cannot add goals when user is null');
    }

    // Access firestore instance
    FirebaseFirestore.instance
        .collection('/database/${user!.uid}/goals')
        .doc(goal.mediaType)
        .set({"mediaType": goal.mediaType, "goalCount": goal.goalCount})
        .then((_) {
          goals.add(goal);
          notifyListeners();
        });
  }

  void updateGoal(Goal goal) async {
    // Make sure user is not null
    if (user == null) {
      throw StateError('Cannot update goals when user is null');
    }

    // Access firestore instance
    FirebaseFirestore.instance
        .collection('/database/${user!.uid}/goals')
        .doc(goal.mediaType)
        // Replace the values in that document
        .update(goal.toMap())
        .then((_) {
          // this replaces it in the local list if it exists
          final index = goals.indexWhere((g) => g.mediaType == goal.mediaType);
          if (index != -1) {
            goals[index] = goal;
          }
          notifyListeners();
        });
  }

  void deleteGoal(Goal goal) async {
    if (user == null) {
      throw StateError('Cannot delete goals when user is null');
    }

    FirebaseFirestore.instance
        .collection('/database/${user!.uid}/goals')
        .doc(goal.mediaType)
        .delete()
        .then((_) {
          // Once the delete occurs in the backend update the app state
          goals.remove(goal);
          notifyListeners();
        });
  }

  // initializes connection to firebase and configures auth settings and listeners
  Future<void> init() async {
    // connects to firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseUIAuth.configureProviders([EmailAuthProvider()]);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user == null) {
        _loggedIn = false;
      } else {
        _loggedIn = true;
        // saves user value to app state once logged in
        this.user = user;
        // then fetch all their books and store them in the app state
        _fetchBooks();
        _fetchGoals();
      }
      notifyListeners();
    });
  }
}
