// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader {
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String, dynamic> en_US = {
    "homePageTitle": "Home",
    "searchPageTitle": "Search",
    "startTypingToSearch": "Start typing to search",
    "searchResultsAppearHere": "Search results appear here...",
    "noResultsFound": "No results found...",
    "dynamicTheme": "Dynamic Theme",
    "emotion": {
      "input_label": "What's on your mind?",
      "input_hint": "Enter text to analyze sentiment...",
      "analyze_button": "Analyze Sentiment",
      "confidence_label": "Confidence Score",
      "analyzed_text_label": "Analyzed Text",
      "datetime_format": "MMM dd, yyyy - hh:mm a",
      "history_title": "Analysis History",
      "history_empty": "No analysis history yet",
      "clear_history_tooltip": "Clear all history",
      "clear_button": "Clear",
      "cancel_button": "Cancel",
      "confirm_clear_title": "Clear History?",
      "confirm_clear_message": "This will delete all your sentiment analysis history. This action cannot be undone."
    }
  };
  static const Map<String, dynamic> hi_IN = {
    "homePageTitle": "मुख्य पृष्ठ",
    "searchPageTitle": "खोज",
    "startTypingToSearch": "खोजने के लिए टाइप करना प्रारंभ करें",
    "searchResultsAppearHere": "खोज परिणाम यहां दिखाई देते हैं...",
    "noResultsFound": "कोई परिणाम नहीं मिला...",
    "dynamicTheme": "डायनामिक थीम",
    "emotion": {
      "input_label": "आपके मन में क्या है?",
      "input_hint": "भावना विश्लेषण के लिए पाठ दर्ज करें...",
      "analyze_button": "भावना विश्लेषण करें",
      "confidence_label": "विश्वास स्कोर",
      "analyzed_text_label": "विश्लेषण किया गया पाठ",
      "datetime_format": "dd MMM, yyyy - hh:mm a",
      "history_title": "विश्लेषण इतिहास",
      "history_empty": "अभी कोई विश्लेषण इतिहास नहीं",
      "clear_history_tooltip": "सभी इतिहास साफ करें",
      "clear_button": "साफ करें",
      "cancel_button": "रद्द करें",
      "confirm_clear_title": "इतिहास साफ करें?",
      "confirm_clear_message": "यह आपके सभी भावना विश्लेषण इतिहास को हटा देगा। यह क्रिया पूर्ववत नहीं की जा सकती।"
    }
  };
  static const Map<String, dynamic> ar_SA = {
    "homePageTitle": "الصفحة الرئيسية",
    "searchPageTitle": "بحث",
    "startTypingToSearch": "ابدأ الكتابة للبحث",
    "searchResultsAppearHere": "ظهور نتائج البحث هنا...",
    "noResultsFound": "لم يتم العثور على نتائج...",
    "dynamicTheme": "المظهر الديناميكي",
    "emotion": {
      "input_label": "ما الذي يشغل بالك؟",
      "input_hint": "أدخل النص لتحليل المشاعر...",
      "analyze_button": "تحليل المشاعر",
      "confidence_label": "درجة الثقة",
      "analyzed_text_label": "النص المحلل",
      "datetime_format": "dd MMM، yyyy - hh:mm a",
      "history_title": "سجل التحليل",
      "history_empty": "لا يوجد سجل تحليل حتى الآن",
      "clear_history_tooltip": "حذف كل السجل",
      "clear_button": "حذف",
      "cancel_button": "إلغاء",
      "confirm_clear_title": "حذف السجل؟",
      "confirm_clear_message": "سيؤدي هذا إلى حذف جميع سجل تحليل المشاعر. لا يمكن التراجع عن هذا الإجراء."
    }
  };
  static const Map<String, Map<String, dynamic>> mapLocales = {
    "en_US": en_US,
    "hi_IN": hi_IN,
    "ar_SA": ar_SA
  };
}
