import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

import '../services/api_service.dart';

class PoemManager extends StateNotifier<String> {
  final ApiService _apiService;
  Timer? _debounce;
  String _lastText;

  PoemManager(this._apiService, [String state = ''])
      : _lastText = state,
        super(state);

  void updateRecommendation(String text, bool isModifyMode, bool forceSend) {
    /// Check if the only change is adding a space without altering words
    if (!forceSend && _isJustSpaceAdded(text)) {
      return; // Do nothing if the last change was just adding a space without changing words
    }

    /// prevent requests when the user breaks at the end of a line , also allows the user to stop the AI suggestions to minimize distractions.
    if (!forceSend && text.isNotEmpty && text.endsWith('\n')) return;

    _debounce?.cancel();

    /// on request rate limit for the free tier, more than limit but less than recommendation.
    /// https://docs.gemini.com/rest-api/#two-factor-authentication
    _debounce = Timer(const Duration(milliseconds: 750), () {
      _apiService.getAIRecommendation(text, isModifyMode).then((value) {
        state = value; // This updates the state of the provider
      });
    });
    _lastText = text; // Update lastText for future comparisons
  }

  bool _isJustSpaceAdded(String newText) {
    /// Split both texts into words
    List<String> newWords = newText.split(RegExp(r'\s+'));
    List<String> lastWords = _lastText.split(RegExp(r'\s+'));

    /// Remove spaces
    newWords = newWords.where((word) => word.isNotEmpty).toList();
    lastWords = lastWords.where((word) => word.isNotEmpty).toList();

    /// If the number of words didn't change and all words match, it means only spaces were added
    return newWords.length == lastWords.length &&
        const ListEquality().equals(newWords, lastWords);
  }

  void checkSelection(
      String text, int selectionStart, int selectionEnd, bool isModifyMode) {
    if (selectionStart == selectionEnd) return;
    String selectedText = text.substring(selectionStart, selectionEnd);
    if (selectedText.isNotEmpty) {
      updateRecommendation(selectedText, isModifyMode, true);
    }
  }
}
