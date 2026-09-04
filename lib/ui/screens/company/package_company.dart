import 'package:syrians_in_uae/core/constants/app_font.dart';
import 'package:syrians_in_uae/data/models/profile_company/package_company_model.dart';
import 'package:syrians_in_uae/ui/screens/home/cubit/cubit.dart';
import 'package:syrians_in_uae/ui/screens/home/cubit/status.dart';
import 'package:syrians_in_uae/ui/screens/profile/cubit/cubit.dart';
import 'package:syrians_in_uae/ui/theme/theme_helper.dart';
import 'package:syrians_in_uae/widgets/banner_item_shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../core/constants/app_colors.dart';
import '../../../widgets/components.dart';
import '../../../widgets/smart_refresh_widget.dart';
import '../../app_general_bloc/handel_android_app.dart';
import '../../theme/app_decoration.dart';
import '../home/widget/package_user.dart';
import '../profile/cubit/status.dart';
import 'all_package_company.dart';

class PackageCompanyPage extends StatefulWidget {
  PackageCompanyPage({
    super.key,
  });


  @override
  State<PackageCompanyPage> createState() => _PackageCompanyPageState();
}

class _PackageCompanyPageState extends State<PackageCompanyPage> {

  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return HandelAndroidApp(
      child: Scaffold(
        appBar: appBarNormalWithIcon(text:  'بطاقة العضوية', context: context,isShowBack: true),
        body: BlocProvider(
          create: (context) {
            return HomeCubit();
          },
          child: BlocConsumer<HomeCubit, HomeStates>(
            listener: (context, state) {},
            builder: (context, state) {
              return SmartRefreshWidget(
                onRefresh: () async {
                  HomeCubit.get(context).getPackagesUser();
                  _refreshController.refreshCompleted();
                },
                controller: _refreshController,
                onLoading: () {
                  _refreshController.loadComplete();
                },
                child: SingleChildScrollView(
                  child: PackageUserWidget(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}