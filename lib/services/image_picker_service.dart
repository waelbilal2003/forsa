// lib/services/image_picker_service.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

/// خدمة اختيار الصور من المعرض أو الكاميرا
class ImagePickerService {
  /// اختيار صورة من المعرض
  static Future<File?> pickImageFromGallery() async {
    return _pickImage(ImageSource.gallery);
  }

  /// التقاط صورة من الكاميرا
  static Future<File?> pickImageFromCamera() async {
    return _pickImage(ImageSource.camera);
  }

  /// دالة داخلية للتعامل مع اختيار الصورة
  static Future<File?> _pickImage(ImageSource source) async {
    // التحقق من الأذونات حسب النظام
    if (source == ImageSource.camera) {
      // طلب إذن الكاميرا
      PermissionStatus status = await Permission.camera.request();
      if (status != PermissionStatus.granted) {
        return null;
      }
    } else {
      // طلب إذن المعرض
      // Android 13+ يستخدم READ_MEDIA_IMAGES
      PermissionStatus status = await Permission.photos.request();
      if (status != PermissionStatus.granted) {
        // للإصدارات الأقدم من Android 13
        status = await Permission.storage.request();
        if (status != PermissionStatus.granted) {
          return null;
        }
      }
    }

    // اختيار الصورة باستخدام ImagePicker
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 1024,    // تقليل حجم الصورة لتوفير المساحة
      maxHeight: 1024,
      imageQuality: 85,  // جودة متوسطة
    );

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  /// دالة عرض حوار لاختيار المصدر (معرض أو كاميرا)
  static Future<File?> showImageSourceDialog(BuildContext context) async {
    // عرض الحوار وانتظار اختيار المستخدم (المصدر)
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      barrierDismissible: true,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('اختر مصدر الصورة'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('المعرض'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('الكاميرا'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('إلغاء'),
            ),
          ],
        ),
      ),
    );

    // إذا لم يختر المستخدم مصدراً، نعيد null
    if (source == null) return null;

    // اختيار الصورة حسب المصدر
    if (source == ImageSource.gallery) {
      return await pickImageFromGallery();
    } else {
      return await pickImageFromCamera();
    }
  }
}