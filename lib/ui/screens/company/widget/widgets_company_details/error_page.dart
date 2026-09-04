import 'package:flutter/cupertino.dart';

import '../../../../../widgets/company_info_shimmer.dart';
import '../../../../../widgets/components.dart';

class ErrorCompanyDetailsPage extends StatelessWidget {
  const ErrorCompanyDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        textNormal(text: 'خطأ بالتحميل'),
        CompanyInformationShimmer(),
      ],
    );
  }
}
