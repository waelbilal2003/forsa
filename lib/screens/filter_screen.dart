// lib/screens/filter_screen.dart
// شاشة تصفية بسيطة — تُعيد خيار التصفية للشاشة السابقة.
import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});
  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  double _maxPrice = 500;
  String _sort = 'newest';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FC),
        appBar: AppBar(
          title: const Text('تصفية النتائج'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('السعر الأقصى',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              value: _maxPrice,
              min: 0,
              max: 2000,
              divisions: 20,
              label: '${_maxPrice.round()} ل.س',
              activeColor: const Color(0xFFFF7A2C),
              onChanged: (v) => setState(() => _maxPrice = v),
            ),
            const SizedBox(height: 16),
            const Text('الترتيب حسب',
                style: TextStyle(fontWeight: FontWeight.bold)),
            RadioListTile<String>(
              value: 'newest',
              groupValue: _sort,
              title: const Text('الأحدث'),
              onChanged: (v) => setState(() => _sort = v!),
            ),
            RadioListTile<String>(
              value: 'cheapest',
              groupValue: _sort,
              title: const Text('الأرخص'),
              onChanged: (v) => setState(() => _sort = v!),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context,
                  {'maxPrice': _maxPrice, 'sort': _sort}),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7A2C),
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('تطبيق'),
            ),
          ],
        ),
      ),
    );
  }
}
