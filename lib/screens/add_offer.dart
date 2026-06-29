import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../services/api_service.dart';
import '../services/session.dart';

class AddOfferScreen extends StatefulWidget {
  const AddOfferScreen({super.key});

  @override
  State<AddOfferScreen> createState() => _AddOfferScreenState();
}

class _AddOfferScreenState extends State<AddOfferScreen> {
  final _productName = TextEditingController();
  final _description = TextEditingController();
  final _originalPrice = TextEditingController();
  final _offerPrice = TextEditingController();
  final _imageUrl = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  bool _loading = false;

  String _selectedUnit = 'قطعة';
  final List<String> _units = [
    'قطعة', 'كيلو', 'غرام', 'لتر', 'مل', 'متر', 'سم', 'علبة', 'صندوق', 'طرد'
  ];

  @override
  void dispose() {
    for (final c in [
      _productName,
      _description,
      _originalPrice,
      _offerPrice,
      _imageUrl
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _snack(String m) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(m), behavior: SnackBarBehavior.floating));

  Future<void> _publish() async {
    if (Session.storeId == null) {
      _snack('لا يوجد متجر مرتبط بحسابك');
      return;
    }
    final orig = double.tryParse(_originalPrice.text);
    final offer = double.tryParse(_offerPrice.text);
    if (_productName.text.trim().isEmpty) {
      _snack('أدخل اسم المنتج');
      return;
    }
    if (orig == null || offer == null || offer > orig) {
      _snack('تحقّق من الأسعار (سعر العرض أقل من الأصلي)');
      return;
    }
    if (_startDate == null || _endDate == null) {
      _snack('حدّد مدة العرض (تاريخ البداية والنهاية)');
      return;
    }
    if (_endDate!.isBefore(_startDate!)) {
      _snack('تاريخ النهاية يجب أن يكون بعد البداية');
      return;
    }

    setState(() => _loading = true);
    try {
      await ApiService.addOffer({
        'store_id': Session.storeId,
        'product_name': _productName.text.trim(),
        'description': _description.text.trim(),
        'original_price': orig,
        'offer_price': offer,
        'image_url': _imageUrl.text.trim(),
        'start_date': _startDate!.toIso8601String(),
        'end_date': _endDate!.toIso8601String(),
        'unit': _selectedUnit,
      });
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/publish_success');
    } on ApiException catch (e) {
      _snack(e.message);
    } catch (_) {
      _snack('تعذّر نشر العرض');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.surfaceContainer,
        appBar: AppBar(
          title: const Text('إضافة عرض جديد'),
          centerTitle: false,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_forward),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _field('اسم المنتج', _productName,
                  hint: 'مثال: وجبة التوفير العائلية'),
              const SizedBox(height: 16),
              _buildUnitDropdown(),
              const SizedBox(height: 16),
              _field('وصف العرض', _description,
                  hint: 'اكتب تفاصيل تجذب العملاء...', lines: 3),
              Row(
                children: [
                  Expanded(
                    child: _field('السعر الأصلي', _originalPrice,
                        hint: '0', number: true),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _field('سعر العرض', _offerPrice,
                        hint: '0', number: true),
                  ),
                ],
              ),
              _field('رابط صورة (اختياري)', _imageUrl, hint: 'https://...'),
              const SizedBox(height: 4),
              Text('مدة العرض', style: AppTypography.labelLarge),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _dateTile(
                      label: 'تاريخ البداية',
                      value: _startDate,
                      onPick: (d) => setState(() => _startDate = d),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _dateTile(
                      label: 'تاريخ النهاية',
                      value: _endDate,
                      onPick: (d) => setState(() => _endDate = d),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: _loading ? null : _publish,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryFixed,
                  foregroundColor: AppColors.onPrimaryFixed,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: _loading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.5, color: Colors.black))
                    : Text('نشر العرض الآن', style: AppTypography.titleMedium),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnitDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('وحدة القياس', style: AppTypography.labelLarge),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedUnit,
              isExpanded: true,
              items: _units.map((unit) {
                return DropdownMenuItem(value: unit, child: Text(unit));
              }).toList(),
              onChanged: (value) {
                if (value != null) setState(() => _selectedUnit = value);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _dateTile({
    required String label,
    required DateTime? value,
    required ValueChanged<DateTime> onPick,
  }) {
    final text = value == null
        ? 'اختر التاريخ'
        : '${value.year}/${value.month.toString().padLeft(2, '0')}/${value.day.toString().padLeft(2, '0')}';
    return InkWell(
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? now,
          firstDate: DateTime(now.year - 1),
          lastDate: DateTime(now.year + 5),
        );
        if (picked != null) onPick(picked);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTypography.bodySmall),
                  const SizedBox(height: 2),
                  Text(text,
                      style: TextStyle(
                          color: value == null ? Colors.grey : Colors.black87,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController c,
      {String? hint, bool number = false, int lines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.labelLarge),
          const SizedBox(height: 8),
          TextField(
            controller: c,
            maxLines: lines,
            keyboardType: number
                ? const TextInputType.numberWithOptions(decimal: true)
                : TextInputType.text,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}