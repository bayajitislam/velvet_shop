import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet/features/splash/controllers/splash_controller.dart';
import 'package:velvet/routes/routes_name.dart';

class AuthController extends GetxController {
  // ── Form Keys ──────────────────────────────────────────────────────────────
  final loginFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();

  // ── Text Controllers ───────────────────────────────────────────────────────
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // ── Observable State ───────────────────────────────────────────────────────
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final rememberMe = false.obs;

  // ── Toggles ────────────────────────────────────────────────────────────────
  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;
  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  void toggleRememberMe(bool? val) => rememberMe.value = val ?? false;

  // ── Validators ─────────────────────────────────────────────────────────────
  String? validateEmail(String? val) {
    if (val == null || val.trim().isEmpty) return 'Email is required';
    if (!GetUtils.isEmail(val.trim())) return 'Enter a valid email';
    return null;
  }

  String? validatePassword(String? val) {
    if (val == null || val.isEmpty) return 'Password is required';
    if (val.length < 6) return 'Minimum 6 characters';
    return null;
  }

  String? validateName(String? val) {
    if (val == null || val.trim().isEmpty) return 'Name is required';
    if (val.trim().length < 2) return 'Name too short';
    return null;
  }

  String? validateConfirmPassword(String? val) {
    if (val == null || val.isEmpty) return 'Please confirm your password';
    if (val != passwordController.text) return 'Passwords do not match';
    return null;
  }

  // ── Auth Actions ───────────────────────────────────────────────────────────
  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;
    isLoading.value = true;
    await Future.delayed(
      const Duration(seconds: 2),
    ); // TODO: replace with repository call
    SplashController.saveToken('127347162374672137467127');
    isLoading.value = false;
    Get.offAllNamed(RoutesName.home);
  }

  Future<void> signup() async {
    if (!signupFormKey.currentState!.validate()) return;
    isLoading.value = true;
    await Future.delayed(
      const Duration(seconds: 2),
    ); // TODO: replace with repository call
    isLoading.value = false;
    Get.offAllNamed(RoutesName.home);
  }

  void logout() {
    _clear();
    Get.offAllNamed(RoutesName.login);
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  void _clear() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    confirmPasswordController.clear();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
