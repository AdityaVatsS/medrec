import 'package:flutter/material.dart';
import 'package:medrec/utils/routes.dart';
import 'package:medrec/utils/connector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Connector.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedRec',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: MyRoutes.loginPage,
      onGenerateRoute: MyRoutes.generateRoute,
      routes: MyRoutes.routes,
    );
  }
}