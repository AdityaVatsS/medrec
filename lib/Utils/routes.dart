import 'package:flutter/material.dart';
import 'package:medrec/Pages/doctor_home_page.dart';
import 'package:medrec/Pages/login.dart';
import 'package:medrec/Pages/medical_record_page.dart';
import 'package:medrec/Pages/patient_home_page.dart';
import 'package:medrec/Pages/prescription_page.dart';
import 'package:medrec/Pages/register.dart';

class MyRoutes {
  // Static route names
  static String loginPage = "/login";
  static String registerPage = "/register";
  static String patientHomePage = "/patientHome";
  static String doctorHomePage = "/doctorHome";
  static String prescriptionPage = "/prescription";
  static String medicalRecordPage = "/medicalRecord";

  // Metadata for debugging and logging
  static final Map<String, String> _routeMetadata = {
    'lastUpdated': '2025-01-02 22:11:43',
    'updatedBy': 'AdityaVatsS',
  };

  // Route generator function
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case '/patientHome':
        return MaterialPageRoute(builder: (_) => const PatientHomePage());
      case '/doctorHome':
        return MaterialPageRoute(builder: (_) => const DoctorHomePage());
      case '/prescription':
        return MaterialPageRoute(builder: (_) => const PrescriptionPage());
      case '/medicalRecord':
        return MaterialPageRoute(builder: (_) => const MedicalRecordPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  // Named routes map for direct usage
  static final Map<String, WidgetBuilder> routes = {
    loginPage: (context) => const LoginPage(),
    registerPage: (context) => const RegisterPage(),
    patientHomePage: (context) => const PatientHomePage(),
    doctorHomePage: (context) => const DoctorHomePage(),
    prescriptionPage: (context) => const PrescriptionPage(),
    medicalRecordPage: (context) => const MedicalRecordPage(),
  };

  // Method to get route timestamp
  static String getLastUpdated() {
    return _routeMetadata['lastUpdated'] ?? '';
  }

  // Method to get route updater
  static String getUpdatedBy() {
    return _routeMetadata['updatedBy'] ?? '';
  }

  // Validation method for routes
  static bool isValidRoute(String route) {
    return routes.containsKey(route);
  }

  // Helper method to handle navigation with logging
  static Future<T?> navigateTo<T>(BuildContext context, String routeName) {
    print('Navigating to $routeName at ${DateTime.now().toUtc()}');
    print('Navigation requested by: ${_routeMetadata['updatedBy']}');
    return Navigator.pushNamed<T>(context, routeName);
  }

  // Helper method for replacement navigation with logging
  static Future<T?> navigateReplacementTo<T>(
      BuildContext context, String routeName) {
    print('Replacing route with $routeName at ${DateTime.now().toUtc()}');
    print('Navigation requested by: ${_routeMetadata['updatedBy']}');
    return Navigator.pushReplacementNamed<T, void>(context, routeName);
  }
}