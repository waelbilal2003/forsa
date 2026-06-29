import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../services/api_service.dart';
import '../services/session.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  String _selectedUnit = 'قطعة';
  bool _loading = false;

  final List<String> _units = [
    'قطعة',
    'كيلو',
    'غرام',
    'لتر',
    'مل',
    'متر',
    'سم',
    'علبة',
    'صندوق',
    'طرد',
  ];

  Future<void> _saveProduct() async {
    if (Session.storeId == null) {
      _snack('لا يوجد متجر مرتبط بحسابك');
      return;
    }

    final name = _nameController.text.trim();
    final quantity = int.tryParse(_quantityController.text.trim());
    final price = double.tryParse(_priceController.text.trim());

    if (name.isEmpty) {
      _snack('أدخل اسم المنتج');
      return;
    }
    if (quantity == null || quantity <= 0) {
      _snack('أدخل كمية صحيحة');
      return;
    }
    if (price == null || price <= 0) {
      _snack('أدخل سعراً صحيحاً');
      return;
    }

    setState(() => _loading = true);

    try {
      await ApiService.addProductToInventory(
        storeId: Session.storeId!,
        name: name,
        quantity: quantity,
        unit: _selectedUnit,
        price: price,
      );
      if (!mounted) return;
      _snack('تم إضافة المنتج للمخزون بنجاح');
      Navigator.pop(context);
    } catch (e) {
      _snack(e is ApiException ? e.message : 'تعذّرت الإضافة');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إضافة منتج للمخزون'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('اسم المنتج', _nameController),
              const SizedBox(height: 16),
              _buildTextField('الكمية', _quantityController,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              _buildUnitDropdown(),
              const SizedBox(height: 16),
              _buildTextField('سعر الوحدة (ل.س)', _priceController,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _saveProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryFixed,
                    foregroundColor: AppColors.onPrimaryFixed,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _loading
                      ? const CircularProgressIndicator()
                      : const Text('إضافة للمخزون',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.labelLarge),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType ?? TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
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
            borderRadius: BorderRadius.circular(12),
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
}