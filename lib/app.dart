import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:somchi/core/constants/app_constants.dart';
import 'package:somchi/core/theme/app_colors.dart';
import 'package:somchi/core/theme/app_theme.dart';
import 'package:somchi/data/services/ad_service.dart';
import 'package:somchi/l10n/app_localizations.dart';
import 'package:somchi/presentation/providers/ad_free_provider.dart';
import 'package:somchi/presentation/providers/currency_provider.dart';
import 'package:somchi/presentation/providers/language_provider.dart';
import 'package:somchi/presentation/providers/theme_provider.dart';
import 'package:somchi/presentation/screens/home_screen.dart';
import 'package:somchi/presentation/screens/calculator_screen.dart';
import 'package:somchi/presentation/screens/settings_screen.dart';
import 'package:somchi/presentation/screens/splash_screen.dart';

class SomchiApp extends StatelessWidget {
  const SomchiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, _) {
        return MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          themeAnimationDuration: const Duration(milliseconds: 300),
          themeAnimationCurve: Curves.easeInOut,
          locale: languageProvider.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const _AppEntry(),
        );
      },
    );
  }
}

class _AppEntry extends StatefulWidget {
  const _AppEntry();

  @override
  State<_AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<_AppEntry> {
  bool _showSplash = true;

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return SplashScreen(
        onComplete: () {
          if (mounted) setState(() => _showSplash = false);
        },
      );
    }
    return const MainScreen();
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  int _currentIndex = 0;

  void switchToTab(int index) {
    setState(() => _currentIndex = index);
  }

  final _screens = const [
    HomeScreen(),
    CalculatorScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Birinchi ochilishda app open ad ko'rsatish (faqat 1 marta, ad-free bo'lmasa)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final adFree = context.read<AdFreeProvider>();
      if (!adFree.isAdFree) {
        AdService.instance.showAppOpenAdIfAvailable();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    if (!mounted) return;

    context.read<AdFreeProvider>().refresh();
    final provider = context.read<CurrencyProvider>();
    final lastUpdated = provider.lastUpdated;
    if (lastUpdated == null ||
        DateTime.now().difference(lastUpdated).inMinutes >= 5) {
      // Home screen o'zining refresh indikatorini ko'rsatadi,
      // boshqa tablarda foydalanuvchiga bildirish kerak
      if (_currentIndex != 0 && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).ratesRefreshing),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
      provider.refreshRates();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final dividerColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dividerDark
        : AppColors.dividerLight;
    final l10n = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: dividerColor,
            width: 1,
          ),
        ),
      ),
      child: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.currency_exchange_outlined),
            selectedIcon: const Icon(Icons.currency_exchange_rounded),
            label: l10n.navRates,
          ),
          NavigationDestination(
            icon: const Icon(Icons.calculate_outlined),
            selectedIcon: const Icon(Icons.calculate_rounded),
            label: l10n.navCalculator,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings_rounded),
            label: l10n.navSettings,
          ),
        ],
      ),
    );
  }
}
