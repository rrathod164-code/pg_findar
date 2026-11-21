import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  FirebaseService._();

  /// Initializes the Firebase connection.
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
      if (kDebugMode) {
        print('Firebase successfully initialized.');
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Failed to initialize Firebase: $e');
        print(stackTrace);
      }
      rethrow;
    }
  }

  /// Default Firebase App instance
  static FirebaseApp get app => Firebase.app();

  /// Firebase Authentication instance
  static FirebaseAuth get auth => FirebaseAuth.instance;

  /// Cloud Firestore instance
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;
}
