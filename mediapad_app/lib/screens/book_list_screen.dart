import 'package:flutter/material.dart';
import 'package:mediapad_app/managers/book_manager.dart';
import 'package:mediapad_app/state/application_state.dart';
import 'package:provider/provider.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListState();
}

class _BookListState extends State<BookListScreen> {
  @override
  Widget build(BuildContext context) {
    final data = context.watch<ApplicationState>();
    final completedBooks = getCompletedBookList(data.books);
    final unreadBooks = getUnreadBookList(data.books);

    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Book List'),
          centerTitle: true,
          bottom: TabBar(
            unselectedLabelColor: Color.fromARGB(255, 137, 150, 106),
            labelColor: Color.fromARGB(255, 58, 77, 16),
            indicatorColor: Color.fromARGB(255, 58, 77, 16),
            tabs: [
              Tab(text: 'Completed'),
              Tab(text: 'To Read'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // completed
            completedBooks.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('No completed books yet'),
                  )
                : ListView.builder(
                    // This iterates up to itemcount, adding the returned widget to the screen
                    itemBuilder: (context, index) {
                      final book = completedBooks[index];
                      return Dismissible(
                        key: ValueKey(book.id),
                        child: ListTile(
                          title: Text(book.title),
                          subtitle: Text(book.authorsToString()),
                          trailing: IconButton(
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
                          onTap: () async => {
                            await Navigator.pushNamed(
                              context,
                              '/book-details',
                              arguments: book,
                            ),
                          },
                        ),
                        onDismissed: (direction) {
                          // Direction is either left or right
                          setState(() {
                            data.books.removeAt(index);
                          });
                          data.deleteBook(book);
                        },
                      );
                    },
                    itemCount: completedBooks.length,
                  ),
            // to read
            unreadBooks.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('No books in your reading list'),
                  )
                : ListView.builder(
                    // This iterates up to itemcount, adding the returned widget to the screen
                    itemBuilder: (context, index) {
                      final book = unreadBooks[index];
                      return Dismissible(
                        key: ValueKey(book.id),
                        child: ListTile(
                          title: Text(book.title),
                          subtitle: Text(book.authorsToString()),
                          trailing: IconButton(
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
                          onTap: () async => {
                            await Navigator.pushNamed(
                              context,
                              '/book-details',
                              arguments: book,
                            ),
                          },
                        ),
                        onDismissed: (direction) {
                          // Direction is either left or right
                          setState(() {
                            data.books.removeAt(index);
                          });
                          data.deleteBook(book);
                        },
                      );
                    },
                    itemCount: unreadBooks.length,
                  ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => {Navigator.of(context).pushNamed('/search')},
        ),
      ),
    );
  }
}
