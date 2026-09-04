import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class FileManager {

  // compress file and get file.
  static Future<File?> compressFile(
      File file,
      bool isChat,{bool isProfile =false}
      ) async {
    String extension = file.path.split('.').last;
    debugPrint('extension: $extension');

    final dir = await getTemporaryDirectory();
    final tmpDir = dir.path;
    final target = "$tmpDir/${DateTime.now().millisecondsSinceEpoch}.jpg";

    var result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      target,
      quality: isChat?25:isProfile?10: 20,
      minWidth: 1024,
      minHeight: 1024,
      // rotate: 180,
    );

    return File(result!.path);
  }

}
