import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syrians_in_uae/core/utils/image_constant.dart';
import 'package:syrians_in_uae/ui/theme/lbeena_colors.dart';
import 'package:syrians_in_uae/widgets/custom_image_view.dart';

class LbeenaAuthScaffold extends StatelessWidget {
  const LbeenaAuthScaffold({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: LbeenaColors.teal,
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 2, 8, 18),
                child: Column(
                  children: [
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: canPop
                          ? IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const FaIcon(
                                FontAwesomeIcons.xmark,
                                color: LbeenaColors.white,
                                size: 18,
                              ),
                            )
                          : const SizedBox(height: 12),
                    ),
                    CustomImageView(
                      imagePath: ImageConstant.logoAppWhite,
                      height: 70,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 36,
                      height: 3,
                      decoration: BoxDecoration(
                        color: LbeenaColors.orange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        subtitle!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: LbeenaColors.white.withOpacity(0.9),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: LbeenaColors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: LbeenaColors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(28)),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      22,
                      24,
                      22,
                      28 + MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: child,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LbeenaAuthPrimaryButton extends StatelessWidget {
  const LbeenaAuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.outlined = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool loading;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final bg = outlined ? LbeenaColors.white : LbeenaColors.orange;
    final fg = outlined ? LbeenaColors.teal : LbeenaColors.white;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          disabledBackgroundColor: LbeenaColors.orange.withOpacity(0.7),
          elevation: 0,
          side: outlined
              ? const BorderSide(color: LbeenaColors.teal, width: 1.2)
              : BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: LbeenaColors.white,
                ),
              )
            : Text(
                label,
                style: TextStyle(
                  color: fg,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
      ),
    );
  }
}

class LbeenaAuthFieldIcon extends StatelessWidget {
  const LbeenaAuthFieldIcon({super.key, required this.icon});

  final FaIconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: FaIcon(icon, size: 16, color: LbeenaColors.orange),
    );
  }
}
