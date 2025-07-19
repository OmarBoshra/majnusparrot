import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:majnusparrot/managers/poem_style_manager.dart';

import 'package:majnusparrot/services/network_service.dart';

import '../managers/poem_manager.dart';
import '../services/api_service.dart';

final poemTextProvider = StateProvider<String>((ref) => "");
final recommendationProvider =
    StateProvider<String>((ref) => "Majnu's parrot can sometimes fly...");

final isModifyModeProvider = StateProvider<bool>((ref) => false);
final poemContextProvider = StateProvider<String>((ref) => "");

/// Local provision
final apiServiceProvider =
    Provider<ApiService>((ref) => ApiService(setupDio()));

final poemManagerProvider = StateNotifierProvider<PoemManager, String>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return PoemManager(apiService);
});

// 2. Create a StateNotifierProvider
final colorSchemeProvider =
    StateNotifierProvider<PoemStyleManager, MyColorScheme>((ref) {
  return PoemStyleManager(ref);
});
