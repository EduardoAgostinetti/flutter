import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import './auth/signin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('ar'), // Árabe
        Locale('bg'), // Búlgaro
        Locale('ca'), // Catalão
        Locale('zh', 'CN'), // Chinês Simplificado
        Locale('zh', 'TW'), // Chinês Tradicional
        Locale('ko'), // Coreano
        Locale('da'), // Dinamarquês
        Locale('sk'), // Eslovaco
        Locale('sl'), // Esloveno
        Locale('et'), // Estoniano
        Locale('fi'), // Finlandês
        Locale('fr'), // Francês
        Locale('el'), // Grego
        Locale('de'), // Alemão
        Locale('hu'), // Húngaro
        Locale('is'), // Islandês
        Locale('en'), // Inglês
        Locale('it'), // Italiano
        Locale('ja'), // Japonês
        Locale('lv'), // Letão
        Locale('lt'), // Lituano
        Locale('ms'), // Malaio
        Locale('no'), // Norueguês
        Locale('pl'), // Polonês
        Locale('pt'), // Português
        Locale('ro'), // Romeno
        Locale('ru'), // Russo
        Locale('es'), // Espanhol
        Locale('sv'), // Sueco
        Locale('tr'), // Turco
        Locale('uk'), // Ucraniano
        Locale('cs'), // Tcheco
      ],
      path: 'assets/translations',
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Desport',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const LoginScreen(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Montserrat',
      ),
    );
  }
}
