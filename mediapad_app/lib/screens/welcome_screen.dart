import 'package:flutter/material.dart';
import 'package:mediapad_app/state/application_state.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  // shader used for fun text gradient
  final Shader linearGradient = LinearGradient(
    colors: <Color>[
      Color.fromARGB(255, 158, 168, 19),
      Color.fromARGB(255, 13, 112, 91),
    ],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 300.0, 70.0));

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, data, child) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/mediapad-welcome-screen.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  spacing: 8,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 4,
                        children: [
                          Center(
                            child: Text(
                              "MediaPad",
                              style: TextStyle(
                                fontSize: 34,
                                foreground: Paint()..shader = linearGradient,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Image(
                            height: 40,
                            width: 40,
                            image: AssetImage(
                              'assets/images/mediapad-icon.png',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 60, right: 60),
                      child: Flexible(
                        child: Center(
                          child: Text(
                            "Keep track of what you love",
                            style: TextStyle(
                              fontSize: 24,
                              color: const Color.fromARGB(255, 97, 126, 31),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Center(
                  // temporarily borrowing the code from the class demo to make sure it's working
                  child: ListenableBuilder(
                    listenable: data,
                    builder: (context, _) {
                      return data.loggedIn
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 100),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                spacing: 4,
                                children: [
                                  FilledButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          WidgetStatePropertyAll<Color>(
                                            Color.fromARGB(255, 97, 126, 31),
                                          ),
                                      foregroundColor:
                                          WidgetStatePropertyAll<Color>(
                                            Colors.white,
                                          ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(
                                        context,
                                      ).pushReplacementNamed('/dashboard');
                                    },
                                    child: Text(
                                      'View Dashboard',
                                      style: TextStyle(
                                        fontSize: 26,
                                        height: 2.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 80),
                              child: Column(
                                spacing: 6,
                                children: [
                                  FilledButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          WidgetStatePropertyAll<Color>(
                                            Color.fromARGB(255, 97, 126, 31),
                                          ),
                                      foregroundColor:
                                          WidgetStatePropertyAll<Color>(
                                            Colors.white,
                                          ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(
                                        context,
                                      ).pushNamed('/sign-in');
                                    },
                                    child: Text(
                                      'Log In',
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ),
                                  TextButton(
                                    style: ButtonStyle(
                                      foregroundColor: WidgetStatePropertyAll(
                                        const Color.fromARGB(
                                          255,
                                          179,
                                          199,
                                          142,
                                        ),
                                      ),
                                    ),
                                    onPressed: () => {
                                      Navigator.of(
                                        context,
                                      ).pushNamed('/register'),
                                    },
                                    child: Text(
                                      "Sign Up",
                                      style: TextStyle(fontSize: 22),
                                    ),
                                  ),
                                ],
                              ),
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
