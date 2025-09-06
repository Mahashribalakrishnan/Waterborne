import 'package:flutter/widgets.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static const supportedLanguageCodes = ['en', 'ne', 'as', 'hi'];

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'title_welcome': 'Welcome back',
      'subtitle_login': 'Login to your account to continue',
      'hint_phone': 'Phone Number',
      'hint_password': 'Password',
      'forgot_password': 'Forgot Password?',
      'no_account': "Don't have an account? ",
      'sign_up': 'Sign Up',
      'login': 'Login',
      'phone_empty': 'Please enter your phone number',
      'phone_invalid': 'Please enter a valid 10-digit phone number',
      'password_empty': 'Please enter your password',
      'password_length_exact': 'Password must be exactly 8 characters',
    },
    // Nepali (basic placeholders)
    'ne': {
      'title_welcome': 'फेरि स्वागत छ',
      'subtitle_login': 'आफ्नो खाता मा लगइन गर्नुहोस्',
      'hint_phone': 'फोन नम्बर',
      'hint_password': 'पासवर्ड',
      'forgot_password': 'पासवर्ड बिर्सनुभयो?',
      'no_account': 'खाता छैन?',
      'sign_up': 'साइन अप',
      'login': 'लगइन',
      'phone_empty': 'कृपया आफ्नो फोन नम्बर लेख्नुहोस्',
      'phone_invalid': 'कृपया १० अङ्कको मान्य फोन नम्बर लेख्नुहोस्',
      'password_empty': 'कृपया आफ्नो पासवर्ड लेख्नुहोस्',
      'password_length_exact': 'पासवर्ड ठीक ८ अक्षरको हुनुपर्छ',
    },
    // Assamese (basic placeholders)
    'as': {
      'title_welcome': 'ফেৰাই আহ্বান',
      'subtitle_login': 'আগবাঢ়িবলৈ আপোনাৰ একাউন্টত লগিন কৰক',
      'hint_phone': 'ফোন নম্বৰ',
      'hint_password': 'পাছৱৰ্ড',
      'forgot_password': 'পাছৱৰ্ড পাহৰি গ’লেনে?',
      'no_account': 'একাউন্ট নাই?',
      'sign_up': 'ছাইন আপ',
      'login': 'লগিন',
      'phone_empty': 'অনুগ্ৰহ কৰি আপোনাৰ ফোন নম্বৰ দিয়ক',
      'phone_invalid': 'অনুগ্ৰহ কৰি বৈধ ১০ অংকীয়া ফোন নম্বৰ দিয়ক',
      'password_empty': 'অনুগ্ৰহ কৰি আপোনাৰ পাছৱৰ্ড দিয়ক',
      'password_length_exact': 'পাছৱৰ্ড একে ৮টা আখৰৰ হ’ব লাগিব',
    },
    // Hindi
    'hi': {
      'title_welcome': 'वापस स्वागत है',
      'subtitle_login': 'जारी रखने के लिए अपने खाते में लॉगिन करें',
      'hint_phone': 'फोन नंबर',
      'hint_password': 'पासवर्ड',
      'forgot_password': 'पासवर्ड भूल गए?',
      'no_account': 'खाता नहीं है? ',
      'sign_up': 'साइन अप',
      'login': 'लॉगिन',
      'phone_empty': 'कृपया अपना फोन नंबर दर्ज करें',
      'phone_invalid': 'कृपया मान्य 10 अंकों का फोन नंबर दर्ज करें',
      'password_empty': 'कृपया अपना पासवर्ड दर्ज करें',
      'password_length_exact': 'पासवर्ड बिल्कुल 8 अक्षरों का होना चाहिए',
    },
  };

  String t(String key) {
    final code = supportedLanguageCodes.contains(locale.languageCode)
        ? locale.languageCode
        : 'en';
    return _localizedValues[code]?[key] ?? _localizedValues['en']![key] ?? key;
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLanguageCodes.contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
