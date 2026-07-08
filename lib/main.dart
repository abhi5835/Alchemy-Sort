import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/managers/game_manager.dart';
import 'ui/screens/splash_screen.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'core/managers/ad_manager.dart';
import 'core/managers/audio_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await MobileAds.instance.initialize();
  // AdManager().loadInterstitialAd();
  await GameManager().init();

  await AudioManager().init();
  AudioManager().playBgm('music/alchemy_theme.mp3');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
