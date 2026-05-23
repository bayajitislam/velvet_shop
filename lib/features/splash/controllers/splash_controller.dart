import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../routes/routes_name.dart';

/// Handles the BUSINESS LOGIC of splash:
///   - Decides where to navigate after animations finish
///   - Checks if user is already logged in
///
/// Animations stay in SplashPage (they need TickerProvider).
/// This controller owns only the "what happens next" decision.
class SplashController extends GetxController {
  final _box = GetStorage();

  // ── Auth state key (shared with AuthController) ────────────────────────────
  static const _kAuthToken = 'auth_token';

  /// True if a valid session token exists locally
  bool get isLoggedIn {
    final token = _box.read<String>(_kAuthToken);
    return token != null && token.isNotEmpty;
  }

  /// Called by SplashPage once all animations have completed.
  /// Replaces the splash with the correct first screen.
  void navigateAfterSplash() {
    if (isLoggedIn) {
      // User already authenticated → go straight to home
      Get.offAllNamed(RoutesName.home);
    } else {
      // Not authenticated → show login
      Get.offAllNamed(RoutesName.home);
    }
  }

  // ── Helpers called by AuthController on login/logout ──────────────────────

  /// Persist token after successful login
  static void saveToken(String token) {
    GetStorage().write(_kAuthToken, token);
  }

  /// Clear token on logout
  static void clearToken() {
    GetStorage().remove(_kAuthToken);
  }

  /// Read token anywhere in the app
  static String? readToken() {
    return GetStorage().read<String>(_kAuthToken);
  }
}