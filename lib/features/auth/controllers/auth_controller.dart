import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet/features/auth/repositories/auth_repository.dart';
import 'package:velvet/features/profile/models/user_model.dart';
import 'package:velvet/features/splash/controllers/splash_controller.dart';
import 'package:velvet/routes/routes_name.dart';

// ─────────────────────────────────────────────────────────
//  AuthController
// ─────────────────────────────────────────────────────────
class AuthController extends GetxController {
  final AuthRepository repo;
  AuthController({required this.repo});

  // ── User State ─────────────────────────────────────────
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  bool get isLoggedIn => user.value != null;

  // ── Form Keys ──────────────────────────────────────────
  final loginFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();

  // ── Text Controllers ───────────────────────────────────
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // ── UI Toggles ─────────────────────────────────────────
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final rememberMe = false.obs;

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;
  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  void toggleRememberMe(bool? val) => rememberMe.value = val ?? false;

  // ── Validators ─────────────────────────────────────────
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

  // ── Lifecycle ──────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    user.value = UserModel.dummy; // TODO: remove when real auth is ready
  }

  // ── Login ──────────────────────────────────────────────
  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await repo.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      user.value = result;
      _clearFields();
      Get.offAllNamed(RoutesName.home);
    } catch (e) {
      errorMessage.value = 'Invalid email or password';
    } finally {
      isLoading.value = false;
    }
  }

  // ── Register ───────────────────────────────────────────
  // ── Signup ─────────────────────────────────────────────
  Future<void> signup() async {
    if (!signupFormKey.currentState!.validate()) return;
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await repo.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      user.value = result;
      _clearFields();
      Get.offAllNamed(RoutesName.home);
    } catch (e) {
      errorMessage.value = 'Registration failed. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  // ── Logout ─────────────────────────────────────────────
  Future<void> logout() async {
    await repo.logout();
    SplashController.clearToken();
    Get.toNamed(RoutesName.login);
  }

  // ── Helpers ────────────────────────────────────────────
  void _clearFields() {
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
