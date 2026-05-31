import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/session.dart';

class TrackOrderScreen extends StatefulWidget {
  const TrackOrderScreen({super.key});

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  Map<String, dynamic>? _order;
  bool _loading = true;
  bool _loadedOnce = false;

  static const _steps = [
    {'key': 'pending', 'label': 'قيد الانتظار', 'icon': Icons.hourglass_empty},
    {'key': 'confirmed', 'label': 'تم التأكيد', 'icon': Icons.check_circle},
    {'key': 'shipped', 'label': 'في الطريق', 'icon': Icons.local_shipping},
    {'key': 'delivered', 'label': 'تم التسليم', 'icon': Icons.home},
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loadedOnce) return;
    _loadedOnce = true;
    _load(ModalRoute.of(context)?.settings.arguments);
  }

  Future<void> _load(dynamic id) async {
    final orderId = int.tryParse(id?.toString() ?? '');
    if (orderId == null) {
      setState(() => _loading = false);
      return;
    }
    try {
      final data = await ApiService.getCustomerOrderTracking(orderId);
      setState(() => _order = data);
    } catch (_) {
      // فارغ
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  int get _currentStep {
    final status = _order?['status']?.toString() ?? 'pending';
    final idx = _steps.indexWhere((s) => s['key'] == status);
    return idx < 0 ? 0 : idx;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FC),
        appBar: AppBar(
          title: const Text('تتبّع الطلب'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _order == null
                ? const Center(child: Text('تعذّر تحميل الطلب'))
                : ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('طلب رقم #${_order!['id']}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text('الإجمالي: ${_order!['total_price']} ر.س',
                                style:
                                    const TextStyle(color: Color(0xFF585C61))),
                            if (_order!['delivery_eta'] != null) ...[
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.schedule,
                                      size: 18, color: Color(0xFFFF7A2C)),
                                  const SizedBox(width: 6),
                                  Text(
                                      'مدة الوصول المتوقعة: ${_order!['delivery_eta']} دقيقة',
                                      style: const TextStyle(
                                          color: Color(0xFF585C61))),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ...List.generate(_steps.length, (i) {
                        final done = i <= _currentStep;
                        return _buildStep(
                          _steps[i]['label'] as String,
                          _steps[i]['icon'] as IconData,
                          done,
                          isLast: i == _steps.length - 1,
                        );
                      }),
                      if ((_order?['status']?.toString() ?? '') == 'delivered')
                        _buildRatingButtons(),
                    ],
                  ),
      ),
    );
  }

  Widget _buildRatingButtons() {
    return Column(
      children: [
        const SizedBox(height: 12),
        const Divider(),
        const SizedBox(height: 12),
        const Text('قيّم تجربتك',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _showRatingDialog(isDriver: true),
                icon: const Icon(Icons.local_shipping),
                label: const Text('تقييم السائق'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _showRatingDialog(isDriver: false),
                icon: const Icon(Icons.shopping_bag),
                label: const Text('تقييم الطلب'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _showRatingDialog({required bool isDriver}) async {
    int rating = 5;
    final commentCtrl = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: StatefulBuilder(
          builder: (ctx, setLocal) => AlertDialog(
            title: Text(isDriver ? 'تقييم السائق' : 'تقييم الطلب'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    return IconButton(
                      onPressed: () => setLocal(() => rating = i + 1),
                      icon: Icon(
                        i < rating ? Icons.star : Icons.star_border,
                        color: const Color(0xFFFDD400),
                        size: 32,
                      ),
                    );
                  }),
                ),
                TextField(
                  controller: commentCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'تعليق (اختياري)',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('إرسال'),
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed != true) return;
    if (Session.userId == null || _order == null) return;

    final orderId = int.tryParse(_order!['id'].toString());
    try {
      if (isDriver) {
        final driverId = int.tryParse(_order!['driver_id']?.toString() ?? '');
        if (driverId == null) {
          _snack('لا يوجد سائق لهذا الطلب');
          return;
        }
        await ApiService.rateDriver(
          userId: Session.userId!,
          driverId: driverId,
          orderId: orderId,
          rating: rating,
          comment: commentCtrl.text.trim(),
        );
      } else {
        await ApiService.rateOrder(
          userId: Session.userId!,
          orderId: orderId!,
          rating: rating,
          comment: commentCtrl.text.trim(),
        );
      }
      _snack('شكراً، تم إرسال تقييمك');
    } catch (_) {
      _snack('تعذّر إرسال التقييم');
    }
  }

  void _snack(String m) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(m), behavior: SnackBarBehavior.floating));

  Widget _buildStep(String label, IconData icon, bool done,
      {bool isLast = false}) {
    final color = done ? const Color(0xFFFF7A2C) : Colors.grey.shade400;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: color,
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              if (!isLast)
                Expanded(
                    child: Container(width: 2, color: color.withOpacity(0.4))),
            ],
          ),
          const SizedBox(width: 16),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 24),
            child: Text(label,
                style: TextStyle(
                    fontWeight: done ? FontWeight.bold : FontWeight.normal,
                    color: done ? Colors.black87 : Colors.grey)),
          ),
        ],
      ),
    );
  }
}
