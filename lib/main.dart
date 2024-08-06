import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuan08/app/page/auth/login.dart';
import 'package:tuan08/provider/add_provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return ProductProvider();
        })
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary: Color.fromARGB(255, 98, 4, 4),
            onPrimary: Color.fromARGB(255, 242, 242, 242),
            secondary: Color.fromARGB(255, 20, 13, 12),
            onSecondary: Colors.white,
            error: Colors.red,
            onError: Colors.white,
            background: Color.fromARGB(255, 255, 245, 239)!,
            onBackground: Colors.black,
            surface: Colors.white,
            onSurface: Colors.black,
          ),
          buttonTheme: ButtonThemeData(
            buttonColor: const Color.fromARGB(255, 0, 0, 0),
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          appBarTheme: const AppBarTheme(
            color: Color.fromARGB(172, 0, 0, 0),
            iconTheme: IconThemeData(color: Color.fromARGB(255, 0, 0, 0)),
            titleTextStyle:
                TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20.0),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Color.fromARGB(255, 93, 51, 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide:
                  const BorderSide(color: Color.fromARGB(255, 174, 6, 0)),
            ),
            hintStyle: const TextStyle(color: Color.fromARGB(255, 255, 60, 0)),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color.fromARGB(255, 71, 5, 5),
          ),
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
