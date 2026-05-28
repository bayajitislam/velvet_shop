import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet/core/theme/app_pallete.dart';
import 'package:velvet/core/theme/app_text_style.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});
  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final _notifications = [
    _Notif(
      icon: Icons.local_shipping_outlined,
      color: Colors.blue,
      title: 'Order Shipped!',
      body: 'Your order #VLV7831 has been shipped and is on its way.',
      time: '2 min ago',
      isRead: false,
    ),
    _Notif(
      icon: Icons.discount_outlined,
      color: AppPallete.primary,
      title: 'Special Offer 🎉',
      body: 'Get 20% off on all dresses this weekend only!',
      time: '1 hr ago',
      isRead: false,
    ),
    _Notif(
      icon: Icons.check_circle_outlined,
      color: AppPallete.success,
      title: 'Order Delivered',
      body: 'Your order #VLV7820 has been delivered successfully.',
      time: '2 days ago',
      isRead: true,
    ),
    _Notif(
      icon: Icons.favorite_border_rounded,
      color: AppPallete.primary,
      title: 'Back in Stock',
      body: 'An item from your wishlist is back in stock. Grab it now!',
      time: '3 days ago',
      isRead: true,
    ),
    _Notif(
      icon: Icons.star_border_rounded,
      color: AppPallete.star,
      title: 'Rate your order',
      body: 'How was your recent purchase? Share your experience.',
      time: '5 days ago',
      isRead: true,
    ),
  ];

  void _markAllRead() {
    setState(() {
      for (final n in _notifications) {
        n.isRead = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final unread = _notifications.where((n) => !n.isRead).length;

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
        title: Text('Notifications', style: AppTextStyle.s16w6()),
        actions: [
          if (unread > 0)
            TextButton(
              onPressed: _markAllRead,
              child: Text(
                'Mark all read',
                style: AppTextStyle.s12w5(color: AppPallete.primary),
              ),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppPallete.background,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.notifications_none_rounded,
                      size: 36,
                      color: AppPallete.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('No notifications', style: AppTextStyle.s16w6()),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: _notifications.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final n = _notifications[i];
                return GestureDetector(
                  onTap: () => setState(() => n.isRead = true),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: n.isRead
                          ? AppPallete.surface
                          : AppPallete.primary.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: n.isRead
                            ? AppPallete.stroke
                            : AppPallete.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon circle
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: n.color.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(n.icon, color: n.color, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      n.title,
                                      style: AppTextStyle.s14w6().copyWith(
                                        color: AppPallete.bodyText,
                                      ),
                                    ),
                                  ),
                                  if (!n.isRead)
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: AppPallete.primary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                n.body,
                                style: AppTextStyle.s12w4(
                                  color: AppPallete.subTextColor,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                n.time,
                                style: AppTextStyle.s10w4(
                                  color: AppPallete.extraAsh,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _Notif {
  final IconData icon;
  final Color color;
  final String title, body, time;
  bool isRead;
  _Notif({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
    required this.time,
    required this.isRead,
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
