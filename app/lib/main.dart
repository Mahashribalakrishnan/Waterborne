import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'frontend/ashaworkers/login.dart';
import 'l10n/app_localizations.dart';
import 'locale/locale_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Rebuild MaterialApp when locale changes
    return AnimatedBuilder(
      animation: LocaleController.instance,
      builder: (context, _) {
        return MaterialApp(
          title: 'Waterborne - ASHA Worker',
          locale: LocaleController.instance.locale,
          supportedLocales: const [
            Locale('en'),
            Locale('ne'),
            Locale('as'),
            Locale('hi'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const AshaWorkerLoginPage(),
        );
      },
    );
  }
}
