import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/app_user.dart'; 

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  /// LOGIN METHOD
  Future<Map<String, dynamic>?> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        final userData = await getUserData(user.uid);
        return userData;
      }
      return null;
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  /// SIGNUP METHOD
  Future<User?> signUp({
    required String email,
    required String password,
    required String fullName,
    required String role,
    String? schoolName,
    String? schoolId,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user != null) {
        await user.updateDisplayName(fullName);

        await _db.collection('users').doc(user.uid).set({
          'name': fullName,
          'email': email,
          'role': role,
          'schoolName': schoolName ?? '',
          'schoolId': schoolId ?? '',
        });

        return user;
      }

      return null;
    } catch (e) {
      throw Exception("Sign up failed: $e");
    }
  }

  /// LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// GET USER DATA
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) return doc.data();
      return null;
    } catch (e) {
      throw Exception("Failed to fetch user data: $e");
    }
  }

  /// GET USER ROLE
  Future<String?> getUserRole(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists && doc.data()!.containsKey('role')) {
        return doc['role'] as String?;
      }
      return null;
    } catch (e) {
      throw Exception("Failed to fetch user role: $e");
    }
  }

  /// PASSWORD RESET
  Future<void> sendPasswordResetEmail({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  /// SAFELY RETURNING EMPTY LISTS FOR NOW
  Future<List<AppUser>> getUsersBySchoolAndRoles(String schoolId, List<String> roles) async {
    // TODO: implement Firestore query
    return [];
  }

  Future<List<AppUser>> getUsersByRole(String role) async {
    // TODO: implement Firestore query
    return [];
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
