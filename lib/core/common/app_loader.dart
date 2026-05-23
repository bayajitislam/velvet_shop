import 'package:flutter/material.dart';
import 'package:velvet/core/theme/app_pallete.dart';

class AppLoader extends StatelessWidget {
  final Color color;
  const AppLoader({super.key, this.color = AppPallete.accent});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator.adaptive(
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
