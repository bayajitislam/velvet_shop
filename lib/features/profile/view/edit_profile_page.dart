import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet/core/theme/app_pallete.dart';
import 'package:velvet/core/theme/app_text_style.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameCtrl    = TextEditingController(text: 'Bayajit Islam');
  final _emailCtrl   = TextEditingController(text: 'realbayajitislam@email.com');
  final _phoneCtrl   = TextEditingController(text: '+01912345678');
  final _formKey     = GlobalKey<FormState>();
  bool _isSaving     = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 800)); // mock save
    setState(() => _isSaving = false);
    Get.back();
    Get.snackbar(
      'Saved',
      'Profile updated successfully',
      backgroundColor: AppPallete.primary,
      colorText: AppPallete.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

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
        title: Text('Edit Profile', style: AppTextStyle.s16w6()),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 16, 20, bottomPadding + 100),
          child: Column(
            children: [
              // ── Avatar ──────────────────────────────────
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppPallete.background,
                      child: Icon(Icons.person_rounded,
                          size: 50, color: AppPallete.primary),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {}, // TODO: image picker
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppPallete.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppPallete.surface, width: 2),
                          ),
                          child: const Icon(Icons.camera_alt_outlined,
                              size: 16, color: AppPallete.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),
              Text('Change photo',
                  style: AppTextStyle.s12w5(color: AppPallete.indigoNavy)),

              const SizedBox(height: 32),

              // ── Fields ───────────────────────────────────
              _Field(
                label: 'Full Name',
                controller: _nameCtrl,
                icon: Icons.person_outline_rounded,
                validator: (v) =>
                    v!.trim().isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),
              _Field(
                label: 'Email Address',
                controller: _emailCtrl,
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (v) =>
                    v!.contains('@') ? null : 'Enter a valid email',
              ),
              const SizedBox(height: 16),
              _Field(
                label: 'Phone Number',
                controller: _phoneCtrl,
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ),

      // ── Save button ──────────────────────────────────────
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(20, 14, 20, bottomPadding + 14),
        decoration: BoxDecoration(
          color: AppPallete.surface,
          border: Border(top: BorderSide(color: AppPallete.stroke)),
        ),
        child: SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: _isSaving ? null : _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPallete.bodyText,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              elevation: 0,
            ),
            child: _isSaving
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        color: AppPallete.white, strokeWidth: 2))
                : Text('Save Changes', style: AppTextStyle.button()),
          ),
        ),
      ),
    );
  }
}

// ── Reusable input field ───────────────────────────────────
class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _Field({
    required this.label,
    required this.controller,
    required this.icon,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyle.s12w5(color: AppPallete.subTextColor)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: AppTextStyle.s14w4(color: AppPallete.bodyText),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppPallete.primary, size: 20),
            filled: true,
            fillColor: AppPallete.surface,
          ),
        ),
      ],
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38, height: 38,
        decoration: BoxDecoration(
          color: AppPallete.surface,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Icon(icon, color: AppPallete.bodyText, size: 20),
      ),
    );
  }
}