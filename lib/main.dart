import 'package:WorkWise/provider/theme_provider.dart';
import 'package:WorkWise/screens/SplashScreen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context)=>themeProvider(ThemeData())),
      ],
      child: ChangeNotifierProvider(
          create: (context) => themeProvider(ThemeData())),
      builder: (context, child) {
    final provider = Provider.of<themeProvider>(context);
    return MaterialApp(
    theme: provider.getTheme(),
    title: 'Flutter Demo',
    home: SplashScreen(),
    );
    },
    );
  } }