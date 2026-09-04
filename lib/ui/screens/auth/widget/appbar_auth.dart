import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syrians_in_uae/ui/theme/lbeena_colors.dart';

class AppbarAuth extends StatelessWidget implements PreferredSizeWidget {
  const AppbarAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: LbeenaColors.teal,
      foregroundColor: LbeenaColors.white,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const FaIcon(
          FontAwesomeIcons.xmark,
          size: 18,
          color: LbeenaColors.white,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
