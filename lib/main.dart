import 'package:flutter/material.dart';
import 'package:my_app/screens/search_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Initialize theme provider
  final themeProvider = ThemeProvider();
  await themeProvider.initTheme();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider.value(value: themeProvider)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: "Torret Seach",
      themeMode: themeProvider.themeMode,
      theme: themeProvider.getLightTheme(),
      darkTheme: themeProvider.getDarkTheme(),
      home: SearchScreen(),
    );
  }
}
