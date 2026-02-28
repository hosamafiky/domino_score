import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const List<Locale> supportedLocales = [Locale('ar'), Locale('en')];

  static const Locale defaultLocale = Locale('ar');

  bool get isRTL => locale.languageCode == 'ar';

  // Generic
  String get ok => _localizedValues[locale.languageCode]!['ok']!;
  String get cancel => _localizedValues[locale.languageCode]!['cancel']!;
  String get save => _localizedValues[locale.languageCode]!['save']!;
  String get loading => _localizedValues[locale.languageCode]!['loading']!;
  String get error => _localizedValues[locale.languageCode]!['error']!;
  String get retry => _localizedValues[locale.languageCode]!['retry']!;
  String get empty => _localizedValues[locale.languageCode]!['empty']!;

  // Tabs
  String get tabHome => _localizedValues[locale.languageCode]!['tabHome']!;
  String get tabSessions => _localizedValues[locale.languageCode]!['tabSessions']!;
  String get tabStats => _localizedValues[locale.languageCode]!['tabStats']!;
  String get tabSettings => _localizedValues[locale.languageCode]!['tabSettings']!;

  // Home
  String get homeTitle => _localizedValues[locale.languageCode]!['homeTitle']!;
  String get recentSessions => _localizedValues[locale.languageCode]!['recentSessions']!;
  String get newSession => _localizedValues[locale.languageCode]!['newSession']!;

  // Sessions
  String get sessionsTitle => _localizedValues[locale.languageCode]!['sessionsTitle']!;
  String get createSession => _localizedValues[locale.languageCode]!['createSession']!;
  String get sessionTitle => _localizedValues[locale.languageCode]!['sessionTitle']!;
  String get sessionDate => _localizedValues[locale.languageCode]!['sessionDate']!;
  String get matchType => _localizedValues[locale.languageCode]!['matchType']!;
  String get matchType1v1 => _localizedValues[locale.languageCode]!['matchType1v1']!;
  String get matchTypeTriple => _localizedValues[locale.languageCode]!['matchTypeTriple']!;
  String get matchType2v2 => _localizedValues[locale.languageCode]!['matchType2v2']!;
  String get addMatch => _localizedValues[locale.languageCode]!['addMatch']!;
  String get active => _localizedValues[locale.languageCode]!['active']!;
  String get ended => _localizedValues[locale.languageCode]!['ended']!;
  String get backToSession => _localizedValues[locale.languageCode]!['backToSession']!;
  String get nextMatch => _localizedValues[locale.languageCode]!['nextMatch']!;
  String get share => _localizedValues[locale.languageCode]!['share']!;
  String get congratulations => _localizedValues[locale.languageCode]!['congratulations']!;
  String get winner => _localizedValues[locale.languageCode]!['winner']!;

  // Match
  String get addRound => _localizedValues[locale.languageCode]!['addRound']!;
  String get pickWinner => _localizedValues[locale.languageCode]!['pickWinner']!;
  String get pickWinningTeam => _localizedValues[locale.languageCode]!['pickWinningTeam']!;
  String get points => _localizedValues[locale.languageCode]!['points']!;
  String get notes => _localizedValues[locale.languageCode]!['notes']!;
  String get undoLastRound => _localizedValues[locale.languageCode]!['undoLastRound']!;
  String get endMatch => _localizedValues[locale.languageCode]!['endMatch']!;
  String get quickPoints => _localizedValues[locale.languageCode]!['quickPoints']!;

  // Players & Teams
  String get players => _localizedValues[locale.languageCode]!['players']!;
  String get teams => _localizedValues[locale.languageCode]!['teams']!;
  String get playerName => _localizedValues[locale.languageCode]!['playerName']!;
  String get teamName => _localizedValues[locale.languageCode]!['teamName']!;
  String get selectPlayers => _localizedValues[locale.languageCode]!['selectPlayers']!;
  String get selectTeams => _localizedValues[locale.languageCode]!['selectTeams']!;

  // Stats
  String get statsTitle => _localizedValues[locale.languageCode]!['statsTitle']!;
  String get tabPlayers => _localizedValues[locale.languageCode]!['tabPlayers']!;
  String get tabTeamsStat => _localizedValues[locale.languageCode]!['tabTeamsStat']!;
  String get tabTrends => _localizedValues[locale.languageCode]!['tabTrends']!;
  String get winRate => _localizedValues[locale.languageCode]!['winRate']!;
  String get matchesPlayed => _localizedValues[locale.languageCode]!['matchesPlayed']!;
  String get sessionsParticipated => _localizedValues[locale.languageCode]!['sessionsParticipated']!;

  // Settings
  String get settingsTitle => _localizedValues[locale.languageCode]!['settingsTitle']!;
  String get targetScore => _localizedValues[locale.languageCode]!['targetScore']!;
  String get targetScore1v1 => _localizedValues[locale.languageCode]!['targetScore1v1']!;
  String get targetScoreTriple => _localizedValues[locale.languageCode]!['targetScoreTriple']!;
  String get targetScore2v2 => _localizedValues[locale.languageCode]!['targetScore2v2']!;
  String get notifications => _localizedValues[locale.languageCode]!['notifications']!;
  String get notificationsMatchEnd => _localizedValues[locale.languageCode]!['notificationsMatchEnd']!;
  String get notificationsSessionReminders => _localizedValues[locale.languageCode]!['notificationsSessionReminders']!;
  String get theme => _localizedValues[locale.languageCode]!['theme']!;
  String get language => _localizedValues[locale.languageCode]!['language']!;
  String get languageArabic => _localizedValues[locale.languageCode]!['languageArabic']!;
  String get languageEnglish => _localizedValues[locale.languageCode]!['languageEnglish']!;
  String get seedSampleData => _localizedValues[locale.languageCode]!['seedSampleData']!;
  String get seedSampleDataDone => _localizedValues[locale.languageCode]!['seedSampleDataDone']!;

  static const Map<String, Map<String, String>> _localizedValues = {
    'ar': {
      'ok': 'موافق',
      'cancel': 'إلغاء',
      'save': 'حفظ',
      'loading': 'جاري التحميل...',
      'error': 'خطأ',
      'retry': 'إعادة',
      'empty': 'لا توجد بيانات',
      'tabHome': 'الرئيسية',
      'tabSessions': 'الجلسات',
      'tabStats': 'الإحصائيات',
      'tabSettings': 'الإعدادات',
      'homeTitle': 'دومينو سكور',
      'recentSessions': 'الجلسات الأخيرة',
      'newSession': 'جلسة جديدة',
      'sessionsTitle': 'الجلسات',
      'createSession': 'إنشاء جلسة',
      'sessionTitle': 'عنوان الجلسة',
      'sessionDate': 'التاريخ',
      'matchType': 'نوع المباراة',
      'matchType1v1': '1 ضد 1',
      'matchTypeTriple': 'ثلاثي',
      'matchType2v2': '2 ضد 2',
      'addMatch': 'إضافة مباراة',
      'active': 'نشط',
      'ended': 'منتهي',
      'backToSession': 'العودة للجلسة',
      'nextMatch': 'مباراة تالية',
      'share': 'مشاركة',
      'congratulations': 'مبروك!',
      'winner': 'الفائز',
      'addRound': 'إضافة جولة',
      'pickWinner': 'اختر الفائز',
      'pickWinningTeam': 'اختر الفريق الفائز',
      'points': 'النقاط',
      'notes': 'ملاحظات',
      'undoLastRound': 'تراجع عن آخر جولة',
      'endMatch': 'إنهاء المباراة',
      'quickPoints': 'نقاط سريعة',
      'players': 'اللاعبون',
      'teams': 'الفرق',
      'playerName': 'اسم اللاعب',
      'teamName': 'اسم الفريق',
      'selectPlayers': 'اختر اللاعبين',
      'selectTeams': 'اختر الفرق',
      'statsTitle': 'الإحصائيات',
      'tabPlayers': 'اللاعبون',
      'tabTeamsStat': 'الفرق',
      'tabTrends': 'الاتجاهات',
      'winRate': 'نسبة الفوز',
      'matchesPlayed': 'مباريات لعبت',
      'sessionsParticipated': 'جلسات شاركت',
      'settingsTitle': 'الإعدادات',
      'targetScore': 'الهدف',
      'targetScore1v1': 'هدف 1 ضد 1',
      'targetScoreTriple': 'هدف الثلاثي',
      'targetScore2v2': 'هدف 2 ضد 2',
      'notifications': 'الإشعارات',
      'notificationsMatchEnd': 'إشعار نهاية المباراة',
      'notificationsSessionReminders': 'تذكير الجلسات',
      'theme': 'المظهر',
      'language': 'اللغة',
      'languageArabic': 'العربية',
      'languageEnglish': 'English',
      'seedSampleData': 'إضافة بيانات تجريبية',
      'seedSampleDataDone': 'تمت إضافة البيانات التجريبية',
    },
    'en': {
      'ok': 'OK',
      'cancel': 'Cancel',
      'save': 'Save',
      'loading': 'Loading...',
      'error': 'Error',
      'retry': 'Retry',
      'empty': 'No data',
      'tabHome': 'Home',
      'tabSessions': 'Sessions',
      'tabStats': 'Stats',
      'tabSettings': 'Settings',
      'homeTitle': 'Domino Score',
      'recentSessions': 'Recent Sessions',
      'newSession': 'New Session',
      'sessionsTitle': 'Sessions',
      'createSession': 'Create Session',
      'sessionTitle': 'Session Title',
      'sessionDate': 'Date',
      'matchType': 'Match Type',
      'matchType1v1': '1v1',
      'matchTypeTriple': 'Triple FFA',
      'matchType2v2': '2v2',
      'addMatch': 'Add Match',
      'active': 'Active',
      'ended': 'Ended',
      'backToSession': 'Back to Session',
      'nextMatch': 'Next Match',
      'share': 'Share',
      'congratulations': 'Congratulations!',
      'winner': 'Winner',
      'addRound': 'Add Round',
      'pickWinner': 'Pick Winner',
      'pickWinningTeam': 'Pick Winning Team',
      'points': 'Points',
      'notes': 'Notes',
      'undoLastRound': 'Undo Last Round',
      'endMatch': 'End Match',
      'quickPoints': 'Quick points',
      'players': 'Players',
      'teams': 'Teams',
      'playerName': 'Player Name',
      'teamName': 'Team Name',
      'selectPlayers': 'Select Players',
      'selectTeams': 'Select Teams',
      'statsTitle': 'Statistics',
      'tabPlayers': 'Players',
      'tabTeamsStat': 'Teams',
      'tabTrends': 'Trends',
      'winRate': 'Win Rate',
      'matchesPlayed': 'Matches Played',
      'sessionsParticipated': 'Sessions',
      'settingsTitle': 'Settings',
      'targetScore': 'Target Score',
      'targetScore1v1': '1v1 Target',
      'targetScoreTriple': 'Triple Target',
      'targetScore2v2': '2v2 Target',
      'notifications': 'Notifications',
      'notificationsMatchEnd': 'Match end notification',
      'notificationsSessionReminders': 'Session reminders',
      'theme': 'Theme',
      'language': 'Language',
      'languageArabic': 'العربية',
      'languageEnglish': 'English',
      'seedSampleData': 'Seed sample data',
      'seedSampleDataDone': 'Sample data seeded',
    },
  };
}
