import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curiosityclash/models/UserModel.dart';
import 'package:curiosityclash/models/ItemModel.dart';
import 'package:curiosityclash/models/QuestionModel.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // for the utf8.encode method


class ApiService{
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserModel> login(String username, String password) async {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);

    var querySnapshot = await _db.collection('users')
        .where('username', isEqualTo: username)
        .where('password', isEqualTo: digest.toString())
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var userDoc = querySnapshot.docs.first;
      var user = UserModel.fromDocument(userDoc);

      // List of questions to be added to the questions collection
      return user; // Return the user model
    } else {
      throw Exception('Login failed');
    }
  }

  Future<void> register(UserModel user) async {
    try {
      // Check if username or email already exists
      var usernameQuery = await _db.collection('users')
          .where('username', isEqualTo: user.username)
          .get();
      var emailQuery = await _db.collection('users')
          .where('email', isEqualTo: user.email)
          .get();

      if (usernameQuery.docs.isNotEmpty) {
        throw Exception('Username already exists');
      }

      if (emailQuery.docs.isNotEmpty) {
        throw Exception('Email already exists');
      }

      // Hash the password
      var bytes = utf8.encode(user.password); // data being hashed
      var digest = sha256.convert(bytes);

      await _db.collection('users').doc().set({
        'name': user.name,
        'username': user.username,
        'email': user.email,
        'password': digest.toString(), // store the hashed password
        'role': user.role,
        'level': user.level,
        'coins': user.coins, // set the initial coin amount to 0
        'armor': 100,
        'strike': 20,
        'damage': 50,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<UserModel> fetchUserById(String id) async {
    var userDoc = await _db.collection('users').doc(id).get();

    if (userDoc.exists) {
      return UserModel.fromDocument(userDoc); // Return the user model
    } else {
      throw Exception('User not found');
    }
  }

  Future<void> updateUserCoins(String id, int newCoins) async {
    try {
      await _db.collection('users').doc(id).update(
          {'coins': newCoins});
    } catch (e) {
      throw Exception('Failed to update coins: $e');
    }
  }

  Future<void> updateUserAttributes(String id, int newCoins, int newArmor, int newStrike, int newDamage) async {
    try {
      await _db.collection('users').doc(id).update({
        'coins': newCoins,
        'armor': newArmor,
        'strike': newStrike,
        'damage': newDamage,
      });
    } catch (e) {
      throw Exception('Failed to update attributes: $e');
    }
  }

  Future<List<QuestionModel>> fetchQuestions() async {
    var querySnapshot = await _db.collection('questions').get();
    return querySnapshot.docs.map((doc) => QuestionModel.fromDocument(doc)).toList();
  }

  Future<List<ItemModel>> fetchItemsByType(String type) async {
    var itemDocs = await _db.collection('items').where('type', isEqualTo: type).get();

    return itemDocs.docs.map((doc) => ItemModel.fromJson(doc.data())).toList();
  }

  Future<void> purchaseItem(String userId, ItemModel item) async {
    var userDoc = await _db.collection('users').doc(userId).get();
    var userCoins = userDoc['coins'];
    var userInventory = userDoc.data()!.containsKey('inventory')
        ? List<String>.from(userDoc['inventory'])
        : [];

    if (userCoins >= item.value) {
      userCoins -= item.value;
      userInventory.add(item.id);

      await _db.collection('users').doc(userId).update({
        'coins': userCoins,
        'inventory': userInventory,
      });
    } else {
      throw Exception('Not enough coins');
    }
  }

  Future<void> updateUser(String sessionId, UserModel user) async {
    try {
      await _db.collection('users').doc(sessionId).update(user.toJson());
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

}