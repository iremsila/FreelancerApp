import 'package:WorkWise/provider/theme_provider.dart';
import 'package:WorkWise/screens/SplashScreen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(ThemeData(brightness: Brightness.light, primarySwatch: Colors.cyan)),
      child:  MyApp(key: UniqueKey(),),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProviderData = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: SplashScreen(),
      theme: themeProviderData.getTheme(),
    );
  }
}
