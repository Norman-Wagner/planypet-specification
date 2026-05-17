import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';

class ChatMessage {
  ChatMessage({required this.role, required this.content});
  final String role;
  final String content;

  Map<String, String> toJson() => {'role': role, 'content': content};
}

class DeepSeekService {
  Future<String> sendMessage(List<ChatMessage> history) async {
    final apiKey = dotenv.env['DEEPSEEK_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('DEEPSEEK_API_KEY fehlt in .env');
    }

    final messages = [
      {'role': 'system', 'content': AppConstants.deepSeekSystemPrompt},
      ...history.map((m) => m.toJson()),
    ];

    final response = await http.post(
      Uri.parse(AppConstants.deepSeekEndpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': AppConstants.deepSeekModel,
        'messages': messages,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('DeepSeek-Fehler ${response.statusCode}: ${response.body}');
    }

    final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final choices = data['choices'] as List;
    return choices.first['message']['content'] as String;
  }
}
