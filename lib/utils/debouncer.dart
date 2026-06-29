import 'dart:async';

/// أداة لتأخير تنفيذ دالة حتى يتوقف المستخدم عن الكتابة أو التفاعل.
class Debouncer {
  final int milliseconds;
  Timer? _timer;
  bool _isDisposed = false;

  Debouncer({this.milliseconds = 500});

  /// تنفيذ الدالة بعد انقضاء المدة المحددة (تُلغى المكالمات السابقة).
  void run(void Function() action) {
    if (_isDisposed) return;
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  /// إلغاء أي مؤقتات معلقة وتحرير الموارد.
  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    _timer = null;
  }

  /// إلغاء المؤقت الحالي دون تحرير الـ Debouncer نهائياً.
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }
}