import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart';
import 'dart:io';

/// Firebase Service Class
/// Handles all Firebase operations including Authentication, Firestore, and Storage
class FirebaseService {
  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    // Use the Web Client ID from google-services.json
    serverClientId: '134716946611-1juo5e9ppbgtn7drggu73dvmem9t6hq1.apps.googleusercontent.com',
  );

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Get auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// ========== AUTHENTICATION ==========

  /// Sign up with email and password
  /// Returns the User object if successful, throws exception otherwise
  Future<User?> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Create user with email and password
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await userCredential.user?.updateDisplayName(name);

      // Create user document in Firestore (non-blocking)
      if (userCredential.user != null) {
        try {
          await createUserDocument(
            userId: userCredential.user!.uid,
            email: email,
            name: name,
          );
        } catch (e) {
          // Log error but don't block sign-up
          print('Warning: Could not create user document: $e');
          print('User can still use the app. Create Firestore Database in Firebase Console.');
        }
      }

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  /// Sign in with email and password
  /// Returns the User object if successful, throws exception otherwise
  Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  /// Sign in with Google
  /// Returns the User object if successful, throws exception otherwise
  Future<User?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google sign in was cancelled');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Create user document if it's a new user (non-blocking)
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        try {
          await createUserDocument(
            userId: userCredential.user!.uid,
            email: userCredential.user!.email ?? '',
            name: userCredential.user!.displayName ?? 'User',
          );
        } catch (e) {
          // Log error but don't block sign-in
          print('Warning: Could not create user document: $e');
          print('User can still use the app. Create Firestore Database in Firebase Console.');
        }
      }

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } on PlatformException catch (e) {
      if (e.code == 'sign_in_failed') {
        throw Exception('Google Sign-in not configured. Please add SHA-1 fingerprint to Firebase Console or use Email/Password sign-up instead.');
      }
      throw Exception('Google sign-in error: ${e.message}');
    } catch (e) {
      // Only throw if it's a real error, not a successful return
      print('Google Sign-in exception: $e');
      if (e.toString().contains('cancelled')) {
        throw Exception('Google sign in was cancelled');
      }
      // If we have a user, return it even if there was a minor error
      if (_auth.currentUser != null) {
        return _auth.currentUser;
      }
      throw Exception('Google sign-in failed: $e');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  /// Reset password
  Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Failed to reset password: $e');
    }
  }

  /// Handle Firebase Auth exceptions and return user-friendly messages
  String _handleAuthException(FirebaseAuthException e) {
    // Log the error for debugging
    print('Firebase Auth Error Code: ${e.code}');
    print('Firebase Auth Error Message: ${e.message}');
    
    switch (e.code) {
      case 'weak-password':
        return 'The password is too weak. Please use at least 6 characters.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'Email/Password sign-in is not enabled. Please enable it in Firebase Console:\n1. Go to Authentication\n2. Sign-in method\n3. Enable Email/Password';
      case 'configuration-not-found':
      case 'internal-error':
        return 'Firebase is not properly configured. Please enable Email/Password authentication in Firebase Console.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'invalid-credential':
        return 'Invalid credentials. Please check your email and password.';
      default:
        // Check if message contains configuration error
        if (e.message?.contains('CONFIGURATION_NOT_FOUND') ?? false) {
          return 'Authentication not enabled. Please enable Email/Password sign-in in Firebase Console.';
        }
        return 'Authentication failed: ${e.message ?? "Unknown error"}';
    }
  }

  /// ========== FIRESTORE OPERATIONS ==========

  /// Create user document in Firestore
  Future<void> createUserDocument({
    required String userId,
    required String email,
    required String name,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'userId': userId,
        'email': email,
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'photoUrl': '',
        'phoneNumber': '',
        'location': '',
        'farmSize': '',
        'crops': [],
      });
    } catch (e) {
      throw Exception('Failed to create user document: $e');
    }
  }

  /// Get user data from Firestore
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      final DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
  }

  /// Update user data in Firestore
  Future<void> updateUserData(
    String userId,
    Map<String, dynamic> data,
  ) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection('users').doc(userId).update(data);
    } catch (e) {
      throw Exception('Failed to update user data: $e');
    }
  }

  /// Get user data as stream (real-time updates)
  Stream<DocumentSnapshot> getUserDataStream(String userId) {
    return _firestore.collection('users').doc(userId).snapshots();
  }

  /// Add data to a collection
  Future<DocumentReference> addDocument(
    String collection,
    Map<String, dynamic> data,
  ) async {
    try {
      data['createdAt'] = FieldValue.serverTimestamp();
      return await _firestore.collection(collection).add(data);
    } catch (e) {
      throw Exception('Failed to add document: $e');
    }
  }

  /// Get documents from a collection
  Future<QuerySnapshot> getDocuments(
    String collection, {
    Query Function(Query)? queryBuilder,
  }) async {
    try {
      Query query = _firestore.collection(collection);
      if (queryBuilder != null) {
        query = queryBuilder(query);
      }
      return await query.get();
    } catch (e) {
      throw Exception('Failed to get documents: $e');
    }
  }

  /// Delete document from collection
  Future<void> deleteDocument(String collection, String documentId) async {
    try {
      await _firestore.collection(collection).doc(documentId).delete();
    } catch (e) {
      throw Exception('Failed to delete document: $e');
    }
  }

  /// ========== FIREBASE STORAGE ==========

  /// Upload image to Firebase Storage and return download URL
  /// [file] - The image file to upload
  /// [path] - The storage path (e.g., 'user_profiles', 'plant_images')
  /// Returns the download URL of the uploaded image
  Future<String> uploadImage({
    required File file,
    required String path,
  }) async {
    try {
      // Create a unique filename using timestamp and user ID
      final String fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${currentUser?.uid ?? "guest"}.jpg';
      final String fullPath = '$path/$fileName';

      // Create a reference to the location in Firebase Storage
      final Reference storageRef = _storage.ref().child(fullPath);

      // Upload the file
      final UploadTask uploadTask = storageRef.putFile(file);

      // Wait for upload to complete and get download URL
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  /// Upload multiple images
  Future<List<String>> uploadMultipleImages({
    required List<File> files,
    required String path,
  }) async {
    try {
      final List<String> downloadUrls = [];

      for (File file in files) {
        final String url = await uploadImage(file: file, path: path);
        downloadUrls.add(url);
      }

      return downloadUrls;
    } catch (e) {
      throw Exception('Failed to upload multiple images: $e');
    }
  }

  /// Delete image from Firebase Storage
  Future<void> deleteImage(String imageUrl) async {
    try {
      final Reference storageRef = _storage.refFromURL(imageUrl);
      await storageRef.delete();
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }

  /// Get download URL for a file in Storage
  Future<String> getDownloadUrl(String path) async {
    try {
      final Reference storageRef = _storage.ref().child(path);
      return await storageRef.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to get download URL: $e');
    }
  }
}
