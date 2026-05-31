import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../services/session.dart';

class AccountScreen extends StatelessWidget {
  final ValueChanged<int> onNavigate;

  const AccountScreen({super.key, required this.onNavigate});

  void _logout(BuildContext context) {
    Session.clear();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 12),
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: AppColors.primaryContainer,
                child: Icon(Icons.person,
                    size: 48, color: AppColors.onPrimaryContainer),
              ),
              const SizedBox(height: 12),
              Text(Session.name ?? 'سائق', style: AppTypography.titleLarge),
              const SizedBox(height: 4),
              Text(Session.email ?? '', style: AppTypography.bodySmall),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _menuItem(Icons.account_balance_wallet, 'محفظتي',
                  onTap: () => onNavigate(1)), // محفظتي -> index 1
              const Divider(height: 1),
              _menuItem(Icons.list_alt, 'طلباتي',
                  onTap: () => onNavigate(0)), // طلباتي -> index 0
              const Divider(height: 1),
              _menuItem(Icons.support_agent, 'المساعدة والدعم'),
              const Divider(height: 1),
              _menuItem(Icons.group_add, 'دعوة صديق'),
            ],
          ),
        ),
        const SizedBox(height: 24),
        OutlinedButton(
          onPressed: () => _logout(context),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColors.error),
            foregroundColor: AppColors.error,
            minimumSize: const Size(double.infinity, 56),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout),
              SizedBox(width: 8),
              Text('تسجيل الخروج',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _menuItem(IconData icon, String label, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.onSurfaceVariant),
      title: Text(label, style: AppTypography.bodyLarge),
      trailing: const Icon(Icons.chevron_left, size: 20),
      onTap: onTap ?? () {},
    );
  }
}