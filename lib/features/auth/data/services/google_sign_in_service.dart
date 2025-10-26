import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/error/exceptions.dart';

/// Resultado del proceso de Google Sign-In
class GoogleSignInResult {
  final String idToken;
  final String email;
  final String displayName;
  final String? photoUrl;
  final String uid;

  GoogleSignInResult({
    required this.idToken,
    required this.email,
    required this.displayName,
    this.photoUrl,
    required this.uid,
  });

  Map<String, dynamic> toJson() {
    return {
      'idToken': idToken,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'uid': uid,
    };
  }
}

/// Servicio para manejar Google Sign-In con Firebase
class GoogleSignInService {
  final GoogleSignIn _googleSignIn;
  final firebase_auth.FirebaseAuth _firebaseAuth;

  GoogleSignInService({
    GoogleSignIn? googleSignIn,
    firebase_auth.FirebaseAuth? firebaseAuth,
  })  : _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  /// Inicia sesión con Google y devuelve el token de ID
  ///
  /// Retorna un Map con:
  /// - idToken: Token de Google para verificar en el backend
  /// - email: Email del usuario
  /// - displayName: Nombre completo del usuario
  /// - photoUrl: URL de la foto de perfil
  Future<GoogleSignInResult> signInWithGoogle() async {
    try {
      print('🔵 GOOGLE_SIGN_IN: Iniciando proceso de Google Sign-In');

      // Cerrar sesión previa si existe
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print('❌ GOOGLE_SIGN_IN: Usuario canceló el login');
        throw const AuthException('Login con Google cancelado por el usuario');
      }

      print(
          '✅ GOOGLE_SIGN_IN: Usuario de Google obtenido: ${googleUser.email}');

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.idToken == null) {
        print('❌ GOOGLE_SIGN_IN: No se pudo obtener el idToken');
        throw const AuthException('No se pudo obtener el token de Google');
      }

      print('✅ GOOGLE_SIGN_IN: Token de Google obtenido');

      // Create a new credential
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final firebase_auth.UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      final firebase_auth.User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        print('❌ GOOGLE_SIGN_IN: No se pudo obtener el usuario de Firebase');
        throw const AuthException('Error al autenticar con Firebase');
      }

      print('✅ GOOGLE_SIGN_IN: Autenticación con Firebase exitosa');

      // Obtener el ID token de Firebase (este es el que enviaremos al backend)
      final String? idToken = await firebaseUser.getIdToken();

      if (idToken == null) {
        print('❌ GOOGLE_SIGN_IN: No se pudo obtener el ID token de Firebase');
        throw const AuthException(
            'No se pudo obtener el token de autenticación');
      }

      print('✅ GOOGLE_SIGN_IN: ID Token de Firebase obtenido');
      print('📧 GOOGLE_SIGN_IN: Email: ${firebaseUser.email}');
      print('👤 GOOGLE_SIGN_IN: Display Name: ${firebaseUser.displayName}');

      return GoogleSignInResult(
        idToken: idToken,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName ?? '',
        photoUrl: firebaseUser.photoURL,
        uid: firebaseUser.uid,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      print(
          '❌ GOOGLE_SIGN_IN: FirebaseAuthException: ${e.code} - ${e.message}');
      throw AuthException('Error de autenticación: ${e.message ?? e.code}');
    } catch (e) {
      print('❌ GOOGLE_SIGN_IN: Error inesperado: $e');
      if (e is AuthException) rethrow;
      throw AuthException('Error al iniciar sesión con Google: $e');
    }
  }

  /// Cierra la sesión de Google y Firebase
  Future<void> signOut() async {
    try {
      await Future.wait([
        _googleSignIn.signOut(),
        _firebaseAuth.signOut(),
      ]);
      print('✅ GOOGLE_SIGN_IN: Sesión cerrada exitosamente');
    } catch (e) {
      print('⚠️ GOOGLE_SIGN_IN: Error al cerrar sesión: $e');
      // No lanzar error, el logout debe ser silencioso
    }
  }
}
