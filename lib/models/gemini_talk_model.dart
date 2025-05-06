// To parse this JSON data, do
//
//     final geminiTalkModel = geminiTalkModelFromJson(jsonString);

import 'dart:convert';

GeminiTalkModel geminiTalkModelFromJson(String str) => GeminiTalkModel.fromJson(json.decode(str));

String geminiTalkModelToJson(GeminiTalkModel data) => json.encode(data.toJson());

class GeminiTalkModel {
  List<Candidate> candidates;
  UsageMetadata usageMetadata;
  String modelVersion;

  GeminiTalkModel({
    required this.candidates,
    required this.usageMetadata,
    required this.modelVersion,
  });

  factory GeminiTalkModel.fromJson(Map<String, dynamic> json) => GeminiTalkModel(
    candidates: List<Candidate>.from(json["candidates"].map((x) => Candidate.fromJson(x))),
    usageMetadata: UsageMetadata.fromJson(json["usageMetadata"]),
    modelVersion: json["modelVersion"],
  );

  Map<String, dynamic> toJson() => {
    "candidates": List<dynamic>.from(candidates.map((x) => x.toJson())),
    "usageMetadata": usageMetadata.toJson(),
    "modelVersion": modelVersion,
  };
}

class Candidate {
  Content content;
  String finishReason;
  double avgLogprobs;

  Candidate({
    required this.content,
    required this.finishReason,
    required this.avgLogprobs,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) => Candidate(
    content: Content.fromJson(json["content"]),
    finishReason: json["finishReason"],
    avgLogprobs: json["avgLogprobs"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "content": content.toJson(),
    "finishReason": finishReason,
    "avgLogprobs": avgLogprobs,
  };
}

class Content {
  List<Part> parts;
  String role;

  Content({
    required this.parts,
    required this.role,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    parts: List<Part>.from(json["parts"].map((x) => Part.fromJson(x))),
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "parts": List<dynamic>.from(parts.map((x) => x.toJson())),
    "role": role,
  };
}

class Part {
  String text;

  Part({
    required this.text,
  });

  factory Part.fromJson(Map<String, dynamic> json) => Part(
    text: json["text"],
  );

  Map<String, dynamic> toJson() => {
    "text": text,
  };
}

class UsageMetadata {
  int promptTokenCount;
  int candidatesTokenCount;
  int totalTokenCount;
  List<TokensDetail> promptTokensDetails;
  List<TokensDetail> candidatesTokensDetails;

  UsageMetadata({
    required this.promptTokenCount,
    required this.candidatesTokenCount,
    required this.totalTokenCount,
    required this.promptTokensDetails,
    required this.candidatesTokensDetails,
  });

  factory UsageMetadata.fromJson(Map<String, dynamic> json) => UsageMetadata(
    promptTokenCount: json["promptTokenCount"],
    candidatesTokenCount: json["candidatesTokenCount"],
    totalTokenCount: json["totalTokenCount"],
    promptTokensDetails: List<TokensDetail>.from(json["promptTokensDetails"].map((x) => TokensDetail.fromJson(x))),
    candidatesTokensDetails: List<TokensDetail>.from(json["candidatesTokensDetails"].map((x) => TokensDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "promptTokenCount": promptTokenCount,
    "candidatesTokenCount": candidatesTokenCount,
    "totalTokenCount": totalTokenCount,
    "promptTokensDetails": List<dynamic>.from(promptTokensDetails.map((x) => x.toJson())),
    "candidatesTokensDetails": List<dynamic>.from(candidatesTokensDetails.map((x) => x.toJson())),
  };
}

class TokensDetail {
  String modality;
  int tokenCount;

  TokensDetail({
    required this.modality,
    required this.tokenCount,
  });

  factory TokensDetail.fromJson(Map<String, dynamic> json) => TokensDetail(
    modality: json["modality"],
    tokenCount: json["tokenCount"],
  );

  Map<String, dynamic> toJson() => {
    "modality": modality,
    "tokenCount": tokenCount,
  };
}
