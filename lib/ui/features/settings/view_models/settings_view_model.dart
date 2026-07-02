import 'package:flutter/foundation.dart';

/// Presentation state for the settings screen (toggle switches + theme mode).
class SettingsViewModel extends ChangeNotifier {
  final String userName = 'Ana Silva';
  final String userEmail = 'ana.silva@email.com';
  final String plan = 'Plano Pro';

  bool pushNotifications = true;
  bool emailReports = true;
  bool marketingEmails = false;
  bool darkMode = false;
  bool compactMode = false;
  bool twoFactor = true;

  final List<String> languages = const <String>['Português', 'English', 'Español'];
  int _languageIndex = 0;
  String get language => languages[_languageIndex];

  void togglePush(bool value) {
    pushNotifications = value;
    notifyListeners();
  }

  void toggleEmailReports(bool value) {
    emailReports = value;
    notifyListeners();
  }

  void toggleMarketing(bool value) {
    marketingEmails = value;
    notifyListeners();
  }

  void toggleDarkMode(bool value) {
    darkMode = value;
    notifyListeners();
  }

  void toggleCompact(bool value) {
    compactMode = value;
    notifyListeners();
  }

  void toggleTwoFactor(bool value) {
    twoFactor = value;
    notifyListeners();
  }

  void cycleLanguage() {
    _languageIndex = (_languageIndex + 1) % languages.length;
    notifyListeners();
  }
}
