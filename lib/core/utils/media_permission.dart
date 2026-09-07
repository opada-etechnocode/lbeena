import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class MediaPermission {
  MediaPermission._();

  static Future<bool> request({
    bool camera = false,
    bool gallery = true,
  }) async {
    final permissions = <Permission>[];
    if (camera) {
      permissions.add(Permission.camera);
    }
    if (gallery) {
      permissions.add(Permission.photos);
      permissions.add(Permission.videos);
      if (Platform.isAndroid) {
        permissions.add(Permission.storage);
      }
    }

    final statuses = <Permission, PermissionStatus>{};
    for (final permission in permissions) {
      statuses[permission] = await permission.request();
    }

    if (statuses.values.any((status) => status.isGranted || status.isLimited)) {
      return true;
    }
    if (statuses.values.any((status) => status.isPermanentlyDenied)) {
      return false;
    }
    return true;
  }

  static Future<bool> ensure(
    BuildContext context, {
    bool camera = false,
    bool gallery = true,
  }) async {
    final granted = await request(camera: camera, gallery: gallery);
    if (granted) return true;
    if (!context.mounted) return false;

    final shouldOpenSettings = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('الإذن مطلوب'),
        content: Text(
          'يجب منح إذن الوصول إلى ${camera && !gallery ? "الكاميرا" : "معرض الصور والفيديو"} حتى يعمل الاستوديو.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('فتح الإعدادات'),
          ),
        ],
      ),
    );

    if (shouldOpenSettings == true) {
      await openAppSettings();
    }
    return false;
  }
}
