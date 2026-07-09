import 'package:flutter/material.dart';
import 'level_map_screen.dart';
import 'daily_alchemy_screen.dart';
import 'potion_book_screen.dart';
import 'profile_screen.dart';
import '../widgets/alchemy_bottom_navigation.dart';
import '../../core/managers/audio_manager.dart';

class MainScreen extends StatefulWidget {
  final int initialTabIndex;

  const MainScreen({super.key, this.initialTabIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  // We want to preserve the scroll state of the Map screen.
  // Using an IndexedStack would keep ALL tabs alive in memory and fully built.
  // Instead, we will selectively keep ONLY the Map screen alive by wrapping it in an Offstage,
  // or we can just use a PageStorageKey / AutomaticKeepAliveClientMixin if appropriate.
  // The user requested: "Do NOT create a permanently heavy IndexedStack that blindly keeps every tab alive forever."
  // And "Preserve map ScrollController state while navigating... Use existing screens".

  // So we will use a lightweight approach: The Map screen has its own ScrollController
  // which can be tied to a PageStorageKey, or we can just keep the LevelMapScreen instance cached.
  late final Widget _mapScreen;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTabIndex;
    _mapScreen = const LevelMapScreen(key: PageStorageKey('map_screen'));

    // Start background music once the main menu is reached
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AudioManager().playBgm('music/alchemy_theme.mp3');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildCurrentTab(),
      bottomNavigationBar: AlchemyBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildCurrentTab() {
    switch (_currentIndex) {
      case 0:
        return _mapScreen; // Map is cached/preserved
      case 1:
        return const DailyAlchemyScreen(embedded: true); // Re-built on demand
      case 2:
        return const PotionBookScreen(embedded: true); // Re-built on demand
      case 3:
        return const ProfileScreen(embedded: true); // Re-built on demand
      default:
        return _mapScreen;
    }
  }
}
