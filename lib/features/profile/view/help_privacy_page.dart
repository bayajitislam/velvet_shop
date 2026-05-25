import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet/core/theme/app_pallete.dart';
import 'package:velvet/core/theme/app_text_style.dart';

// ─────────────────────────────────────────────────────────
//  Help & FAQ Page
// ─────────────────────────────────────────────────────────

class HelpFaqPage extends StatefulWidget {
  const HelpFaqPage({super.key});
  @override
  State<HelpFaqPage> createState() => _HelpFaqPageState();
}

class _HelpFaqPageState extends State<HelpFaqPage> {
  int? _openIndex;

  final _faqs = [
    _Faq(
      'How do I track my order?',
      'Once your order is shipped, you\'ll receive a tracking number via email. You can also track it from the "My Orders" section in your profile.',
    ),
    _Faq(
      'Can I return or exchange an item?',
      'Yes! We offer a 30-day return policy. Items must be unworn, unwashed, and in original packaging. Go to My Orders → select item → Request Return.',
    ),
    _Faq(
      'How long does delivery take?',
      'Standard delivery takes 3–5 business days. Express delivery (1–2 days) is available at checkout for an additional fee.',
    ),
    _Faq(
      'Is my payment information secure?',
      'Absolutely. We use industry-standard SSL encryption and never store your full card details on our servers.',
    ),
    _Faq(
      'How do I change my delivery address?',
      'You can update your address before the order is shipped. Go to My Orders → select order → Edit Address. After shipping, contact support.',
    ),
    _Faq(
      'What sizes are available?',
      'We offer XS through XXL for most items. Check the Size Guide on each product page for exact measurements.',
    ),
    _Faq(
      'How do I cancel my order?',
      'Orders can be cancelled within 1 hour of placement. Go to My Orders → select order → Cancel Order.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.scaffold,
      appBar: AppBar(
        backgroundColor: AppPallete.scaffold,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: _CircleBtn(icon: Icons.chevron_left_rounded, onTap: Get.back),
        ),
        title: Text('Help & FAQ', style: AppTextStyle.s16w6()),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          // Contact support card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppPallete.primary, AppPallete.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Need more help?',
                        style: AppTextStyle.s14w6(color: AppPallete.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Our support team is here for you.',
                        style: AppTextStyle.s12w4(
                          color: AppPallete.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPallete.white,
                    foregroundColor: AppPallete.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: Text(
                    'Contact Us',
                    style: AppTextStyle.s12w5(color: AppPallete.primary),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              'Frequently Asked Questions',
              style: AppTextStyle.s14w6(),
            ),
          ),

          // FAQ accordion
          ..._faqs.asMap().entries.map((e) {
            final i = e.key;
            final faq = e.value;
            final isOpen = _openIndex == i;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: AppPallete.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isOpen ? AppPallete.primary : AppPallete.border,
                  width: isOpen ? 1.5 : 1.0,
                ),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _openIndex = isOpen ? null : i),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              faq.question,
                              style: AppTextStyle.s14w6().copyWith(color: AppPallete.bodyText),
                            ),
                          ),
                          AnimatedRotation(
                            turns: isOpen ? 0.5 : 0,
                            duration: const Duration(milliseconds: 220),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: isOpen
                                  ? AppPallete.primary
                                  : AppPallete.extraAsh,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 220),
                    crossFadeState: isOpen
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    firstChild: const SizedBox.shrink(),
                    secondChild: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                      child: Text(
                        faq.answer,
                        style: AppTextStyle.s12w4(
                          color: AppPallete.subTextColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _Faq {
  final String question, answer;
  const _Faq(this.question, this.answer);
}

// ─────────────────────────────────────────────────────────
//  Privacy Policy Page
// ─────────────────────────────────────────────────────────

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  static const _sections = [
    _PolicySection(
      'Information We Collect',
      'We collect information you provide directly, such as your name, email address, phone number, and payment information when you create an account or make a purchase. We also collect usage data including browsing history within the app.',
    ),
    _PolicySection(
      'How We Use Your Information',
      'Your information is used to process orders, send order updates, improve our services, and personalize your shopping experience. We do not sell your personal data to third parties.',
    ),
    _PolicySection(
      'Data Security',
      'We implement industry-standard security measures including SSL encryption and secure payment processing. Your payment details are never stored on our servers.',
    ),
    _PolicySection(
      'Cookies & Tracking',
      'We use cookies and similar technologies to remember your preferences and improve app performance. You can opt out of non-essential tracking in your device settings.',
    ),
    _PolicySection(
      'Third-Party Services',
      'We use trusted third-party services for payment processing, analytics, and delivery tracking. These services have their own privacy policies and only receive the data needed for their specific function.',
    ),
    _PolicySection(
      'Your Rights',
      'You have the right to access, correct, or delete your personal data at any time. Contact our support team to exercise these rights. You can also request a copy of all data we hold about you.',
    ),
    _PolicySection(
      'Contact Us',
      'If you have any questions about this Privacy Policy, contact us at privacy@velvet.app or through the Help & FAQ section.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.scaffold,
      appBar: AppBar(
        backgroundColor: AppPallete.scaffold,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: _CircleBtn(icon: Icons.chevron_left_rounded, onTap: Get.back),
        ),
        title: Text('Privacy Policy', style: AppTextStyle.s16w6()),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: [
          Text(
            'Last updated: May 25, 2026',
            style: AppTextStyle.s12w4(color: AppPallete.extraAsh),
          ),
          const SizedBox(height: 16),
          Text(
            'At velvet., we take your privacy seriously. This policy explains how we collect, use, and protect your personal information.',
            style: AppTextStyle.s14w4(color: AppPallete.subTextColor),
          ),
          const SizedBox(height: 24),
          ..._sections.map((s) => _PolicyCard(section: s)),
        ],
      ),
    );
  }
}

class _PolicyCard extends StatelessWidget {
  final _PolicySection section;
  const _PolicyCard({required this.section});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPallete.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppPallete.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppPallete.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(section.title, style: AppTextStyle.s14w6().copyWith(color: AppPallete.bodyText)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            section.body,
            style: AppTextStyle.s12w4(color: AppPallete.subTextColor),
          ),
        ],
      ),
    );
  }
}

class _PolicySection {
  final String title, body;
  const _PolicySection(this.title, this.body);
}

// ── Shared circle button ───────────────────────────────────
class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: AppPallete.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: AppPallete.bodyText, size: 20),
    ),
  );
}
