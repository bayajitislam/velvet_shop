import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet/core/theme/app_pallete.dart';
import 'package:velvet/core/theme/app_text_style.dart';
import 'package:velvet/routes/routes_name.dart';

// ─────────────────────────────────────────────────────────
//  CheckoutPage — UI only
//
//  Sections:
//  1. Delivery Address
//  2. Payment Method
//  3. Order Summary (collapsed list)
//  4. Place Order CTA
// ─────────────────────────────────────────────────────────

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int _selectedAddress = 0;
  int _selectedPayment = 0;
  bool _orderSummaryExpanded = false;

  // Dummy addresses
  final _addresses = [
    _Address(
      label: 'Home',
      name: 'Devon Lane',
      detail: '2464 Royal Ln. Mesa, New Jersey 45463',
      phone: '+1 234 567 8900',
    ),
    _Address(
      label: 'Office',
      name: 'Devon Lane',
      detail: '3517 W. Gray St. Utica, Pennsylvania 57867',
      phone: '+1 234 567 8901',
    ),
  ];

  // Dummy payment methods
  final _payments = [
    _Payment(type: 'card', label: 'Visa', detail: '**** **** **** 4242'),
    _Payment(type: 'card', label: 'Mastercard', detail: '**** **** **** 8888'),
    _Payment(type: 'cash', label: 'Cash on Delivery', detail: 'Pay at door'),
  ];

  // Dummy order items
  final _orderItems = [
    _OrderItem(name: 'Elegant Pink Midi', size: 'M', qty: 1, price: 199.00),
    _OrderItem(name: 'Blend Formal Shirt', size: 'L', qty: 2, price: 89.00),
  ];

  double get _subtotal => _orderItems.fold(0, (s, i) => s + i.price * i.qty);
  double get _delivery => 0.0;
  double get _total => _subtotal + _delivery;

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
        title: Text('Checkout', style: AppTextStyle.s16w6()),
      ),

      body: Stack(
        children: [
          // ── Scrollable content ───────────────────────
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 120 + bottomPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── 1. Delivery address ──────────────────
                _SectionHeader(
                  title: 'Delivery Address',
                  action: 'Add new',
                  onAction: () {},
                ),
                const SizedBox(height: 12),
                ..._addresses.asMap().entries.map((e) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _AddressTile(
                      address: e.value,
                      selected: _selectedAddress == e.key,
                      onTap: () => setState(() => _selectedAddress = e.key),
                    ),
                  );
                }),

                const SizedBox(height: 20),

                // ── 2. Payment method ────────────────────
                _SectionHeader(
                  title: 'Payment Method',
                  action: 'Add card',
                  onAction: () {},
                ),
                const SizedBox(height: 12),
                ..._payments.asMap().entries.map((e) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _PaymentTile(
                      payment: e.value,
                      selected: _selectedPayment == e.key,
                      onTap: () => setState(() => _selectedPayment = e.key),
                    ),
                  );
                }),

                const SizedBox(height: 20),

                // ── 3. Order summary (expandable) ────────
                GestureDetector(
                  onTap: () => setState(
                    () => _orderSummaryExpanded = !_orderSummaryExpanded,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Order Summary', style: AppTextStyle.s14w6()),
                      Row(
                        children: [
                          Text(
                            '${_orderItems.length} items',
                            style: AppTextStyle.s12w4(
                              color: AppPallete.subTextColor,
                            ),
                          ),
                          const SizedBox(width: 4),
                          AnimatedRotation(
                            turns: _orderSummaryExpanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 250),
                            child: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: AppPallete.subTextColor,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 250),
                  crossFadeState: _orderSummaryExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: const SizedBox.shrink(),
                  secondChild: Column(
                    children: _orderItems
                        .map((item) => _OrderItemTile(item: item))
                        .toList(),
                  ),
                ),

                const SizedBox(height: 16),

                // ── Price breakdown ──────────────────────
                _PriceCard(
                  subtotal: _subtotal,
                  delivery: _delivery,
                  total: _total,
                ),
              ],
            ),
          ),

          // ── Fixed bottom CTA ─────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _PlaceOrderBar(
              total: _total,
              bottomPadding: bottomPadding,
              onPlaceOrder: () => Get.offNamed(RoutesName.orderSuccess),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Address Tile
// ─────────────────────────────────────────────────────────

class _AddressTile extends StatelessWidget {
  final _Address address;
  final bool selected;
  final VoidCallback onTap;

  const _AddressTile({
    required this.address,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppPallete.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppPallete.primary : AppPallete.border,
            width: selected ? 1.8 : 1.0,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppPallete.primary.withValues(alpha: 0.10),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Radio dot
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppPallete.primary : AppPallete.border,
                  width: 2,
                ),
                color: selected ? AppPallete.primary : Colors.transparent,
              ),
              child: selected
                  ? const Icon(Icons.check, size: 12, color: AppPallete.white)
                  : null,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        address.name,
                        style: AppTextStyle.s14w6().copyWith(
                          color: AppPallete.bodyText,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppPallete.primary.withValues(alpha: 0.1)
                              : AppPallete.background,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          address.label,
                          style: AppTextStyle.s10w4(
                            color: selected
                                ? AppPallete.primary
                                : AppPallete.subTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address.detail,
                    style: AppTextStyle.s12w4(color: AppPallete.subTextColor),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    address.phone,
                    style: AppTextStyle.s12w4(color: AppPallete.extraAsh),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Payment Tile
// ─────────────────────────────────────────────────────────

class _PaymentTile extends StatelessWidget {
  final _Payment payment;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentTile({
    required this.payment,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCash = payment.type == 'cash';

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppPallete.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppPallete.primary : AppPallete.border,
            width: selected ? 1.8 : 1.0,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppPallete.primary.withValues(alpha: 0.10),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: selected
                    ? AppPallete.primary.withValues(alpha: 0.08)
                    : AppPallete.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isCash ? Icons.payments_outlined : Icons.credit_card_outlined,
                color: selected ? AppPallete.primary : AppPallete.extraAsh,
                size: 20,
              ),
            ),

            const SizedBox(width: 12),

            // Label + detail
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    payment.label,
                    style: AppTextStyle.s14w6().copyWith(
                      color: AppPallete.bodyText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    payment.detail,
                    style: AppTextStyle.s12w4(color: AppPallete.subTextColor),
                  ),
                ],
              ),
            ),

            // Selected check
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: selected ? 1.0 : 0.0,
              child: Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: AppPallete.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 14,
                  color: AppPallete.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Order Item Tile
// ─────────────────────────────────────────────────────────

class _OrderItemTile extends StatelessWidget {
  final _OrderItem item;
  const _OrderItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppPallete.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppPallete.stroke),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: AppTextStyle.s12w5()),
                const SizedBox(height: 2),
                Text(
                  'Size: ${item.size}  ×${item.qty}',
                  style: AppTextStyle.s10w4(color: AppPallete.subTextColor),
                ),
              ],
            ),
          ),
          Text(
            '\$${(item.price * item.qty).toStringAsFixed(2)}',
            style: AppTextStyle.s14w6(color: AppPallete.bodyText),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Price Breakdown Card
// ─────────────────────────────────────────────────────────

class _PriceCard extends StatelessWidget {
  final double subtotal;
  final double delivery;
  final double total;

  const _PriceCard({
    required this.subtotal,
    required this.delivery,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPallete.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPallete.stroke),
      ),
      child: Column(
        children: [
          _Row(label: 'Subtotal', value: '\$${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _Row(
            label: 'Delivery',
            value: delivery == 0 ? 'Free' : '\$${delivery.toStringAsFixed(2)}',
            valueColor: delivery == 0 ? AppPallete.success : null,
          ),
          const SizedBox(height: 12),
          Divider(color: AppPallete.stroke, height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: AppTextStyle.s16w6()),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: AppTextStyle.s20w6(color: AppPallete.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _Row({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyle.s14w4(color: AppPallete.subTextColor)),
        Text(
          value,
          style: AppTextStyle.s14w6(color: valueColor ?? AppPallete.bodyText),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Place Order Bottom Bar
// ─────────────────────────────────────────────────────────

class _PlaceOrderBar extends StatelessWidget {
  final double total;
  final double bottomPadding;
  final VoidCallback onPlaceOrder;

  const _PlaceOrderBar({
    required this.total,
    required this.bottomPadding,
    required this.onPlaceOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 14, 20, bottomPadding + 14),
      decoration: BoxDecoration(
        color: AppPallete.surface,
        border: Border(top: BorderSide(color: AppPallete.stroke, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Total amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Total',
                style: AppTextStyle.s12w4(color: AppPallete.subTextColor),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: AppTextStyle.s20w6(color: AppPallete.primary),
              ),
            ],
          ),

          const SizedBox(width: 16),

          // Place Order button
          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: onPlaceOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPallete.bodyText,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: Text('Place Order', style: AppTextStyle.button()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Section Header
// ─────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final String action;
  final VoidCallback onAction;

  const _SectionHeader({
    required this.title,
    required this.action,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyle.s14w6().copyWith(color: AppPallete.bodyText),
        ),
        GestureDetector(
          onTap: onAction,
          child: Text(
            action,
            style: AppTextStyle.s12w5(color: AppPallete.indigoNavy),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Circle AppBar Button
// ─────────────────────────────────────────────────────────

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
}

// ─────────────────────────────────────────────────────────
//  Data classes (dummy models for UI only)
// ─────────────────────────────────────────────────────────

class _Address {
  final String label;
  final String name;
  final String detail;
  final String phone;
  const _Address({
    required this.label,
    required this.name,
    required this.detail,
    required this.phone,
  });
}

class _Payment {
  final String type;
  final String label;
  final String detail;
  const _Payment({
    required this.type,
    required this.label,
    required this.detail,
  });
}

class _OrderItem {
  final String name;
  final String size;
  final int qty;
  final double price;
  const _OrderItem({
    required this.name,
    required this.size,
    required this.qty,
    required this.price,
  });
}
