import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syrians_in_uae/core/utils/image_constant.dart';
import 'package:syrians_in_uae/ui/theme/lbeena_colors.dart';
import 'package:syrians_in_uae/widgets/custom_image_view.dart';
import 'package:syrians_in_uae/widgets/user_image_profile.dart';

class LbeenaChatFieldIcon extends StatelessWidget {
  const LbeenaChatFieldIcon({
    super.key,
    required this.icon,
    this.color,
    this.size = 17,
  });

  const LbeenaChatFieldIcon.gallery({super.key})
      : icon = FontAwesomeIcons.image,
        color = null,
        size = 17;

  const LbeenaChatFieldIcon.camera({super.key})
      : icon = FontAwesomeIcons.camera,
        color = null,
        size = 16;

  const LbeenaChatFieldIcon.send({super.key})
      : icon = FontAwesomeIcons.paperPlane,
        color = LbeenaColors.white,
        size = 16;

  const LbeenaChatFieldIcon.mic({super.key})
      : icon = FontAwesomeIcons.microphone,
        color = LbeenaColors.white,
        size = 17;

  const LbeenaChatFieldIcon.micActive({super.key})
      : icon = FontAwesomeIcons.microphoneLines,
        color = LbeenaColors.white,
        size = 17;

  const LbeenaChatFieldIcon.play({super.key})
      : icon = FontAwesomeIcons.play,
        color = null,
        size = 15;

  const LbeenaChatFieldIcon.stop({super.key})
      : icon = FontAwesomeIcons.stop,
        color = null,
        size = 15;

  const LbeenaChatFieldIcon.trash({super.key})
      : icon = FontAwesomeIcons.trashCan,
        color = null,
        size = 16;

  final FaIconData icon;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return FaIcon(
      icon,
      color: color ?? LbeenaColors.orange,
      size: size,
    );
  }
}

class LbeenaChatPeerBar extends StatelessWidget {
  const LbeenaChatPeerBar({
    super.key,
    required this.onBack,
    required this.imagePath,
    required this.name,
    required this.subtitle,
    this.isOnline = false,
    this.onTitleTap,
    this.showStatus = true,
  });

  final VoidCallback onBack;
  final String imagePath;
  final String name;
  final String subtitle;
  final bool isOnline;
  final VoidCallback? onTitleTap;
  final bool showStatus;

  @override
  Widget build(BuildContext context) {
    final title = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: LbeenaColors.white,
            fontWeight: FontWeight.w800,
            fontSize: 15,
            fontFamily: 'Cairo',
          ),
        ),
        if (subtitle.isNotEmpty)
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: LbeenaColors.white.withValues(alpha: 0.86),
              fontWeight: FontWeight.w600,
              fontSize: 11,
              fontFamily: 'Cairo',
            ),
          ),
      ],
    );

    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          color: LbeenaColors.white,
        ),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: LbeenaColors.orange, width: 1.6),
          ),
          child: ClipOval(
            child: CustomImageView(
              imagePath: imagePath,
              fit: BoxFit.cover,
              height: 42,
              width: 42,
              placeHolder: ImageConstant.imgPerson,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: onTitleTap == null
              ? title
              : GestureDetector(onTap: onTitleTap, child: title),
        ),
        if (showStatus) ...[
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: isOnline
                  ? const Color(0xFF22C55E)
                  : LbeenaColors.white.withValues(alpha: 0.45),
              shape: BoxShape.circle,
              border: Border.all(color: LbeenaColors.white, width: 1.2),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class LbeenaChatComposerBox extends StatelessWidget {
  const LbeenaChatComposerBox({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: LbeenaColors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: LbeenaColors.fieldBorder),
        boxShadow: [
          BoxShadow(
            color: LbeenaColors.teal.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class LbeenaChatTabs extends StatelessWidget {
  const LbeenaChatTabs({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  static const _labels = ['إعلانات', 'منشورات', 'مجموعات'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: LbeenaColors.iconTile,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: List.generate(_labels.length, (index) {
            final selected = selectedIndex == index;
            return Expanded(
              child: GestureDetector(
                onTap: () => onChanged(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: selected ? LbeenaColors.teal : Colors.transparent,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Text(
                    _labels[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: selected ? LbeenaColors.white : LbeenaColors.tealDark,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

String lbeenaChatPeerImage({
  required bool viewingAsOwner,
  required String? companyImage,
  required String? userImage,
}) {
  final raw = viewingAsOwner ? companyImage : userImage;
  if (isEmptyProfileImage(raw) ||
      raw == 'https://www.syriansinuae.com' ||
      raw == 'https://syriansinuae.com') {
    return ImageConstant.imgPerson;
  }
  return raw!;
}

InputDecoration lbeenaChatInputDecoration({String hint = 'اكتب رسالتك...'}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(
      color: LbeenaColors.fieldHint,
      fontFamily: 'Cairo',
      fontWeight: FontWeight.w600,
      fontSize: 14,
    ),
    border: InputBorder.none,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(vertical: 12),
  );
}
