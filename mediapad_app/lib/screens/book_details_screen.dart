import 'package:flutter/material.dart';
import 'package:mediapad_app/models/book.dart';
import 'package:mediapad_app/state/application_state.dart';
import 'package:mediapad_app/widgets/star_rating.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class BookDetailsScreen extends StatefulWidget {
  const BookDetailsScreen({super.key});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    // Extract the book from the route arguments
    final book = ModalRoute.of(context)!.settings.arguments as Book;
    final Color lightBrown = Color.fromARGB(255, 107, 73, 54);

    final formKey = GlobalKey<FormState>();
    late TextEditingController notesController = TextEditingController(
      text: book.notes,
    );

    @override
    void dispose() {
      notesController.dispose();
      super.dispose();
    }

    void saveBookNotes() {
      if (formKey.currentState!.validate()) {
        setState(() {
          book.notes = notesController.text;
        });
      }
    }

    return Consumer<ApplicationState>(
      builder: (context, data, child) {
        return Scaffold(
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(
                  context,
                ).size.height, // at least full screen height
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        height: 60,
                        color: const Color.fromARGB(255, 224, 199, 183),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 26,
                            right: 4,
                            left: 4,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () => {Navigator.of(context).pop()},
                                icon: Icon(Icons.arrow_back),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    book.favorite = !book.favorite;
                                  });
                                  data.updateBook(book);
                                },
                                icon: book.favorite
                                    ? Icon(
                                        Icons.favorite,
                                        color: Color.fromARGB(255, 197, 27, 50),
                                      )
                                    : Icon(Icons.favorite_outline),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              color: const Color.fromARGB(255, 224, 199, 183),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  left: 16,
                                  right: 16,
                                  bottom: 16,
                                ),
                                child: Row(
                                  spacing: 8,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (book.imageUrl != null)
                                      SizedBox(
                                        width: 120,
                                        child: Image.network(book.imageUrl!),
                                      ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            book.title,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: const Color.fromARGB(
                                                255,
                                                39,
                                                63,
                                                12,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            book.authorsToString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            'Published: ${book.publishDate}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: lightBrown),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Added to reading list on'),
                                  Text(
                                    DateFormat.yMMMMd().format(book.dateAdded),
                                    style: TextStyle(color: lightBrown),
                                  ),
                                  if (book.isRead && book.dateCompleted != null)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Book marked completed on'),
                                        Text(
                                          DateFormat.yMMMMd().format(
                                            book.dateCompleted!,
                                          ),
                                          style: TextStyle(color: lightBrown),
                                        ),
                                      ],
                                    ),
                                  Text('Rating'),
                                  StarRating(
                                    rating: book.rating != null
                                        ? book.rating!
                                        : 0,
                                    isFinished: book.isRead,
                                    onRatingChanged: book.isRead
                                        ? (rating) {
                                            setState(() {
                                              book.rating = rating;
                                            });
                                          }
                                        : null,
                                  ),
                                  Text('Notes'),
                                  SizedBox(
                                    height: 120,
                                    child: TextFormField(
                                      textAlignVertical: TextAlignVertical.top,
                                      maxLines: null,
                                      expands: true,
                                      controller: notesController,
                                      decoration: const InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding: EdgeInsets.all(4),
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Read?',
                                        style: TextStyle(fontSize: 22),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            book.isRead = !book.isRead;
                                            if (book.isRead) {
                                              book.dateCompleted =
                                                  DateTime.now();
                                            } else {
                                              book.dateCompleted = null;
                                            }
                                          });
                                        },
                                        icon: Icon(
                                          book.isRead
                                              ? Icons.check_box
                                              : Icons.check_box_outline_blank,
                                          color: book.isRead
                                              ? Color.fromARGB(255, 97, 126, 31)
                                              : Colors.grey,
                                          size: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 56),
                    child: Row(
                      spacing: 16,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FilledButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll<Color>(
                              Color.fromARGB(255, 197, 27, 50),
                            ),
                            foregroundColor: WidgetStatePropertyAll<Color>(
                              Colors.white,
                            ),
                          ),
                          onPressed: () {
                            if (data.books.contains(book)) {
                              data.deleteBook(book);
                              const snackBar = SnackBar(
                                content: Text('Book Deleted successfully!'),
                                // action: SnackBarAction(
                                //   label: 'Undo',
                                //   onPressed: () {
                                //     data.updateBook(book);
                                //   },
                                // ),
                              );
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(snackBar);
                            } else {
                              const snackBar = SnackBar(
                                content: Text('Book has not been added'),
                              );
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(snackBar);
                            }
                            if (mounted) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/book-list',
                                (route) => route.settings.name == '/',
                              );
                            }
                          },
                          child: Text('Delete', style: TextStyle(fontSize: 30)),
                        ),
                        FilledButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll<Color>(
                              Color.fromARGB(255, 97, 126, 31),
                            ),
                            foregroundColor: WidgetStatePropertyAll<Color>(
                              Colors.white,
                            ),
                          ),
                          onPressed: () {
                            saveBookNotes();
                            if (data.books.contains(book)) {
                              data.updateBook(book);
                              const snackBar = SnackBar(
                                content: Text('Book updated successfully!'),
                              );
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(snackBar);
                            } else {
                              data.addBook(book);
                              const snackBar = SnackBar(
                                content: Text(
                                  'Book added to list successfully!',
                                ),
                              );
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(snackBar);
                            }
                            if (mounted) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/book-list',
                                (route) => route.settings.name == '/dashboard',
                              );
                            }
                          },
                          child: Text('Save', style: TextStyle(fontSize: 30)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
