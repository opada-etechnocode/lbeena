import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syrians_in_uae/ui/theme/theme_helper.dart';
import 'app_shimmer/custom_shimmer.dart';


class CustomImageView extends StatelessWidget {
  ///[imagePath] is required parameter for showing image
  String? imagePath;

  double? height;
  double? width;
  Color? color;
  BoxFit? fit;
  final String placeHolder;
  Alignment? alignment;
  VoidCallback? onTap;
  EdgeInsetsGeometry? margin;
  BorderRadius? radius;
  BoxBorder? border;

  ///a [CustomImageView] it can be used for showing any type of images
  /// it will shows the placeholder image if image is not found on network image
  CustomImageView({
    this.imagePath,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.alignment,
    this.onTap,
    this.radius,
    this.margin,
    this.border,
    this.placeHolder = 'assets/images/image_not_found_app.png',
  });

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
      alignment: alignment!,
      child: _buildWidget(),
    )
        : _buildWidget();
  }

  Widget _buildWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: _buildCircleImage(),
      ),
    );
  }

  ///build the image with border radius
  _buildCircleImage() {
    if (radius != null) {
      return ClipRRect(
        borderRadius: radius ?? BorderRadius.zero,
        child: _buildImageWithBorder(),
      );
    } else {
      return _buildImageWithBorder();
    }
  }

  ///build the image with border and border radius style
  _buildImageWithBorder() {
    if (border != null) {
      return Container(
        decoration: BoxDecoration(
          border: border,
          borderRadius: radius,
        ),
        child: _buildImageView(),
      );
    } else {
      return _buildImageView();
    }
  }

  Widget _buildImageView() {
    if (imagePath != null) {
      switch (imagePath!.imageType) {
        case ImageType.svgNetwork:
          return SvgPicture.network(
            imagePath!,
            height: height,
            width: width,
            fit: fit ?? BoxFit.contain,
            colorFilter: color != null
                ? ColorFilter.mode(color!, BlendMode.srcIn)
                : null,
            placeholderBuilder: (context) => CustomShimmer(
              child: Container(
                height: height ?? 30,
                width: width ?? 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: appTheme.greenColorApp,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          );

        case ImageType.svg:
          return SvgPicture.asset(
            imagePath!,
            height: height,
            width: width,
            fit: fit ?? BoxFit.contain,
            colorFilter: color != null
                ? ColorFilter.mode(color!, BlendMode.srcIn)
                : null,
          );

        case ImageType.file:
          return Image.file(
            File(imagePath!),
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
          );

        case ImageType.network:
        // 🔹 Network image (PNG, JPG, ...)
          return CachedNetworkImage(
            height: height,
            width: width,
            fit: fit,
            imageUrl: imagePath!,
            color: color,
            placeholder: (context, url) => Container(
              height: 30,
              width: 30,
              child: Shimmer.fromColors(
                baseColor: appTheme.greenColorApp.withOpacity(.2),
                highlightColor: Colors.white,
                child: LinearProgressIndicator(
                  color: Colors.grey.shade200,
                  backgroundColor: Colors.grey.shade100,
                ),
              ),
            ),
            errorWidget: (context, url, error) {
              switch (placeHolder.imageType) {
                case ImageType.svg:
                  return SvgPicture.asset(
                    placeHolder,
                    height: height,
                    width: width,
                    fit: fit ?? BoxFit.contain,
                    color: color ?? Colors.white60,
                  );
                case ImageType.file:
                  return Image.file(
                    File(placeHolder),
                    height: height,
                    width: width,
                    fit: fit ?? BoxFit.cover,
                    color: color,
                  );
                default:
                  return Image.asset(
                    placeHolder,
                    height: height,
                    width: width,
                    fit: fit ?? BoxFit.cover,
                    color: color,
                  );
              }
            },
          );

        case ImageType.png:
        default:
          return Image.asset(
            imagePath!,
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
            errorBuilder: (context, url, error) => Image.asset(
              placeHolder,
              height: height,
              width: width,
              fit: fit ?? BoxFit.cover,
            ),
          );
      }
    }
    return SizedBox();
  }

}
extension ImageTypeExtension on String {
  ImageType get imageType {
    final lower = toLowerCase();

    if (lower.startsWith('http') || lower.startsWith('https')) {
      if (lower.endsWith('.svg')) {
        return ImageType.svgNetwork; // 🔹 SVG من النت
      }
      return ImageType.network; // 🔹 صورة network (png/jpg)
    } else if (lower.endsWith('.svg')) {
      return ImageType.svg; // 🔹 SVG محلي (asset)
    } else if (lower.startsWith('file://')) {
      return ImageType.file;
    } else {
      return ImageType.png;
    }
  }
}

enum ImageType { svg, svgNetwork, png, network, file, unknown }