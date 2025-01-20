import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionModel {
  String id;
  String text;
  List<String> options;
  String correctAnswer;
  int points;
  String explanation;

  QuestionModel({
    required this.id,
    required this.text,
    required this.options,
    required this.correctAnswer,
    required this.points,
    required this.explanation,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      text: json['text'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correctAnswer'],
      points: json['points'],
      explanation: json['explanation'] ?? 'No explanation provided.',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'options': options,
    'correctAnswer': correctAnswer,
    'points': points,
    'explanation': explanation,
  };

  factory QuestionModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return QuestionModel(
      id: doc.id,
      text: data['text'],
      options: List<String>.from(data['options']),
      correctAnswer: data['correctAnswer'],
      points: data['points'],
      explanation: data['explanation'] ?? 'No explanation provided.',
    );
  }
}