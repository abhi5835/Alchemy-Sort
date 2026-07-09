import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/managers/game_manager.dart';
import 'ui/screens/splash_screen.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'core/managers/ad_manager.dart';
import 'core/managers/audio_manager.dart';
import 'core/managers/potion_collection_manager.dart';
import 'data/local/database/app_database.dart';
import 'data/local/migrations/legacy_preferences_migration.dart';
import 'game/analytics/game_analytics_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Database
  final database = AppDatabase();
  await LegacyPreferencesMigration.runMigration(database);

  // Initialize Managers
  await GameManager().init(database);
  await PotionCollectionManager().init(database);

  GameAnalyticsService().init(database);
  GameAnalyticsService().runDataRetentionCleanup();

  await AudioManager().init();
  AudioManager().playBgm('music/alchemy_theme.mp3');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      AudioManager().pauseBgm();
    } else if (state == AppLifecycleState.resumed) {
      AudioManager().resumeBgm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alchemy Sort',
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
