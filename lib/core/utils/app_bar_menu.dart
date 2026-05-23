import 'package:flutter/material.dart';
import 'package:velvet/core/theme/app_pallete.dart';

class AppBarMenu {
  AppBarMenu._();

  static void show(
    BuildContext context, {
    VoidCallback? onEdit,
    VoidCallback? onDelete,
    List<AppBarMenuItem>? extraItems, // custom extra items
  }) {
    final List<PopupMenuEntry<String>> items = [];

    if (onEdit != null) {
      items.add(
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_outlined, color: AppPallete.accent, size: 20),
              const SizedBox(width: 10),
              const Text('Edit'),
            ],
          ),
        ),
      );
    }

    if (onDelete != null) {
      if (items.isNotEmpty) items.add(const PopupMenuDivider());
      items.add(
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              const Icon(Icons.delete_outline, color: Colors.red, size: 20),
              const SizedBox(width: 10),
              const Text('Delete', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      );
    }

    // extra custom items
    if (extraItems != null) {
      for (final item in extraItems) {
        if (items.isNotEmpty) items.add(const PopupMenuDivider());
        items.add(
          PopupMenuItem(
            value: item.value,
            child: Row(
              children: [
                Icon(
                  item.icon,
                  color: item.color ?? AppPallete.primary,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(item.label, style: TextStyle(color: item.color)),
              ],
            ),
          ),
        );
      }
    }

    showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(1000, kToolbarHeight, 16, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 4,
      items: items,
    ).then((value) {
      if (value == 'edit') onEdit?.call();
      if (value == 'delete') onDelete?.call();
      if (extraItems != null) {
        final matched = extraItems.firstWhere(
          (e) => e.value == value,
          orElse: () => AppBarMenuItem.empty(),
        );
        matched.onTap?.call();
      }
    });
  }
}

// custom item model
class AppBarMenuItem {
  final String value;
  final String label;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;

  const AppBarMenuItem({
    required this.value,
    required this.label,
    required this.icon,
    this.color,
    this.onTap,
  });

  factory AppBarMenuItem.empty() =>
      const AppBarMenuItem(value: '', label: '', icon: Icons.circle);
}
