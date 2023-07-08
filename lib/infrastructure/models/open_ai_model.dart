import 'dart:convert';

import 'package:yes_no_app/domain/entities/message.dart';

OpenAiModel openAiModelFromJson(String str) =>
    OpenAiModel.fromJson(json.decode(str));

String openAiModelToJson(OpenAiModel data) => json.encode(data.toJson());

class OpenAiModel {
  final String id;
  final String object;
  final int created;
  final String model;
  final List<Choice> choices;
  final Usage usage;
  final String image;

  OpenAiModel({
    required this.id,
    required this.object,
    required this.created,
    required this.model,
    required this.choices,
    required this.usage,
    this.image = '',
  });

  factory OpenAiModel.fromJson(Map<String, dynamic> json) => OpenAiModel(
        id: json["id"],
        object: json["object"],
        created: json["created"],
        model: json["model"],
        choices:
            List<Choice>.from(json["choices"].map((x) => Choice.fromJson(x))),
        usage: Usage.fromJson(json["usage"]),
        image: json["image"]
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "object": object,
        "created": created,
        "model": model,
        "choices": List<dynamic>.from(choices.map((x) => x.toJson())),
        "usage": usage.toJson(),
      };
  
  Message toMessageEntity() => Message(
      text: choices[0].message.content, fromWho: FromWho.hers, opcional: image);
}

class Choice {
  final int index;
  final MessageAnswer message;
  final String finishReason;

  Choice({
    required this.index,
    required this.message,
    required this.finishReason,
  });

  factory Choice.fromJson(Map<String, dynamic> json) => Choice(
        index: json["index"],
        message: MessageAnswer.fromJson(json["message"]),
        finishReason: json["finish_reason"],
      );

  Map<String, dynamic> toJson() => {
        "index": index,
        "message": message.toJson(),
        "finish_reason": finishReason,
      };
}

class MessageAnswer {
  final String role;
  final String content;

  MessageAnswer({
    required this.role,
    required this.content,
  });

  factory MessageAnswer.fromJson(Map<String, dynamic> json) => MessageAnswer(
        role: json["role"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "role": role,
        "content": content,
      };
}

class Usage {
  final int promptTokens;
  final int completionTokens;
  final int totalTokens;

  Usage({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
  });

  factory Usage.fromJson(Map<String, dynamic> json) => Usage(
        promptTokens: json["prompt_tokens"],
        completionTokens: json["completion_tokens"],
        totalTokens: json["total_tokens"],
      );

  Map<String, dynamic> toJson() => {
        "prompt_tokens": promptTokens,
        "completion_tokens": completionTokens,
        "total_tokens": totalTokens,
      };
}
