import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:platform_commons_assignment/providers/conectiviity_provider.dart';
import 'package:platform_commons_assignment/providers/get_user_provider.dart';
import 'package:platform_commons_assignment/view/home_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox("users");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GetUserProvider()),
        ChangeNotifierProvider(create: (context) => InternetProvider()),
      ],
      child: MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen()),
    );
  }
}
