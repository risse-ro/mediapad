import 'package:flutter/material.dart';
import 'package:mediapad_app/managers/book_manager.dart';
import 'package:mediapad_app/models/book.dart';
import 'package:mediapad_app/widgets/search_results.dart';

class Search extends StatefulWidget {
  const Search({super.key, required this.mediaType});

  final String mediaType;

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();
  late List<dynamic> _searchResults = [];
  var _message = 'No results yet. Search something!';
  var _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _getSearchResults() async {
    setState(() {
      _searchResults = [];
      _isLoading = true;
      _message = '';
    });

    var bookList = [];

    try {
      final searchJson = await getBooksByQuery(query: _searchController.text);
      final searchResults = searchJson['items'];

      for (int i = 0; i < searchResults.length; i++) {
        var bookObject = Book.fromBookApiData(searchResults[i]);
        bookList.add(bookObject);

        setState(() {
          _searchResults = bookList;
          _isLoading = false;
          _formKey.currentState!.reset();
        });
      }
    } catch (e) {
      setState(() {
        _message = 'A problem occurred: No results found';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 16,
          children: [
            TextFormField(
              textAlign: TextAlign.center,
              controller: _searchController,
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Query cannot be empty'
                  : null,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                hintText: 'Search...',
                hintStyle: TextStyle(
                  color: const Color.fromARGB(255, 214, 184, 173),
                ),
              ),
            ),
            FilledButton.icon(
              style: ButtonStyle(
                iconAlignment: IconAlignment.end,
                backgroundColor: WidgetStatePropertyAll<Color>(
                  Color.fromARGB(255, 97, 126, 31),
                ),
                foregroundColor: WidgetStatePropertyAll<Color>(Colors.white),
              ),
              icon: Icon(Icons.search, size: 24),
              label: Text(
                'Search ${widget.mediaType}',
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () async => {_getSearchResults()},
            ),
            Divider(
              height: 10,
              color: const Color.fromARGB(255, 214, 184, 173),
              thickness: 2,
            ),
            _message != ''
                ? Center(child: Text(_message, textAlign: TextAlign.center))
                : _isLoading
                ? CircularProgressIndicator()
                : Column(
                    spacing: 4,
                    children: [
                      Text(
                        _searchResults.length > 1
                            ? '${_searchResults.length} results found'
                            : '${_searchResults.length} result found',
                      ),
                      SizedBox(
                        height: 490,
                        child: SearchResults(
                          results: _searchResults,
                          mediaType: widget.mediaType,
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
