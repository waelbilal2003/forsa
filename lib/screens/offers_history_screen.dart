import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../services/api_service.dart';
import '../services/session.dart';

class OffersHistoryScreen extends StatefulWidget {
  const OffersHistoryScreen({super.key});

  @override
  State<OffersHistoryScreen> createState() => _OffersHistoryScreenState();
}

class _OffersHistoryScreenState extends State<OffersHistoryScreen> {
  List<dynamic> _offers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (Session.storeId == null) {
      setState(() => _loading = false);
      return;
    }
    setState(() => _loading = true);
    try {
      final data = await ApiService.getMerchantOffers(Session.storeId!);
      setState(() => _offers = data);
    } catch (_) {
      // قائمة فارغة عند الخطأ
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _snack(String m) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(m), behavior: SnackBarBehavior.floating));

  Future<void> _addStock(int offerId) async {
    final ctrl = TextEditingController(text: '50');
    final amount = await showDialog<int>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('زيادة الكمية'),
          content: TextField(
            controller: ctrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'الكمية المضافة',
              hintText: 'مثال: 50',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                final v = int.tryParse(ctrl.text.trim());
                if (v == null || v <= 0) return;
                Navigator.pop(ctx, v);
              },
              child: const Text('إضافة'),
            ),
          ],
        ),
      ),
    );
    if (amount == null) return;
    try {
      await ApiService.addOfferStock(offerId, amount);
      _snack('تمت زيادة الكمية');
      _load();
    } catch (e) {
      _snack(e is ApiException ? e.message : 'تعذّرت زيادة الكمية');
    }
  }

  Future<void> _reactivate(int offerId) async {
    try {
      await ApiService.reactivateOffer(offerId, stock: 100);
      _snack('تمت إعادة تفعيل العرض');
      _load();
    } catch (e) {
      _snack(e is ApiException ? e.message : 'تعذّرت إعادة التفعيل');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.surfaceContainer,
        appBar: AppBar(
          title: const Text('سجل العروض'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _offers.isEmpty
                ? const Center(child: Text('لا توجد عروض بعد'))
                : RefreshIndicator(
                    onRefresh: _load,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _offers.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) => _offerCard(_offers[i]),
                    ),
                  ),
      ),
    );
  }

  Widget _offerCard(dynamic offer) {
    final id = int.tryParse(offer['id'].toString()) ?? 0;
    final expired = (offer['is_expired']?.toString() == '1');
    final stock = offer['stock']?.toString() ?? '—';
    final title = offer['title']?.toString() ??
        offer['product_name']?.toString() ??
        'عرض';
    final discount = offer['discount_percentage']?.toString() ?? '0';
    final endDate = offer['end_date']?.toString() ?? '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
    
        color: expired ? const Color(0xFFF1F1F4) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: expired ? Border.all(color: const Color(0xFFE0E0E6)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(title,
                    style: AppTypography.titleMedium.copyWith(
                        color: expired ? Colors.grey.shade600 : null)),
              ),
              Chip(
                label: Text(expired ? 'منتهي' : 'نشط'),
                backgroundColor: expired
                    ? const Color(0xFFE0E0E6)
                    : AppColors.primaryContainer,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('الخصم: $discount%', style: AppTypography.bodySmall),
          Text('الكمية المتبقية: $stock', style: AppTypography.bodySmall),
          if (endDate.isNotEmpty)
            Text('ينتهي: $endDate', style: AppTypography.bodySmall),
          if (expired) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _addStock(id),
                    icon: const Icon(Icons.add_box_outlined),
                    label: const Text('زيادة الكمية'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryFixed,
                        foregroundColor: AppColors.onPrimaryFixed),
                    onPressed: () => _reactivate(id),
                    icon: const Icon(Icons.refresh),
                    label: const Text('إعادة تفعيل'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
