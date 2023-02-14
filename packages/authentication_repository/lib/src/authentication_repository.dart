import 'dart:async';
import 'package:cache/cache.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:firebase_custom/firebase_custom.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:nameum_types/nameum_types.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpWithEmailAndPasswordFailure implements Exception {
  const SignUpWithEmailAndPasswordFailure(
      [this.message = "An unknown exception occurred."]);

  factory SignUpWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const SignUpWithEmailAndPasswordFailure(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const SignUpWithEmailAndPasswordFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'email-already-in-use':
        return const SignUpWithEmailAndPasswordFailure(
          'An account already exists for that email.',
        );
      case 'operation-not-allowed':
        return const SignUpWithEmailAndPasswordFailure(
          'Operation is not allowed.  Please contact support.',
        );
      case 'weak-password':
        return const SignUpWithEmailAndPasswordFailure(
          'Please enter a stronger password.',
        );
      default:
        return const SignUpWithEmailAndPasswordFailure();
    }
  }
  final String message;
}

class LogInWithEmailAndPasswordFailure implements Exception {
  /// {@macro log_in_with_email_and_password_failure}
  const LogInWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory LogInWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const LogInWithEmailAndPasswordFailure(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const LogInWithEmailAndPasswordFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const LogInWithEmailAndPasswordFailure(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return const LogInWithEmailAndPasswordFailure(
          'Incorrect password, please try again.',
        );
      default:
        return const LogInWithEmailAndPasswordFailure();
    }
  }

  final String message;
}

class LogInWithGoogleFailure implements Exception {
  const LogInWithGoogleFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  factory LogInWithGoogleFailure.fromCode(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return const LogInWithGoogleFailure(
          'Account exists with different credentials.',
        );
      case 'invalid-credential':
        return const LogInWithGoogleFailure(
          'The credential received is malformed or has expired.',
        );
      case 'operation-not-allowed':
        return const LogInWithGoogleFailure(
          'Operation is not allowed.  Please contact support.',
        );
      case 'user-disabled':
        return const LogInWithGoogleFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const LogInWithGoogleFailure(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return const LogInWithGoogleFailure(
          'Incorrect password, please try again.',
        );
      case 'invalid-verification-code':
        return const LogInWithGoogleFailure(
          'The credential verification code received is invalid.',
        );
      case 'invalid-verification-id':
        return const LogInWithGoogleFailure(
          'The credential verification ID received is invalid.',
        );
      case 'unknown':
        {
          return const LogInWithGoogleFailure('Email or Username is unknown.');
        }
      default:
        return const LogInWithGoogleFailure();
    }
  }

  /// The associated error message.
  final String message;
}

/// Thrown during the logout process if a failure occurs.
class LogOutFailure implements Exception {}

class AuthenticationRepository {
  AuthenticationRepository(
      {CacheClient? cache,
      firebase_auth.FirebaseAuth? firebaseAuth,
      GoogleSignIn? googleSignIn})
      : _cache = cache ?? CacheClient(),
        _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard();
  final CacheClient _cache;
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  /// User cache key.
  /// Should only be used for testing purposes
  @visibleForTesting
  static const userCacheKey = '__user_cache_key__';

  Stream<Future<User>?> get firebaseUser {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      Future<User>? user;
      if (firebaseUser != null) {
        user = FireStoreMethods.getUserByEmailWithSignup(
          firebaseUser.email!,
          firebaseUser.displayName!,
          firebaseUser.uid,
        );
      }
      return user;
    });
  }

  User get currentUser {
    return _cache.read<User>(key: userCacheKey) ?? User.empty;
  }

  Future<void> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  Future<void> logInWithGoogle() async {
    try {
      late final firebase_auth.AuthCredential credential;
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      credential = firebase_auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      final userInfo = (await _firebaseAuth.signInWithCredential(credential))
          .additionalUserInfo;

      final email = userInfo?.profile?['email'];
      final name = userInfo?.profile?['name'];
      final uid = userInfo?.profile?['uid'];

      if (email != null && name != null && uid != null) {
        FireStoreMethods.getUserByEmailWithSignup(email, name, uid);
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      throw LogInWithGoogleFailure.fromCode(e.code);
    } catch (e) {
      print(e);

      throw const LogInWithGoogleFailure();
    }
  }

  Future<void> logInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  Future<User?> logInWithoutFirebase(String email, String password) async {
    User? user;
    try {
      user = await FireStoreMethods.getUserByEmail(email);
      if (user != null) {
        if (user.signupType == SignupType.email && user.password == password) {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('userEmail', email);
        } else {
          // throw pass error
        }
        // throw no such user error
      }
    } catch (e) {}
    return user;
  }

  Future<void> signInWithoutFirebase(String email, String password) async {
    try {
      final check = await FireStoreMethods.getUserByEmail(email);
      if (check != null) {
        // throw already exist user error
      }
      FireStoreMethods.signUpWithoutFirebase(email, email, password);
    } catch (e) {}
  }

  void logOutWithoutFirestore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString('userEmail') != null) {
        prefs.remove('userEmail');
      }
    } catch (e) {}
  }

  Future<void> logOut() async {
    try {
      Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
    } catch (_) {
      throw LogOutFailure();
    }
  }
}

extension on firebase_auth.User {
  User get toUser {
    return User(
        email: email ?? "",
        userId: uid,
        name: displayName ?? "Default",
        profileImg: photoURL ?? "");
  }
}
