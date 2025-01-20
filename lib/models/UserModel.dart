import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String name;
  String username;
  String email;
  String password;
  String role;
  String level;
  int coins;
  int armor;
  int damage;
  int strike;
  List<String> inventory;

  UserModel({
    this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    this.role = 'user',
    this.level = '1',
    this.coins = 0,
    this.armor = 0,
    this.damage = 0,
    this.strike = 0,
    this.inventory = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      role: json['role'] ?? 'user',
      level: json['level'] ?? '1',
      coins: json['coins'] ?? 0,
      armor: json['armor'] ?? 0,
      damage: json['damage'] ?? 0,
      strike: json['strike'] ?? 0,
      inventory: List<String>.from(json['inventory'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'username': username,
    'email': email,
    'password': password,
    'role': role,
    'level': level,
    'coins': coins,
    'armor': armor,
    'damage': damage,
    'strike': strike,
    'inventory': inventory,
  };

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'],
      username: data['username'],
      email: data['email'],
      password: data['password'],
      role: data['role'] ?? 'user',
      level: data['level'] ?? '1',
      coins: data['coins'] ?? 0,
      armor: data['armor'] ?? 0,
      damage: data['damage'] ?? 0,
      strike: data['strike'] ?? 0,
      inventory: List<String>.from(data['inventory'] ?? []),
    );
  }
}