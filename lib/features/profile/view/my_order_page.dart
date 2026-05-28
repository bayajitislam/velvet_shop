import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet/core/theme/app_pallete.dart';
import 'package:velvet/core/theme/app_text_style.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});
  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;

  final _tabs = ['All', 'Active', 'Completed', 'Cancelled'];

  final _orders = [
    _Order(
      id: '#VLV7842',
      date: 'May 20, 2026',
      total: 288.00,
      status: 'delivered',
      items: 2,
      imageUrl: 'https://picsum.photos/seed/ord1/200/200',
    ),
    _Order(
      id: '#VLV7831',
      date: 'May 15, 2026',
      total: 199.00,
      status: 'shipped',
      items: 1,
      imageUrl: 'https://picsum.photos/seed/ord2/200/200',
    ),
    _Order(
      id: '#VLV7820',
      date: 'May 10, 2026',
      total: 89.00,
      status: 'processing',
      items: 1,
      imageUrl: 'https://picsum.photos/seed/ord3/200/200',
    ),
    _Order(
      id: '#VLV7810',
      date: 'Apr 28, 2026',
      total: 350.00,
      status: 'cancelled',
      items: 3,
      imageUrl: 'https://picsum.photos/seed/ord4/200/200',
    ),
  ];

  List<_Order> _filtered(String tab) {
    if (tab == 'All') return _orders;
    if (tab == 'Active') {
      return _orders
          .where((o) => o.status == 'processing' || o.status == 'shipped')
          .toList();
    }
    if (tab == 'Completed') {
      return _orders.where((o) => o.status == 'delivered').toList();
    }
    return _orders.where((o) => o.status == 'cancelled').toList();
  }

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

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
        title: Text('My Orders', style: AppTextStyle.s16w6()),
        bottom: TabBar(
          controller: _tabCtrl,
          labelStyle: AppTextStyle.s12w5(color: AppPallete.primary),
          unselectedLabelStyle: AppTextStyle.s12w4(
            color: AppPallete.subTextColor,
          ),
          labelColor: AppPallete.primary,
          unselectedLabelColor: AppPallete.subTextColor,
          indicatorColor: AppPallete.primary,
          indicatorWeight: 2.5,
          tabs: _tabs.map((t) => Tab(text: t)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: _tabs.map((tab) {
          final orders = _filtered(tab);
          if (orders.isEmpty) {
            return Center(
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
                      Icons.receipt_long_outlined,
                      size: 36,
                      color: AppPallete.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('No orders yet', style: AppTextStyle.s16w6()),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            itemCount: orders.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _OrderCard(order: orders[i]),
          );
        }).toList(),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final _Order order;
  const _OrderCard({required this.order});

  Color _statusColor() {
    switch (order.status) {
      case 'delivered':
        return AppPallete.success;
      case 'shipped':
        return Colors.blue;
      case 'processing':
        return AppPallete.star;
      case 'cancelled':
        return AppPallete.error;
      default:
        return AppPallete.subTextColor;
    }
  }

  IconData _statusIcon() {
    switch (order.status) {
      case 'delivered':
        return Icons.check_circle_rounded;
      case 'shipped':
        return Icons.local_shipping_outlined;
      case 'processing':
        return Icons.pending_outlined;
      case 'cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppPallete.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppPallete.primary.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Product thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  order.imageUrl,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 64,
                    height: 64,
                    color: AppPallete.background,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.id, style: AppTextStyle.s14w6()),
                    const SizedBox(height: 4),
                    Text(
                      order.date,
                      style: AppTextStyle.s12w4(color: AppPallete.subTextColor),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${order.items} item${order.items > 1 ? 's' : ''}',
                      style: AppTextStyle.s12w4(color: AppPallete.extraAsh),
                    ),
                  ],
                ),
              ),
              Text(
                '\$${order.total.toStringAsFixed(2)}',
                style: AppTextStyle.s16w6(color: AppPallete.bodyText),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Divider(color: AppPallete.stroke, height: 1),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Status badge
              Row(
                children: [
                  Icon(_statusIcon(), size: 16, color: _statusColor()),
                  const SizedBox(width: 6),
                  Text(
                    order.status[0].toUpperCase() + order.status.substring(1),
                    style: AppTextStyle.s12w5(color: _statusColor()),
                  ),
                ],
              ),
              // Action button
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppPallete.background,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order.status == 'delivered' ? 'Reorder' : 'Track',
                    style: AppTextStyle.s12w5(color: AppPallete.primary),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Order {
  final String id, date, status, imageUrl;
  final double total;
  final int items;
  const _Order({
    required this.id,
    required this.date,
    required this.total,
    required this.status,
    required this.items,
    required this.imageUrl,
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
