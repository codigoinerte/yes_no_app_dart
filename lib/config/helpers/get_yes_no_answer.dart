import 'dart:convert';
import 'dart:io';

import 'package:yes_no_app/domain/entities/message.dart';
import 'package:dio/dio.dart';
import 'package:yes_no_app/infrastructure/models/open_ai_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GetYesNoAnswer {
  final _dio = Dio();

  Future<Message> getAnswer(String message) async {

    //yes no 
    await dotenv.load(fileName: ".env");

    final apiKey = dotenv.env['API_KEY'];
    
    final responseYesNo = await _dio.get('https://yesno.wtf/api');

    // open ai

    final params = {
      "model": "gpt-3.5-turbo",
      "messages": [
        {"role": "user", "content": message}
      ],
      "temperature": 0.7
    };

    final response = await _dio.post(
      'https://api.openai.com/v1/chat/completions',
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $apiKey"
      }),
      data: jsonEncode(params),
    );

    final yesNoModel = OpenAiModel.fromJson({...response.data, ...responseYesNo.data});

    return yesNoModel.toMessageEntity();
  }
}
