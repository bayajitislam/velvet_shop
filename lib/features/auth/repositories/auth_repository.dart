import 'package:velvet/features/profile/models/user_model.dart';

// ─────────────────────────────────────────────────────────
//  AuthRepository
//
//  Currently: dummy login (no real API)
//  Later: replace _dummyLogin with real API call
// ─────────────────────────────────────────────────────────

class AuthRepository {
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  // ── Dummy login — always succeeds ──────────────────────
  // Replace this body with real API call when backend is ready
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // TODO: replace with → final response = await _apiClient.post('/auth/login', ...)
    _currentUser = UserModel.dummy;
    return _currentUser!;
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // TODO: replace with real API
    _currentUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
    );
    return _currentUser!;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  bool get isLoggedIn => _currentUser != null;
}