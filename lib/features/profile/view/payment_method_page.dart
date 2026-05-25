import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet/core/theme/app_pallete.dart';
import 'package:velvet/core/theme/app_text_style.dart';

class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({super.key});
  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  int _defaultIndex = 0;

  final _cards = [
    _Card(type: 'visa',       last4: '4242', expiry: '12/26', holder: 'Devon Lane'),
    _Card(type: 'mastercard', last4: '8888', expiry: '08/25', holder: 'Devon Lane'),
  ];

  Color _cardBg(String type) {
    if (type == 'visa') return const Color(0xFF1A1A40);
    return const Color(0xFF2D2D2D);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppPallete.scaffold,
      appBar: AppBar(
        backgroundColor: AppPallete.scaffold,
        elevation: 0, scrolledUnderElevation: 0, centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: _CircleBtn(icon: Icons.chevron_left_rounded, onTap: Get.back),
        ),
        title: Text('Payment Methods', style: AppTextStyle.s16w6()),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPadding + 90),
        children: [
          // ── Cards ──────────────────────────────────────
          ..._cards.asMap().entries.map((e) {
            final i = e.key;
            final card = e.value;
            final isDefault = i == _defaultIndex;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  // Visual card
                  Container(
                    height: 180,
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: _cardBg(card.type),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.22),
                          blurRadius: 20, offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Decorative circles
                        Positioned(
                          right: -20, top: -30,
                          child: Container(
                            width: 130, height: 130,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppPallete.white.withValues(alpha: 0.05),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 30, bottom: -40,
                          child: Container(
                            width: 100, height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppPallete.white.withValues(alpha: 0.05),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Card type
                            Text(card.type.toUpperCase(),
                                style: AppTextStyle.s16w6(
                                    color: AppPallete.white)),
                            // Card number
                            Text('**** **** **** ${card.last4}',
                                style: AppTextStyle.s20w6(
                                    color: AppPallete.white)),
                            // Holder + expiry
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Card Holder',
                                        style: AppTextStyle.s10w4(
                                            color: AppPallete.white.withValues(alpha: 0.6))),
                                    Text(card.holder,
                                        style: AppTextStyle.s12w5(
                                            color: AppPallete.white)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Expires',
                                        style: AppTextStyle.s10w4(
                                            color: AppPallete.white.withValues(alpha: 0.6))),
                                    Text(card.expiry,
                                        style: AppTextStyle.s12w5(
                                            color: AppPallete.white)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Actions row
                  Row(
                    children: [
                      // Default toggle
                      GestureDetector(
                        onTap: () => setState(() => _defaultIndex = i),
                        child: Row(
                          children: [
                            Icon(
                              isDefault
                                  ? Icons.check_circle_rounded
                                  : Icons.radio_button_unchecked,
                              size: 18,
                              color: isDefault
                                  ? AppPallete.primary
                                  : AppPallete.extraAsh,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isDefault ? 'Default' : 'Set as default',
                              style: AppTextStyle.s12w5(
                                color: isDefault
                                    ? AppPallete.primary
                                    : AppPallete.subTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => setState(() => _cards.removeAt(i)),
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline_rounded,
                                size: 16, color: AppPallete.error),
                            const SizedBox(width: 4),
                            Text('Remove',
                                style: AppTextStyle.s12w5(
                                    color: AppPallete.error)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),

          // ── Cash on Delivery ───────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppPallete.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppPallete.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(
                    color: AppPallete.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.payments_outlined,
                      color: AppPallete.primary, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Cash on Delivery', style: AppTextStyle.s14w6()),
                      Text('Pay when order arrives',
                          style: AppTextStyle.s12w4(
                              color: AppPallete.subTextColor)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: AppPallete.extraAsh),
              ],
            ),
          ),
        ],
      ),

      // Add card button
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(20, 14, 20, bottomPadding + 14),
        decoration: BoxDecoration(
          color: AppPallete.surface,
          border: Border(top: BorderSide(color: AppPallete.stroke)),
        ),
        child: SizedBox(
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_rounded, color: AppPallete.white),
            label: Text('Add New Card', style: AppTextStyle.button()),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPallete.bodyText,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              elevation: 0,
            ),
          ),
        ),
      ),
    );
  }
}

class _Card {
  final String type, last4, expiry, holder;
  const _Card({required this.type, required this.last4,
      required this.expiry, required this.holder});
}

class _CircleBtn extends StatelessWidget {
  final IconData icon; final VoidCallback onTap;
  const _CircleBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 38, height: 38,
      decoration: BoxDecoration(color: AppPallete.surface, shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 8, offset: const Offset(0, 2))]),
      child: Icon(icon, color: AppPallete.bodyText, size: 20),
    ),
  );
}