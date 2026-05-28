import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet/core/common/app_dialog.dart';
import 'package:velvet/core/theme/app_pallete.dart';
import 'package:velvet/core/theme/app_text_style.dart';

class SavedAddressesPage extends StatefulWidget {
  const SavedAddressesPage({super.key});

  @override
  State<SavedAddressesPage> createState() => _SavedAddressesPageState();
}

class _SavedAddressesPageState extends State<SavedAddressesPage> {
  int _defaultIndex = 0;

  final _addresses = [
    _Addr(
      label: 'Home',
      name: 'Devon Lane',
      detail: '2464 Royal Ln. Mesa, New Jersey 45463',
      phone: '+1 234 567 8900',
    ),
    _Addr(
      label: 'Office',
      name: 'Devon Lane',
      detail: '3517 W. Gray St. Utica, Pennsylvania 57867',
      phone: '+1 234 567 8901',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

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
        title: Text('Saved Addresses', style: AppTextStyle.s16w6()),
      ),
      body: ListView.separated(
        padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPadding + 90),
        itemCount: _addresses.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final a = _addresses[i];
          final isDefault = i == _defaultIndex;
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppPallete.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDefault ? AppPallete.primary : AppPallete.border,
                width: isDefault ? 1.8 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppPallete.primary.withValues(
                    alpha: isDefault ? 0.10 : 0.05,
                  ),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Label badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isDefault
                            ? AppPallete.primary.withValues(alpha: 0.1)
                            : AppPallete.background,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            a.label == 'Home'
                                ? Icons.home_outlined
                                : Icons.business_outlined,
                            size: 14,
                            color: isDefault
                                ? AppPallete.primary
                                : AppPallete.subTextColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            a.label,
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
                    // Edit
                    GestureDetector(
                      onTap: () {},
                      child: Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: AppPallete.extraAsh,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Delete
                    GestureDetector(
                      onTap: () => setState(() => _addresses.removeAt(i)),
                      child: Icon(
                        Icons.delete_outline_rounded,
                        size: 18,
                        color: AppPallete.error,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  a.name,
                  style: AppTextStyle.s14w6().copyWith(
                    color: AppPallete.bodyText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  a.detail,
                  style: AppTextStyle.s12w4(color: AppPallete.subTextColor),
                ),
                const SizedBox(height: 4),
                Text(
                  a.phone,
                  style: AppTextStyle.s12w4(color: AppPallete.extraAsh),
                ),
                const SizedBox(height: 12),
                // Set default
                if (!isDefault)
                  GestureDetector(
                    onTap: () => setState(() => _defaultIndex = i),
                    child: Row(
                      children: [
                        Icon(
                          Icons.radio_button_unchecked,
                          size: 16,
                          color: AppPallete.extraAsh,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Set as default',
                          style: AppTextStyle.s12w5(
                            color: AppPallete.subTextColor,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 16,
                        color: AppPallete.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Default address',
                        style: AppTextStyle.s12w5(color: AppPallete.primary),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),

      // Add new address button
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(20, 14, 20, bottomPadding + 14),
        decoration: BoxDecoration(
          color: AppPallete.surface,
          border: Border(top: BorderSide(color: AppPallete.stroke)),
        ),
        child: SizedBox(
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () {
              Get.back();
              showDialog(
                context: context,
                builder: (context) =>
                    AppDialog(message: 'This feature is coming soon'),
              );
            },
            icon: const Icon(Icons.add_rounded, color: AppPallete.white),
            label: Text('Add New Address', style: AppTextStyle.button()),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPallete.bodyText,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
          ),
        ),
      ),
    );
  }
}

class _Addr {
  final String label, name, detail, phone;
  const _Addr({
    required this.label,
    required this.name,
    required this.detail,
    required this.phone,
  });
}

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
