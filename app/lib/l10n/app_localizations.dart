import 'package:flutter/widgets.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static const supportedLanguageCodes = ['en', 'ne', 'as', 'hi'];

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'nav_home_title': 'Home',
      'hello_priya': 'Hello, Priya',
      'village_label': 'Village',
      'district_label': 'District',
      'outbreak_stage_label': 'Outbreak Stage',
      'geo_risk_map': 'Geo Risk Map',
      'risk_level_low': 'Risk Level: Low',
      'recent_reports': 'Recent Reports',
      'synced': 'Synced',
      'not_synced': 'Not Synced',
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
      // Signup additions
      'title_signup': 'ASHA Worker Signup',
      'hint_asha_id': 'ASHA  Worker ID',
      'hint_full_name': 'Full  Name',
      'hint_confirm_password': 'Confirm  Password',
      'label_country': 'Country',
      'label_state': 'State',
      'label_district': 'District',
      'label_village': 'Village',
      'back_to_login': 'Back to Login',
      'password_rules': 'Password must be 8 chars incl. upper, lower, digit, symbol',
      'id_empty': 'Please enter your ASHA Worker ID',
      'name_empty': 'Please enter your name',
      'confirm_password_empty': 'Please confirm your password',
      'password_mismatch': 'Passwords do not match',
      'select_village': 'Please select a village',
      'form_fix_errors': 'Please fix errors in the form',
    },
    // Nepali (basic placeholders)
    'ne': {
      'nav_home_title': 'होम',
      'hello_priya': 'प्रिय, नमस्ते',
      'village_label': 'गाउँ',
      'district_label': 'जिल्ला',
      'outbreak_stage_label': 'आउटब्रेक चरण',
      'geo_risk_map': 'भौगोलिक जोखिम नक्सा',
      'risk_level_low': 'जोखिम स्तर: कम',
      'recent_reports': 'भर्खरका प्रतिवेदनहरू',
      'synced': 'समक्रमित',
      'not_synced': 'असमक्रमित',
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
      // Signup additions
      'title_signup': 'आशा कार्यकर्ता साइनअप',
      'hint_asha_id': 'आशा  कार्यकर्ता ID',
      'hint_full_name': 'पूरा  नाम',
      'hint_confirm_password': 'पासवर्ड पुष्टि गर्नुहोस्',
      'label_country': 'देश',
      'label_state': 'राज्य',
      'label_district': 'जिल्ला',
      'label_village': 'गाउँ',
      'back_to_login': 'लगइनमा फर्कनुहोस्',
      'password_rules': 'पासवर्ड ८ अक्षरको हुनु पर्नेछ: ठूलो/सानो अक्षर, अंक, प्रतीक',
      'id_empty': 'कृपया आफ्नो आशा ID लेख्नुहोस्',
      'name_empty': 'कृपया आफ्नो नाम लेख्नुहोस्',
      'confirm_password_empty': 'कृपया पासवर्ड पुष्टि गर्नुहोस्',
      'password_mismatch': 'पासवर्ड मिलेन',
      'select_village': 'कृपया गाउँ छान्नुहोस्',
      'form_fix_errors': 'कृपया फारमका त्रुटिहरू सच्याउनुहोस्',
    },
    // Assamese (basic placeholders)
    'as': {
      'nav_home_title': 'ঘৰ',
      'hello_priya': 'প্ৰিয়া, নমস্কাৰ',
      'village_label': 'গাঁও',
      'district_label': 'জিলা',
      'outbreak_stage_label': 'আউটব্ৰেক স্তৰ',
      'geo_risk_map': 'ভৌগোলিক বিপদ মানচিত্ৰ',
      'risk_level_low': 'ঝুঁকিৰ স্তৰ: কম',
      'recent_reports': 'শেহতীয়া প্ৰতিবেদনসমূহ',
      'synced': 'ছিংক্ড',
      'not_synced': 'নছিংকড',
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
      // Signup additions
      'title_signup': 'আশা কৰ্মী ছাইনআপ',
      'hint_asha_id': 'আশা  কৰ্মী ID',
      'hint_full_name': 'সম্পূৰ্ণ  নাম',
      'hint_confirm_password': 'পাছৱৰ্ড নিশ্চিত কৰক',
      'label_country': 'দেশ',
      'label_state': 'ৰাজ্য',
      'label_district': 'জিলা',
      'label_village': 'গাঁও',
      'back_to_login': 'লগিনলৈ ঘুৰি যাওক',
      'password_rules': '৮ আখৰ: ডাঙৰ/সৰু আখৰ, সংখ্যা, বিশেষ চিহ্ন থাকিব লাগিব',
      'id_empty': 'অনুগ্ৰহ কৰি আপোনাৰ আশা ID দিয়ক',
      'name_empty': 'অনুগ্ৰহ কৰি আপোনাৰ নাম দিয়ক',
      'confirm_password_empty': 'পাছৱৰ্ড নিশ্চিত কৰক',
      'password_mismatch': 'পাছৱৰ্ড মিল নাই',
      'select_village': 'অনুগ্ৰহ কৰি গাঁও বাছনি কৰক',
      'form_fix_errors': 'অনুগ্ৰহ কৰি ফৰ্মৰ ত্ৰুটিবোৰ সোধাৰা কৰক',
    },
    // Hindi
    'hi': {
      'nav_home_title': 'होम',
      'hello_priya': 'हैलो, प्रिया',
      'village_label': 'गांव',
      'district_label': 'जिला',
      'outbreak_stage_label': 'प्रकोप चरण',
      'geo_risk_map': 'भू जोखिम मानचित्र',
      'risk_level_low': 'जोखिम स्तर: कम',
      'recent_reports': 'हाल की रिपोर्ट्स',
      'synced': 'सिंक्ड',
      'not_synced': 'नॉट सिंक्ड',
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
      // Signup additions
      'title_signup': 'आशा कार्यकर्ता साइनअप',
      'hint_asha_id': 'आशा  कार्यकर्ता ID',
      'hint_full_name': 'पूरा  नाम',
      'hint_confirm_password': 'पासवर्ड की पुष्टि करें',
      'label_country': 'देश',
      'label_state': 'राज्य',
      'label_district': 'जिला',
      'label_village': 'गांव',
      'back_to_login': 'लॉगिन पर वापस जाएं',
      'password_rules': '8 अक्षर: बड़े/छोटे अक्षर, अंक और विशेष चिन्ह होने चाहिए',
      'id_empty': 'कृपया अपना आशा ID दर्ज करें',
      'name_empty': 'कृपया अपना नाम दर्ज करें',
      'confirm_password_empty': 'कृपया पासवर्ड की पुष्टि करें',
      'password_mismatch': 'पासवर्ड मेल नहीं खाते',
      'select_village': 'कृपया गांव चुनें',
      'form_fix_errors': 'कृपया फॉर्म में त्रुटियाँ सुधारें',
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
