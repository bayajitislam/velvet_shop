import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet/core/constants/app_strings.dart';
import 'package:velvet/core/theme/app_pallete.dart';
import 'package:velvet/core/theme/app_text_style.dart';
import 'package:velvet/features/auth/controllers/auth_controller.dart';
import 'package:velvet/features/auth/widgets/auth_devider.dart';
import 'package:velvet/features/auth/widgets/auth_primary_button.dart';
import 'package:velvet/features/auth/widgets/auth_signup_header.dart';
import 'package:velvet/features/auth/widgets/auth_social_button.dart';
import 'package:velvet/features/auth/widgets/auth_text_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<Offset> _formSlideUp;
  late final Animation<double> _fadeOpacity;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400), // Synced with Login
    );

    // Form Container Slide Up
    _formSlideUp = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _fadeOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppPallete.primary,
      body: Column(
        children: [
          // ── Header (Fade In) ───────────────────────────────────────
          FadeTransition(
            opacity: _fadeOpacity,
            child: const AuthSignupHeader(),
          ),

          // ── White Form Sheet (Staggered) ────────────────────────────
          Expanded(
            child: SlideTransition(
              position: _formSlideUp,
              child: FadeTransition(
                opacity: _fadeOpacity,
                child: SizedBox(
                  width: double.infinity,
                  // ClipRRect fixes the rounded corner clipping issue
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppPallete.scaffold,
                        boxShadow: [
                          BoxShadow(
                            color: AppPallete.dropShadow,
                            blurRadius: 40,
                            offset: Offset(0, -10),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.only(
                          left: 24,
                          right: 24,
                          top: 32,
                          bottom: 32 + MediaQuery.of(context).padding.bottom,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Header Text ───────────────────────────────
                            _StaggeredFade(
                              index: 0,
                              controller: _animController,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppStrings.signupTitle,
                                    style: AppTextStyle.s24w7(),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    AppStrings.signupSubtitle,
                                    style: AppTextStyle.s14w4(),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // ── Form ───────────────────────────────────────
                            Form(
                              key: ctrl.signupFormKey,
                              child: Column(
                                children: [
                                  _StaggeredFade(
                                    index: 1,
                                    controller: _animController,
                                    child: AuthTextField(
                                      controller: ctrl.nameController,
                                      label: AppStrings.labelFullName,
                                      hint: AppStrings.hintFullName,
                                      icon: Icons.person_outline_rounded,
                                      keyboardType: TextInputType.name,
                                      validator: ctrl.validateName,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _StaggeredFade(
                                    index: 2,
                                    controller: _animController,
                                    child: AuthTextField(
                                      controller: ctrl.emailController,
                                      label: AppStrings.labelEmail,
                                      hint: AppStrings.hintEmail,
                                      icon: Icons.mail_outline_rounded,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: ctrl.validateEmail,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _StaggeredFade(
                                    index: 3,
                                    controller: _animController,
                                    child: Obx(
                                      () => AuthTextField(
                                        controller: ctrl.passwordController,
                                        label: AppStrings.labelPassword,
                                        hint: AppStrings.hintMinPassword,
                                        icon: Icons.lock_outline_rounded,
                                        obscureText: !ctrl.isPasswordVisible.value,
                                        validator: ctrl.validatePassword,
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            ctrl.isPasswordVisible.value
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                            color: AppPallete.extraAsh,
                                            size: 20,
                                          ),
                                          onPressed: ctrl.togglePasswordVisibility,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _StaggeredFade(
                                    index: 4,
                                    controller: _animController,
                                    child: Obx(
                                      () => AuthTextField(
                                        controller: ctrl.confirmPasswordController,
                                        label: AppStrings.labelConfirmPassword,
                                        hint: AppStrings.hintConfirmPassword,
                                        icon: Icons.lock_outline_rounded,
                                        obscureText:
                                            !ctrl.isConfirmPasswordVisible.value,
                                        validator: ctrl.validateConfirmPassword,
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            ctrl.isConfirmPasswordVisible.value
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                            color: AppPallete.extraAsh,
                                            size: 20,
                                          ),
                                          onPressed:
                                              ctrl.toggleConfirmPasswordVisibility,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // ── Terms ─────────────────────────────────────
                            _StaggeredFade(
                              index: 5,
                              controller: _animController,
                              child: RichText(
                                text: TextSpan(
                                  style: AppTextStyle.s12w4(),
                                  children: [
                                    TextSpan(text: AppStrings.textTerms),
                                    TextSpan(
                                      text: AppStrings.textTermsOfService,
                                      style: AppTextStyle.s12w5(
                                        color: AppPallete.primary,
                                      ),
                                    ),
                                    TextSpan(text: AppStrings.textAnd),
                                    TextSpan(
                                      text: AppStrings.textPrivacyPolicy,
                                      style: AppTextStyle.s12w5(
                                        color: AppPallete.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 28),

                            // ── Button ────────────────────────────────────
                            _StaggeredFade(
                              index: 6,
                              controller: _animController,
                              child: Obx(
                                () => AuthPrimaryButton(
                                  label: AppStrings.btnCreateAccount,
                                  isLoading: ctrl.isLoading.value,
                                  onTap: ctrl.signup,
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),
                            
                            // ── Divider ────────────────────────────────────
                            _StaggeredFade(
                              index: 7,
                              controller: _animController,
                              child: AuthDivider(text: AppStrings.orContinueWith),
                            ),
                            const SizedBox(height: 24),

                            // ── Social Buttons ─────────────────────────────
                            _StaggeredFade(
                              index: 8,
                              controller: _animController,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: AuthSocialButton(
                                      label: AppStrings.btnGoogle,
                                      icon: Icons.g_mobiledata_rounded,
                                      onTap: () {},
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: AuthSocialButton(
                                      label: AppStrings.btnFacebook,
                                      icon: Icons.facebook_rounded,
                                      onTap: () {},
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 32),

                            // ── Footer ─────────────────────────────────────
                            _StaggeredFade(
                              index: 9,
                              controller: _animController,
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                    text: AppStrings.textHasAccount,
                                    style: AppTextStyle.s14w4(),
                                    children: [
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.baseline,
                                        baseline: TextBaseline.alphabetic,
                                        child: GestureDetector(
                                          onTap: () => Get.back(),
                                          child: Text(
                                            AppStrings.textSignInLink,
                                            style: AppTextStyle.s14w6(
                                              color: AppPallete.primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// HELPER: Staggered Animation Widget (Same as Login)
// ──────────────────────────────────────────────────────────────────────────────

class _StaggeredFade extends StatelessWidget {
  final int index;
  final Widget child;
  final AnimationController controller;

  const _StaggeredFade({
    required this.index,
    required this.child,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // Snappy timing: start 20% + (index * 6%)
    final double start = 0.2 + (index * 0.06);
    final double end = (start + 0.3).clamp(0.0, 1.0);

    final opacityAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(start, end, curve: Curves.easeOut),
      ),
    );

    final slideAnim = Tween<Offset>(begin: const Offset(0, 20), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(start, end, curve: Curves.easeOutCubic),
          ),
        );

    return FadeTransition(
      opacity: opacityAnim,
      child: SlideTransition(position: slideAnim, child: child),
    );
  }
}