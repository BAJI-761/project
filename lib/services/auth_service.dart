import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  User? _user;
  String? _name;
  String? _address;
  String? _userType;

  User? get user => _user;
  String? get name => _name;
  String? get address => _address;
  String? get userType => _userType;
  bool get isAuthenticated => _user != null;

  AuthService() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      if (user != null) {
        _loadUserData();
      } else {
        _clearUserData();
      }
      notifyListeners();
    });
  }

  Future<void> _loadUserData() async {
    if (_user != null) {
      try {
        debugPrint('Loading user data for UID: ${_user!.uid}');
        final doc = await _firestore.collection('users').doc(_user!.uid).get();
        if (doc.exists) {
          final data = doc.data()!;
          _name = data['name'];
          _address = data['address'];
          _userType = data['userType'];
          debugPrint('User data loaded: name=$_name, type=$_userType, address=$_address');
          notifyListeners();
        } else {
          debugPrint('User document does not exist in Firestore');
          // If user document doesn't exist, we might need to create it
          // This could happen if registration failed partially
          _clearUserData();
          notifyListeners();
        }
      } catch (e) {
        // Log error for debugging but don't throw
        // In production, you might want to use a proper logging service
        debugPrint('Error loading user data: $e');
        _clearUserData();
        notifyListeners();
      }
    }
  }

  void _clearUserData() {
    _name = null;
    _address = null;
    _userType = null;
  }

  Future<void> register(String name, String address, String userType, String email, String password) async {
    try {
      email = email.trim();
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'address': address,
        'userType': userType,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _name = name;
      _address = address;
      _userType = userType;
      notifyListeners();
    } catch (e) {
      debugPrint('Error registering: $e');
      // Provide more specific error messages
      if (e.toString().contains('email-already-in-use')) {
        throw Exception('An account with this email already exists.');
      } else if (e.toString().contains('weak-password')) {
        throw Exception('Password is too weak. Please use a stronger password.');
      } else if (e.toString().contains('invalid-email')) {
        throw Exception('Please enter a valid email address.');
      } else {
        throw Exception('Registration failed. Please try again.');
      }
    }
  }

  Future<void> login(String email, String password) async {
    try {
      email = email.trim();
      debugPrint('Attempting login for email: $email');
      
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      debugPrint('Login successful for user: ${userCredential.user?.uid}');
      
      // The auth state listener should automatically trigger _loadUserData
      // But let's ensure user data is loaded
      if (userCredential.user != null) {
        await _loadUserData();
      }
      
    } catch (e) {
      debugPrint('Error logging in: $e');
      // Provide more specific error messages
      if (e.toString().contains('user-not-found')) {
        throw Exception('No account found with this email address.');
      } else if (e.toString().contains('wrong-password')) {
        throw Exception('Incorrect password. Please try again.');
      } else if (e.toString().contains('invalid-email')) {
        throw Exception('Please enter a valid email address.');
      } else if (e.toString().contains('too-many-requests')) {
        throw Exception('Too many failed attempts. Please try again later.');
      } else if (e.toString().contains('network-request-failed')) {
        throw Exception('Network error. Please check your internet connection.');
      } else {
        throw Exception('Login failed. Please check your credentials and try again.');
      }
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint('Error logging out: $e');
      // Don't throw on logout errors as they're usually not critical
    }
  }
}
