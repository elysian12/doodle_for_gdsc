import 'dart:developer';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uuid/uuid.dart';

class GptService {
  late OpenAI _openAI;

  static GptService? _instance;

  GptService._internal() {
    _openAI = OpenAI.instance.build(
      token: dotenv.env['OPENAI_API_KEY'],
      baseOption: HttpSetup(
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    _handleInitialMessage('You are a Svg Coding assistant');
  }

  Future<void> _handleInitialMessage(String character) async {
    final request = ChatCompleteText(
      messages: [
        Messages(role: Role.assistant, content: character),
      ],
      maxToken: 200,
      model: GptTurboChatModel(),
    );

    final response = await _openAI.onChatCompletion(request: request);
    print(response!.choices.map((e) => e.toJson()).toList());
  }

  Future<ChatCTResponse?> userPrompt(String character) async {
    final request = ChatCompleteText(
      messages: [
        Messages(role: Role.user, content: character),
      ],
      maxToken: 500,
      model: GptTurboChatModel(),
      user: const Uuid().v1(),
    );

    final response = await _openAI.onChatCompletion(request: request);
    log(response!.choices.map((e) => e.toJson()).toList().toString());

    return response;
  }

  static GptService get instance {
    _instance ??= GptService._internal();
    return _instance!;
  }
}
