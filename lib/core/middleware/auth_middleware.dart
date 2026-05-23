import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet/features/splash/controllers/splash_controller.dart';
import 'package:velvet/routes/routes_name.dart';

/// Attach this middleware to any route that requires a logged-in user.
///
/// Behaviour:
///   • Not logged in → show a bottom sheet prompt, then redirect to login.
///   • Logged in     → let the route through normally.
///
/// Usage in GetPage:
///   GetPage(
///     name: RoutesName.cart,
///     page: () => const CartPage(),
///     middlewares: [AuthMiddleware()],
///   ),
class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1; // higher = runs earlier

  @override
  RouteSettings? redirect(String? route) {
    final isLoggedIn = SplashController.readToken() != null &&
        SplashController.readToken()!.isNotEmpty;

    if (!isLoggedIn) {
      // Show a friendly prompt before bouncing to login
      _showLoginPrompt(route);

      // Return null to cancel the navigation for now;
      // _showLoginPrompt handles the actual redirect after user taps.
      return null;
    }
    return null; // logged in → proceed normally
  }

  void _showLoginPrompt(String? attemptedRoute) {
    // Small delay so the sheet appears after navigation settles
    Future.delayed(const Duration(milliseconds: 100), () {
      Get.bottomSheet(
        _LoginPromptSheet(attemptedRoute: attemptedRoute),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
      );
    });
  }
}

/// Bottom sheet shown when a guest taps a protected feature
class _LoginPromptSheet extends StatelessWidget {
  final String? attemptedRoute;
  const _LoginPromptSheet({this.attemptedRoute});

  String get _featureName {
    switch (attemptedRoute) {
      case '/cart':
        return 'your cart';
      case '/wishlist':
        return 'your wishlist';
      case '/checkout':
        return 'checkout';
      case '/profile':
        return 'your profile';
      default:
        return 'this feature';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        20,
        24,
        24 + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Pill handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Lock icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFFCE4EC),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.lock_outline_rounded,
                color: Color(0xFFE91E63), size: 32),
          ),
          const SizedBox(height: 16),

          const Text(
            'Sign in required',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You need to be signed in to access $_featureName.\nBrowsing & viewing products is free!',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF757575),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),

          // Sign In button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Get.back(); // close sheet
                Get.toNamed(
                  RoutesName.login,
                  arguments: {'redirect': attemptedRoute},
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E63),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text(
                'Sign In',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Continue browsing
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: () => Get.back(),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFF8BBD0), width: 1.3),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text(
                'Continue Browsing',
                style: TextStyle(
                  color: Color(0xFFE91E63),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}