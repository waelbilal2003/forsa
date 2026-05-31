import 'package:flutter/material.dart';

class KineticCard extends StatelessWidget {
  final Widget? image;
  final String? title;
  final String? subtitle;
  final Widget? badge;
  final List<Widget>? actions;
  final VoidCallback? onTap;
  final bool isUrgent;
  final bool isAsymmetric;
  final double? customHeight;
  final Color? borderColor;
  final Widget? trailing;
  
  const KineticCard({
    super.key,
    this.image,
    this.title,
    this.subtitle,
    this.badge,
    this.actions,
    this.onTap,
    this.isUrgent = false,
    this.isAsymmetric = false,
    this.customHeight,
    this.borderColor,
    this.trailing,
  });
  
  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      height: customHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isUrgent
            ? Border(
                left: BorderSide(
                  color: borderColor ?? const Color(0xFF9B3F00),
                  width: 4,
                ),
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (image != null) _buildImageSection(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (title != null)
                                Text(
                                  title!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF2B2F33),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              if (subtitle != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  subtitle!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF585C61),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (trailing != null) trailing!,
                      ],
                    ),
                    if (actions != null && actions!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: actions!,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    
    if (isAsymmetric) {
      card = Transform.rotate(
        angle: 0.02,
        child: card,
      );
    }
    
    return card;
  }
  
  Widget _buildImageSection() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: SizedBox(
            width: double.infinity,
            height: 140,
            child: image,
          ),
        ),
        if (badge != null)
          Positioned(
            bottom: 8,
            right: 8,
            child: badge!,
          ),
      ],
    );
  }
}

class DealBadge extends StatelessWidget {
  final String text;
  final bool isPercentage;
  
  const DealBadge({
    super.key,
    required this.text,
    this.isPercentage = true,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFDD400),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFDD400).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        isPercentage ? 'خصم $text%' : text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: Color(0xFF433700),
        ),
      ),
    );
  }
}