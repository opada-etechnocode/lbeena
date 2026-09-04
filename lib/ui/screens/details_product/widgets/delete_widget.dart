import 'package:flutter/cupertino.dart';

import '../../../../widgets/components.dart';
import '../../../../widgets/loader_for_page.dart';

class DeleteAdWidget extends StatelessWidget {
  const DeleteAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical:
            MediaQuery.of(context).size.height /
                3.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            textNormal(text: 'جاري حذف الإعلان ..'),
            loaderNormal(),
          ],
        ),
      ),
    );
  }
}
