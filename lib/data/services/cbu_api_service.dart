import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/currency.dart';
import '../models/rate_history.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/exceptions.dart';

class CbuApiService {
  final http.Client _client;
  static const _timeout = Duration(seconds: 15);
  static const _maxRetries = 2; // jami 3 urinish

  CbuApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Tarmoq xatosida exponential backoff bilan qayta urinish
  Future<http.Response> _getWithRetry(Uri uri) async {
    var attempt = 0;
    while (true) {
      try {
        return await _client.get(uri).timeout(_timeout);
      } on TimeoutException catch (_) {
        if (attempt >= _maxRetries) rethrow;
      } on SocketException catch (_) {
        if (attempt >= _maxRetries) rethrow;
      } on http.ClientException catch (_) {
        if (attempt >= _maxRetries) rethrow;
      }
      attempt++;
      // 500ms, 1000ms — exponential backoff
      await Future.delayed(Duration(milliseconds: 500 * (1 << (attempt - 1))));
    }
  }

  /// Bugungi barcha valyutalar kursini olish
  Future<List<Currency>> fetchTodayRates() async {
    try {
      final response = await _getWithRetry(
        Uri.parse('${AppConstants.cbuBaseUrl}/'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is! List) throw ApiException('Noto\'g\'ri javob formati');
        return data
            .whereType<Map<String, dynamic>>()
            .map((json) => Currency.fromJson(json))
            .toList();
      } else {
        throw ApiException('Server xatosi (${response.statusCode})');
      }
    } on NetworkException {
      rethrow;
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw NetworkException('So\'rov vaqti tugadi');
    } on SocketException {
      throw NetworkException("Internet aloqasi yo'q");
    } on http.ClientException {
      throw NetworkException("Internet aloqasi yo'q");
    } on FormatException {
      throw ApiException('Noto\'g\'ri javob formati');
    } catch (e) {
      debugPrint('fetchTodayRates unknown error: $e');
      throw ApiException('Kutilmagan xato');
    }
  }

  /// Ma'lum sanadagi kurslarni olish
  Future<List<Currency>> fetchRatesByDate(DateTime date) async {
    try {
      final dateStr =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final response = await _getWithRetry(
        Uri.parse('${AppConstants.cbuBaseUrl}/all/$dateStr/'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is! List) throw ApiException('Noto\'g\'ri javob formati');
        return data
            .whereType<Map<String, dynamic>>()
            .map((json) => Currency.fromJson(json))
            .toList();
      } else {
        throw ApiException('Server xatosi (${response.statusCode})');
      }
    } on NetworkException {
      rethrow;
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw NetworkException('So\'rov vaqti tugadi');
    } on SocketException {
      throw NetworkException("Internet aloqasi yo'q");
    } on http.ClientException {
      throw NetworkException("Internet aloqasi yo'q");
    } on FormatException {
      throw ApiException('Noto\'g\'ri javob formati');
    } catch (e) {
      debugPrint('fetchRatesByDate unknown error: $e');
      throw ApiException('Kutilmagan xato');
    }
  }

  /// Ma'lum valyutaning tarixiy kurslarini olish
  Future<List<RateHistory>> fetchCurrencyHistory({
    required String currencyCode,
    required int days,
  }) async {
    final now = DateTime.now();

    // Uzoq davrlar uchun oraliqni oshiramiz (365 kun = ~73 so'rov)
    final int step = days > 90 ? 5 : (days > 30 ? 2 : 1);
    final dates = <DateTime>[];
    for (int i = 0; i < days; i += step) {
      dates.add(now.subtract(Duration(days: i)));
    }

    // Batch bilan yuboramiz (bir vaqtda max 20 so'rov)
    const batchSize = 20;
    final history = <RateHistory>[];
    int failedCount = 0;

    for (int batchStart = 0; batchStart < dates.length; batchStart += batchSize) {
      final batchEnd = (batchStart + batchSize).clamp(0, dates.length);
      final batch = dates.sublist(batchStart, batchEnd);

      final futures = batch.map((date) {
        final dateStr =
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        return _client
            .get(
              Uri.parse('${AppConstants.cbuBaseUrl}/$currencyCode/$dateStr/'),
            )
            .timeout(_timeout)
            .then<http.Response?>((r) => r)
            .catchError((_) => null as http.Response?);
      }).toList();

      final responses = await Future.wait(futures, eagerError: false);

      for (int i = 0; i < responses.length; i++) {
        try {
          final response = responses[i];
          if (response == null) {
            failedCount++;
            continue;
          }
          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            if (data is List && data.isNotEmpty) {
              final currency =
                  Currency.fromJson(data.first as Map<String, dynamic>);
              history.add(RateHistory(
                date: batch[i],
                rate: currency.rate,
                nominal: currency.nominal,
              ));
            }
          } else {
            failedCount++;
            debugPrint(
                'Tarix so\'rovi xatolik: ${batch[i]} — status ${response.statusCode}');
          }
        } catch (e) {
          failedCount++;
          debugPrint('Tarix parse xatoligi (${batch[i]}): $e');
        }
      }
    }

    if (failedCount > 0) {
      debugPrint(
          'Tarix: $currencyCode/$days — ${dates.length} so\'rovdan $failedCount tasi muvaffaqiyatsiz');
    }

    history.sort((a, b) => a.date.compareTo(b.date));
    return history;
  }
}
