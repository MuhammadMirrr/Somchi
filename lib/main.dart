import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'data/services/ad_service.dart';
import 'data/services/cbu_api_service.dart';
import 'data/services/cache_service.dart';
import 'data/repositories/currency_repository.dart';
import 'presentation/providers/currency_provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/providers/language_provider.dart';
import 'presentation/providers/ad_free_provider.dart';
import 'presentation/providers/calculator_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  final prefs = await SharedPreferences.getInstance();
  await AdService.instance.init(prefs);

  final apiService = CbuApiService();
  final cacheService = CacheService(prefs);
  final repository = CurrencyRepository(
    apiService: apiService,
    cacheService: cacheService,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CurrencyProvider(repository)..init(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(
            repository,
            initialThemeMode: repository.getThemeMode(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => LanguageProvider(
            repository,
            initialLanguageIndex: repository.getLanguageIndex(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => CalculatorProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AdFreeProvider(prefs),
        ),
      ],
      child: const SomchiApp(),
    ),
  );
}
