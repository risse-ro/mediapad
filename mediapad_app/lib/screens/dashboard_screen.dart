import 'dart:ffi';
import 'dart:math';

import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:mediapad_app/models/goal.dart';
import 'package:mediapad_app/state/application_state.dart';
import 'package:mediapad_app/widgets/dashboard_item_summary.dart';
import 'package:mediapad_app/widgets/goal_counter.dart';
import 'package:provider/provider.dart';
import 'package:mediapad_app/managers/book_manager.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _formKey = GlobalKey<FormState>();
  var currentYear = DateTime.now().year;

  late TextEditingController _bookGoalsController;

  @override
  void initState() {
    super.initState();
    _bookGoalsController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // sync controller text when goals data changes
    final data = context.read<ApplicationState>();
    _bookGoalsController.text = data.goals.isNotEmpty
        ? data.goals[0].goalCount.toString()
        : '';
  }

  @override
  void dispose() {
    _bookGoalsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<ApplicationState>();
    final completedBookCount = getCompletedBookList(data.books)?.length ?? 0;
    final goals = data.goals;

    void saveBookGoal() {
      final isValid = _formKey.currentState!.validate();
      var goal = Goal(
        mediaType: 'Books',
        goalCount: int.parse(_bookGoalsController.text),
      );
      if (isValid) {
        if (data.goals.contains(goal)) {
          data.updateGoal(goal);
          const snackBar = SnackBar(content: Text('Goal saved successfully!'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          data.addGoal(goal);
          const snackBar = SnackBar(content: Text('Goal added successfully!'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        Navigator.of(context).pop();
      }
    }

    void deleteBookGoal() {
      var goal = Goal(
        mediaType: 'Books',
        goalCount: int.parse(_bookGoalsController.text),
      );
      if (data.goals.contains(goal)) {
        data.deleteGoal(goal);
        const snackBar = SnackBar(content: Text('Goal deleted successfully!'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        const snackBar = SnackBar(content: Text('No goal exists yet'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      Navigator.of(context).pop();
    }

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
                  SizedBox(
                    height: 55,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        right: 4,
                        left: 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/profile');
                            },
                            child: Text(
                              'Edit Profile',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 10,
                        children: [
                          UserAvatar(size: 100),
                          Text(
                            "Hello, ${data.user!.displayName}!",
                            style: TextStyle(fontSize: 24),
                          ),
                          Divider(
                            height: 25,
                            color: const Color.fromARGB(255, 214, 184, 173),
                            thickness: 2,
                          ),
                          Text(
                            'In $currentYear...',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          DashboardItemSummary(
                            mediaType: 'Books',
                            amount: completedBookCount,
                            imageUrl: 'assets/images/book-pixel.png',
                          ),
                          if (goals.isNotEmpty)
                            GoalCounter(
                              completedBookCount: completedBookCount,
                              goalCount: goals[0].goalCount,
                              mediaType: 'book',
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
                            child: Text(
                              'View Book List',
                              style: TextStyle(fontSize: 18),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamed('/book-list');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 54),
                child: TextButton(
                  onPressed: () async {
                    await showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Stack(
                          clipBehavior: Clip.none,
                          children: <Widget>[
                            Positioned(
                              right: -40,
                              top: -40,
                              child: InkResponse(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: const CircleAvatar(
                                  backgroundColor: Color.fromARGB(
                                    255,
                                    197,
                                    27,
                                    50,
                                  ),
                                  child: Icon(Icons.close, color: Colors.white),
                                ),
                              ),
                            ),
                            Form(
                              // this form is for setting goals
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Book Goal',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: TextFormField(
                                      style: TextStyle(fontSize: 20),
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Empty value cannot be saved';
                                        }
                                        if (int.tryParse(value) == null) {
                                          return 'Enter a valid number';
                                        }
                                        if (int.parse(value) < 1) {
                                          return 'Goal cannot be 0 or negative';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        errorMaxLines: 2,
                                        hintText: 'Book Goal',
                                        hintStyle: TextStyle(
                                          color: const Color.fromARGB(
                                            255,
                                            214,
                                            184,
                                            173,
                                          ),
                                        ),
                                      ),
                                      textAlign: TextAlign.center,
                                      controller: _bookGoalsController,
                                    ),
                                  ),
                                  Row(
                                    spacing: 8,
                                    children: [
                                      FilledButton(
                                        onPressed: () {
                                          deleteBookGoal();
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll<Color>(
                                                Color.fromARGB(
                                                  255,
                                                  197,
                                                  27,
                                                  50,
                                                ),
                                              ),
                                          foregroundColor:
                                              WidgetStatePropertyAll<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                        child: const Text(
                                          'Delete',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      FilledButton(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _formKey.currentState!.save();
                                            saveBookGoal();
                                          }
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll<Color>(
                                                Color.fromARGB(
                                                  255,
                                                  97,
                                                  126,
                                                  31,
                                                ),
                                              ),
                                          foregroundColor:
                                              WidgetStatePropertyAll<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                        child: const Text(
                                          'Save',
                                          style: TextStyle(fontSize: 18),
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
                    );
                  },
                  child: const Text(
                    'Set Goals',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 97, 126, 31),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
