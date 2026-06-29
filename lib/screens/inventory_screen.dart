import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../services/api_service.dart';
import '../services/session.dart';
import 'add_product_screen.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  List<dynamic> _products = [];
  bool _loading = true;
  String? _error;
  final int lowStockThreshold = 5;

  @override
  void initState() {
    super.initState();
    _loadInventory();
  }

  Future<void> _loadInventory() async {
    if (Session.storeId == null) {
      setState(() {
        _loading = false;
        _error = 'لا يوجد متجر مرتبط بحسابك';
      });
      return;
    }
    setState(() => _loading = true);
    try {
      final data = await ApiService.getInventory(Session.storeId!);
      setState(() {
        _products = data;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = 'تعذّر تحميل المخزون: ${e.toString()}';
        _loading = false;
      });
    }
  }

  Future<void> _addStock(int productId, int currentStock) async {
    final controller = TextEditingController(text: '1');
    final amount = await showDialog<int>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('زيادة المخزون'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'الكمية المضافة',
              hintText: 'أدخل عدد الوحدات',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                final v = int.tryParse(controller.text.trim());
                if (v == null || v <= 0) return;
                Navigator.pop(ctx, v);
              },
              child: const Text('إضافة'),
            ),
          ],
        ),
      ),
    );
    if (amount == null || amount <= 0) return;
    try {
      await ApiService.updateInventory(
        productId: productId,
        quantityAdded: amount,
        storeId: Session.storeId,
      );
      _snack('تمت إضافة $amount وحدة');
      _loadInventory();
    } catch (e) {
      _snack('فشل التحديث: ${e.toString()}');
    }
  }

  Future<void> _toggleActivation(int productId, bool isActive) async {
    try {
      await ApiService.toggleProductActivation(productId, !isActive);
      _snack(isActive ? 'تم إلغاء تفعيل المنتج' : 'تم تفعيل المنتج');
      _loadInventory();
    } catch (e) {
      _snack('تعذّر تغيير الحالة: ${e.toString()}');
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
        backgroundColor: AppColors.surfaceContainer,
        appBar: AppBar(
          title: const Text('المخزون'),
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddProductScreen()),
              ).then((_) => _loadInventory()),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadInventory,
            ),
          ],
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 60, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(_error!),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadInventory,
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  )
                : _products.isEmpty
                    ? const Center(child: Text('لا توجد منتجات في المخزون'))
                    : RefreshIndicator(
                        onRefresh: _loadInventory,
                        child: ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: _products.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, i) =>
                              _buildProductCard(_products[i]),
                        ),
                      ),
      ),
    );
  }

  Widget _buildProductCard(dynamic product) {
    final id = product['product_id'] ?? product['id'] ?? 0;
    final name = product['name'] ?? 'منتج';
    final quantity = product['quantity'] ?? 0;
    final unit = product['unit'] ?? 'قطعة';
    final price = product['price'] ?? 0;
    final isActive = product['is_active'] ?? product['active'] ?? false;
    final isLowStock = quantity <= lowStockThreshold && quantity > 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isLowStock ? Border.all(color: Colors.orange, width: 2) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: AppTypography.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isLowStock)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '⚠️ الكمية منخفضة',
                    style: TextStyle(
                      color: Colors.orange.shade800,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('الكمية: $quantity $unit', style: AppTypography.bodyMedium),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                onPressed: () => _addStock(id, quantity),
                tooltip: 'زيادة المخزون',
              ),
            ],
          ),
          Text('السعر: $price ل.س', style: AppTypography.bodyMedium),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isActive ? '✅ مفعل' : '❌ غير مفعل',
                style: AppTypography.bodySmall.copyWith(
                  color: isActive ? Colors.green : Colors.red,
                ),
              ),
              Switch(
                value: isActive,
                onChanged: (value) => _toggleActivation(id, isActive),
                activeColor: AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}