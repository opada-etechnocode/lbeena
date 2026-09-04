import 'package:flutter/material.dart';

const num FIGMA_DESIGN_WIDTH = 376;
const num FIGMA_DESIGN_HEIGHT = 812;
const num FIGMA_DESIGN_STATUS_BAR = 0;

/// نوع الجهاز
enum DeviceType1 { mobile, tablet, desktop }

/// Sizer Widget لتحديث القيم عند تغيير اتجاه الجهاز
typedef ResponsiveBuild = Widget Function(
    BuildContext context,
    Orientation orientation,
    DeviceType1 deviceType,
    );

class Sizer extends StatelessWidget {
  const Sizer({Key? key, required this.builder}) : super(key: key);

  final ResponsiveBuild builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeUtilsNew.setScreenSize(constraints, orientation);
            return builder(context, orientation, SizeUtilsNew.deviceType);
          },
        );
      },
    );
  }
}

/// أداة لحساب أبعاد الجهاز ونوعه
class SizeUtilsNew {
  static late BoxConstraints boxConstraints;
  static late Orientation orientation;
  static late DeviceType1 deviceType;
  static late double width;
  static late double height;

  static void setScreenSize(
      BoxConstraints constraints,
      Orientation currentOrientation,
      ) {
    boxConstraints = constraints;
    orientation = currentOrientation;

    if (orientation == Orientation.portrait) {
      width = boxConstraints.maxWidth.isNonZero(defaultValue: FIGMA_DESIGN_WIDTH);
      height = boxConstraints.maxHeight.isNonZero();
    } else {
      width = boxConstraints.maxHeight.isNonZero(defaultValue: FIGMA_DESIGN_WIDTH);
      height = boxConstraints.maxWidth.isNonZero();
    }

    // تحديد نوع الجهاز
    if (width >= 900) {
      deviceType = DeviceType1.desktop;
    } else if (width >= 600) {
      deviceType = DeviceType1.tablet;
    } else {
      deviceType = DeviceType1.mobile;
    }
  }
}

/// امتداد لحساب القيم بشكل متجاوب
extension ResponsiveExtension on num {
  double get _width => SizeUtilsNew.width;
  double get _height => SizeUtilsNew.height;

  /// نسبة من العرض
  double get horizontalApp => (this * _width) / FIGMA_DESIGN_WIDTH;

  /// نسبة من الطول
  double get verticalApp => (this * _height) / (FIGMA_DESIGN_HEIGHT - FIGMA_DESIGN_STATUS_BAR);

  /// أصغر قيمة بين العرض والطول (مفيدة لحجم الصور أو الخط)
  double get a => horizontalApp < verticalApp
      ? horizontalApp.toDoubleValue()
      : verticalApp.toDoubleValue();

  /// حجم الخط بشكل نسبي
  double get fSize => a;

  /// الوصول المباشر للعرض الحالي
  double get width => _width;

  /// الوصول المباشر للطول الحالي
  double get height => _height;
}

/// امتداد لتنسيق القيم والتأكد من أنها غير صفرية
extension FormatExtension on double {
  double toDoubleValue({int fractionDigits = 2}) {
    return double.parse(toStringAsFixed(fractionDigits));
  }

  double isNonZero({num defaultValue = 0.0}) {
    return this > 0 ? this : defaultValue.toDouble();
  }
}
