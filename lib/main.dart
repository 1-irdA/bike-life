import 'package:bike_life/providers/theme_provider.dart';
import 'package:bike_life/providers/year_provider.dart';
import 'package:bike_life/views/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => Year(DateTime.now().year))
  ], child: const App()));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (_) => ThemeModel(),
      child: Consumer<ThemeModel>(
          builder: (context, ThemeModel themeNotifier, child) {
        return MaterialApp(
            title: "Bike's Life",
            theme: themeNotifier.isDark ? ThemeData.dark() : ThemeData.light(),
            home: const HomePage());
      }));
}
