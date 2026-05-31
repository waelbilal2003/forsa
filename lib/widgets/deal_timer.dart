import 'dart:async';
import 'package:flutter/material.dart';

class DealTimer extends StatefulWidget {
  final DateTime expiryDate;
  final VoidCallback? onExpired;
  final bool showPulse;
  
  const DealTimer({
    super.key,
    required this.expiryDate,
    this.onExpired,
    this.showPulse = true,
  });
  
  @override
  State<DealTimer> createState() => _DealTimerState();
}

class _DealTimerState extends State<DealTimer> with SingleTickerProviderStateMixin {
  late Timer _timer;
  Duration _remaining = Duration.zero;
  late AnimationController _pulseController;
  bool _isExpired = false;
  
  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateRemaining();
    });
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }
  
  void _updateRemaining() {
    final now = DateTime.now();
    final remaining = widget.expiryDate.difference(now);
    
    setState(() {
      if (remaining.isNegative) {
        _remaining = Duration.zero;
        if (!_isExpired) {
          _isExpired = true;
          widget.onExpired?.call();
        }
        _timer.cancel();
      } else {
        _remaining = remaining;
        _isExpired = false;
      }
    });
  }
  
  @override
  void dispose() {
    _timer.cancel();
    _pulseController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isExpired) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF95630).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.hourglass_empty,
              size: 16,
              color: Color(0xFFB92902),
            ),
            const SizedBox(width: 6),
            const Text(
              'انتهى العرض',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Color(0xFFB92902),
              ),
            ),
          ],
        ),
      );
    }
    
    final hours = _remaining.inHours;
    final minutes = _remaining.inMinutes.remainder(60);
    final seconds = _remaining.inSeconds.remainder(60);
    final isExpiringSoon = _remaining.inHours < 2;
    
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: isExpiringSoon && widget.showPulse
                ? LinearGradient(
                    colors: [
                      const Color(0xFF9B3F00).withOpacity(0.9),
                      const Color(0xFF883700).withOpacity(0.9),
                    ],
                  )
                : const LinearGradient(
                    colors: [Color(0xFF9B3F00), Color(0xFF883700)],
                  ),
            borderRadius: BorderRadius.circular(100),
            boxShadow: isExpiringSoon && widget.showPulse
                ? [
                    BoxShadow(
                      color: const Color(0xFF9B3F00).withOpacity(0.3 + _pulseController.value * 0.3),
                      blurRadius: 12 + _pulseController.value * 8,
                      spreadRadius: 0,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: const Color(0xFF9B3F00).withOpacity(0.2),
                      blurRadius: 8,
                    ),
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.timer,
                size: 18,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}