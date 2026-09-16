import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

Rect shareOriginOf(BuildContext context) {
  final box = context.findRenderObject() as RenderBox?;
  if (box != null && box.hasSize) {
    return box.localToGlobal(Offset.zero) & box.size;
  }
  final size = MediaQuery.sizeOf(context);
  return Rect.fromLTWH(0, 0, size.width, size.height / 2);
}

Future<void> shareWithPlus({
  required BuildContext context,
  required String text,
  XFile? file,
}) async {
  final origin = shareOriginOf(context);
  try {
    await SharePlus.instance.share(
      ShareParams(
        text: text,
        files: file == null ? null : [file],
        sharePositionOrigin: origin,
      ),
    );
  } catch (_) {
    await SharePlus.instance.share(
      ShareParams(
        text: text,
        sharePositionOrigin: origin,
      ),
    );
  }
}

Future<XFile?> xFileFromNetworkImage(String imageUrl) async {
  if (imageUrl.isEmpty || imageUrl == 'null') return null;
  final uri = Uri.tryParse(imageUrl);
  if (uri == null || !uri.hasScheme) return null;
  final path = uri.path.toLowerCase();
  if (!(path.endsWith('.jpg') ||
      path.endsWith('.jpeg') ||
      path.endsWith('.png') ||
      path.endsWith('.webp'))) {
    return null;
  }
  final client = HttpClient();
  try {
    final request = await client.getUrl(uri);
    final response = await request.close();
    if (response.statusCode != 200) return null;
    final bytes =
        await response.fold<List<int>>(<int>[], (p, e) => p..addAll(e));
    final ext = path.endsWith('.png')
        ? 'png'
        : path.endsWith('.webp')
            ? 'webp'
            : 'jpg';
    final file = File('${Directory.systemTemp.path}/lbeena_share.$ext');
    await file.writeAsBytes(bytes, flush: true);
    return XFile(file.path);
  } catch (_) {
    return null;
  } finally {
    client.close(force: true);
  }
}
