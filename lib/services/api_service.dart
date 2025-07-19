import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:majnusparrot/constants/strings.dart';

const String geminiApiKey = AppStrings.apiKey;
const String geminiApiUrl =
    'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$geminiApiKey';

class ApiService {
  final Dio dio;

  ApiService(this.dio);

  Future<String> getAIRecommendation(
      String userInput, bool isModifyMode) async {
    List<Map<String, dynamic>> partsList = [
      {
        "text": isModifyMode
            ? "return only the best recommended poetry modification ,don't add any extra preamble, explanation nor commentary"
            : "return only the best recommended next poetic verses ,don't add any extra preamble, explanation nor commentary"
      }
    ];
    partsList.addAll(userInput
        .split('\n')
        .where((line) => line.isNotEmpty)
        .map((part) => {"text": part})
        .toList());

    try {
      final body = json.encode({
        "contents": [
          {"parts": partsList}
        ]
      });

      final response = await dio.post(
        geminiApiUrl,
        options: Options(
          headers: {'Content-Type': 'application/json'},
          sendTimeout: const Duration(milliseconds: 10000),
          receiveTimeout: const Duration(milliseconds: 15000),
        ),
        data: body,
      );

      if (response.statusCode == 200) {
        final recommendation = response.data['candidates'][0]['content']
            ['parts'][0]['text'] as String?;
        return recommendation ?? 'No recommendations available';
      } else {
        throw Exception(
            'Failed to fetch recommendation: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      return 'Failed to fetch recommendations';
    }
  }
}
