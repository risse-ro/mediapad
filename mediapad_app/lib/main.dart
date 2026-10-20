import 'package:flutter/material.dart';
import 'package:mediapad_app/screens/book_details_screen.dart';
import 'package:mediapad_app/screens/book_list_screen.dart';
import 'package:mediapad_app/screens/dashboard_screen.dart';
import 'package:mediapad_app/screens/search_screen.dart';
import 'package:mediapad_app/screens/welcome_screen.dart';
import 'package:mediapad_app/state/application_state.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var appState = ApplicationState();

  await dotenv.load(fileName: "assets/.env");

  runApp(MainApp(applicationState: appState));
}

class MainApp extends StatelessWidget {
  const MainApp({required this.applicationState, super.key});

  final ApplicationState applicationState;

  final defaultProfileImgUrl =
      'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/e507933a-8538-46f6-8e48-5ed262f5d9c1/dluscd0-faa4cc4f-b59c-455e-86d7-ae609b3d07dc.png/v1/fill/w_160,h_160,q_80,strp/frog_avatar_by_cherivinca_dluscd0-fullview.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MTYwIiwicGF0aCI6Ii9mL2U1MDc5MzNhLTg1MzgtNDZmNi04ZTQ4LTVlZDI2MmY1ZDljMS9kbHVzY2QwLWZhYTRjYzRmLWI1OWMtNDU1ZS04NmQ3LWFlNjA5YjNkMDdkYy5wbmciLCJ3aWR0aCI6Ijw9MTYwIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmltYWdlLm9wZXJhdGlvbnMiXX0.KLbkTkYRYvWxVNg-byxo3_hY7dFCBdXrHbnBf0_MsJc';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: TextTheme(
            bodyMedium: TextStyle(
              fontSize: 16,
              color: const Color.fromARGB(255, 39, 24, 14),
            ),
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromARGB(255, 255, 217, 182),
            surface: Color.fromARGB(255, 255, 236, 219),
          ),
          fontFamily: 'Silkscreen',
          appBarTheme: AppBarTheme(
            foregroundColor: const Color.fromARGB(255, 47, 75, 2),
            backgroundColor: Color.fromARGB(244, 215, 255, 151),
          ),
        ),
        routes: {
          '/': (context) => WelcomeScreen(),
          '/dashboard': (context) => DashboardScreen(),
          '/book-list': (context) => BookListScreen(),
          // The sign in screen from firebase ui auth
          '/sign-in': (context) => SignInScreen(
            actions: [
              AuthStateChangeAction((context, state) {
                final user = switch (state) {
                  // User signed in to an existing account
                  SignedIn state => state.user,
                  // User was just created
                  UserCreated state => state.credential.user,
                  // Anything else
                  _ => null,
                };

                // if user is null do nothing (stay on sign in page)
                if (user == null) return;

                // check that a user was just created
                if (state is UserCreated) {
                  user.updateDisplayName(user.email!.split('@').first);
                  user.updatePhotoURL(defaultProfileImgUrl);
                }

                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
              }),
            ],
          ),
          '/register': (context) => RegisterScreen(
            actions: [
              AuthStateChangeAction((context, state) {
                final user = switch (state) {
                  // User signed in to an existing account
                  SignedIn state => state.user,
                  // User was just created
                  UserCreated state => state.credential.user,
                  // Anything else
                  _ => null,
                };

                // if user is null do nothing (stay on sign in page)
                if (user == null) return;

                // check that a user was just created
                if (state is UserCreated) {
                  user.updateDisplayName(user.email!.split('@').first);
                  user.updatePhotoURL(defaultProfileImgUrl);
                }

                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
              }),
            ],
          ),
          // The profile screen from firebase ui auth
          '/profile': (context) => ProfileScreen(
            actions: [
              SignedOutAction((context) {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
              }),
            ],
          ),
          '/search': (context) => SearchScreen(),
          '/book-details': (context) => BookDetailsScreen(),
        },
      ),
    );
  }
}
