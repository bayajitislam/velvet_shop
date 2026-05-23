import 'package:flutter/material.dart';
import 'package:velvet/core/common/app_loader.dart';
import 'package:velvet/core/theme/app_pallete.dart';
import 'package:velvet/core/theme/app_text_style.dart';

/// velvet. branded primary button.
///
/// Usage:
///   PrimaryButton(
///     buttonName: 'Sign In',
///     onPressed: controller.login,
///     isLoading: ctrl.isLoading.value,
///   )
///
/// With icon:
///   PrimaryButton(
///     buttonName: 'Add to Cart',
///     onPressed: () {},
///     icon: Icons.shopping_bag_outlined,
///   )
///
/// Outlined variant:
///   PrimaryButton(
///     buttonName: 'Continue Browsing',
///     onPressed: () {},
///     variant: ButtonVariant.outlined,
///   )
class PrimaryButton extends StatelessWidget {
  final String buttonName;
  final void Function()? onPressed;
  final bool isLoading;
  final double borderRadius;
  final ButtonVariant variant;
  final IconData? icon;
  final double height;

  const PrimaryButton({
    super.key,
    required this.buttonName,
    required this.onPressed,
    this.isLoading = false,
    this.borderRadius = 12,
    this.variant = ButtonVariant.filled,
    this.icon,
    this.height = 52,
  });

  // ── Derived style values ────────────────────────────────────────────────────
  bool get _isDisabled => onPressed == null || isLoading;

  Color get _backgroundColor {
    if (variant == ButtonVariant.outlined) return AppPallete.transparent;
    if (_isDisabled) return AppPallete.primaryLight; // muted pink when disabled
    return AppPallete.primary;
  }

  Color get _foregroundColor {
    if (variant == ButtonVariant.outlined) return AppPallete.primary;
    return AppPallete.white; // white text on pink — always readable
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        // Pink glow shadow — only on filled, enabled state
        boxShadow: (variant == ButtonVariant.filled && !_isDisabled)
            ? [
                BoxShadow(
                  color: AppPallete.dropShadow, // 0x26E91E63 — pink @ 15%
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: _isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _backgroundColor,
          disabledBackgroundColor: AppPallete.primaryLight,
          foregroundColor: _foregroundColor,
          elevation: 0,
          shadowColor: AppPallete.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: variant == ButtonVariant.outlined
                ? const BorderSide(color: AppPallete.primary, width: 1.5)
                : BorderSide.none,
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isLoading
              ? const SizedBox(
                  key: ValueKey('loader'),
                  width: 22,
                  height: 22,
                  child: AppLoader(color: AppPallete.white),
                )
              : _ButtonContent(
                  key: const ValueKey('content'),
                  label: buttonName,
                  icon: icon,
                  color: _foregroundColor,
                ),
        ),
      ),
    );
  }
}

// ── Content row (label + optional icon) ──────────────────────────────────────
class _ButtonContent extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color color;

  const _ButtonContent({
    super.key,
    required this.label,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: AppTextStyle.button(color: color),
        ),
      ],
    );
  }
}

// ── Variants ──────────────────────────────────────────────────────────────────
enum ButtonVariant {
  filled,   // pink bg, white text  ← default
  outlined, // transparent bg, pink border + text
}