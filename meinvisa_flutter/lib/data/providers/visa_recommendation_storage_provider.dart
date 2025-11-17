import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meinvisa/data/models/visa_recommendation_response_model/visa_recommendation_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for storing and retrieving the latest visa recommendation
final visaRecommendationStorageProvider =
    StateNotifierProvider<
      VisaRecommendationStorageNotifier,
      AsyncValue<VisaRecommendationResponse?>
    >((ref) {
      return VisaRecommendationStorageNotifier();
    });

class VisaRecommendationStorageNotifier
    extends StateNotifier<AsyncValue<VisaRecommendationResponse?>> {
  static const String _storageKey = 'latest_visa_recommendation';
  static const String _timestampKey = 'visa_recommendation_timestamp';

  VisaRecommendationStorageNotifier() : super(const AsyncValue.loading()) {
    _loadRecommendation();
  }

  /// Load stored recommendation on initialization
  Future<void> _loadRecommendation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);

      if (jsonString != null) {
        final data = jsonDecode(jsonString) as Map<String, dynamic>;
        final recommendation = VisaRecommendationResponse.fromJson(data);
        state = AsyncValue.data(recommendation);
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Save a new recommendation
  Future<void> saveRecommendation(
    VisaRecommendationResponse recommendation,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(recommendation.toJson());

      await prefs.setString(_storageKey, jsonString);
      await prefs.setInt(_timestampKey, DateTime.now().millisecondsSinceEpoch);

      state = AsyncValue.data(recommendation);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Clear stored recommendation
  Future<void> clearRecommendation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
      await prefs.remove(_timestampKey);

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Get the timestamp of when the recommendation was saved
  Future<DateTime?> getRecommendationTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_timestampKey);

    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : null;
  }

  /// Check if recommendation exists
  bool hasRecommendation() {
    return state.value != null;
  }
}
