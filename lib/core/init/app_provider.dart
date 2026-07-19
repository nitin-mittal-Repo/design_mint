


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive/hive.dart';
import '../../ui/utils/constant_string.dart';
import 'app_translation.dart';

late Box localStorage;

final hiveBoxProvider = Provider<Box>((ref) => Hive.box('appPrefs'));


// TODO :: Stores current language mode
final localeProvider = StateNotifierProvider<LocaleNotifier, String>((ref) {
  final box = ref.read(hiveBoxProvider);
  return LocaleNotifier(box);
});

class LocaleNotifier extends StateNotifier<String> {
  final Box box;

  LocaleNotifier(this.box) : super('en') {
    _loadLanguage();
  }

  void _loadLanguage() {
    final savedLang = box.get(ConstantString.languageValue, defaultValue: 'en');
    state = savedLang;
  }

  void changeLanguage(String code) {
    state = code;
    box.put(ConstantString.languageValue, code);
  }
}

extension TranslateX on WidgetRef {
  String tr(String key) {
    final lang = watch(localeProvider);
    return AppTranslations.translations[lang]?[key] ?? key;
  }
}