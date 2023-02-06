import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:magator/utils/themes/dark.dart';
import 'package:magator/utils/themes/light.dart';
import 'package:path_provider/path_provider.dart';
import 'db/config.dart';
import 'screens/home.dart';
import 'broker/broker.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();

  // initializing hive database;
  DataBase db = DataBase();
  await db.initilizeHive(directory.path);
  GetIt.I.registerSingleton<DataBase>(db, instanceName: "db");

  // initializing custom message brocker;
  Broker broker = Broker();
  GetIt.I.registerSingleton<Broker>(broker, instanceName: "broker");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magator',
      debugShowCheckedModeBanner: false,
      theme: lightThemeData(context),
      darkTheme: dartThemeData(context),
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}
