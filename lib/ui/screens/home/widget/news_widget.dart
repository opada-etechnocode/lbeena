import 'package:syrians_in_uae/ui/screens/home/cubit/cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marquee/marquee.dart';
// import '../../../../l10n/app_localizations.dart';

import 'package:syrians_in_uae/core/link_app.dart';

import '../../../../core/constants/app_font.dart';
import '../../../../core/di/di_manager.dart';
import '../../../../core/shared_prefs/shared_prefs.dart';
import '../../../../data/models/news/news_model.dart';
import '../../../../widgets/components.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/theme_helper.dart';
import '../../news/news_list_screen.dart';
import '../cubit/status.dart';

class TopNewsWidget extends StatefulWidget {
  const TopNewsWidget({super.key});

  @override
  State<TopNewsWidget> createState() => _TopNewsWidgetState();
}

class _TopNewsWidgetState extends State<TopNewsWidget> {
  @override
  void initState() {
    HomeCubit.get(context).getAllNews();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return BlocConsumer<HomeCubit, HomeStates>(

      listener: (context,state){
        if (state is SuccessGetAllNewsState) {
          breakingNews = state.newsModel.news!.data
              .where((e) => e.isTape == 1)
              .toList();


          if( state
              .newsModel.news!.data.isNotEmpty){
            if(state
                .newsModel.news!.data[0].backgroundColor
                !=null &&  state
                .newsModel.news!.data[0].backgroundColor != 'undefined'){
              colorPackage = state
                  .newsModel.news!.data[0].backgroundColor!
                  .substring(1);

              colorPackage = '0xFF$colorPackage';
            }
          }

        }

      },
      builder: (context,state){
        // if(state is LoadingPackagesUserState){
        //   return Container();
        //
        // }  if(state is ErrorPackagesUserState){
        //   return Container();
        // }
        //

        return topNews();

      },);
  }

  List<NewsList>? breakingNews;
  String colorPackage ='0xFF9B9B9B';

  Widget topNews() {
    var lang = Localizations.localeOf(context).languageCode;
print(colorPackage);
    return Container(
      // height: 58.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      // color: appTheme.deepPurpleA10002,

      color: Color(int.parse(colorPackage)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if ((breakingNews != null && breakingNews!.isNotEmpty) )...{
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      navigatorToPush(
                          context: context, pageName: NewsListScreen());
                    },
                    child: Text(
                      AppLocalizations.of(context)!.breaking_news,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(
                          color: Colors.yellow,
                          fontSize: AppFontSize.fontSize_15,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                    child: Marquee(
                      textDirection:
                      lang == 'ar' ? TextDirection.ltr : TextDirection.ltr,
                      text: getNewsLineText(breakingNewsList: breakingNews!),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.white,
                        fontSize: AppFontSize.fontSize_12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          } else ...{
            Expanded(child:
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Text(
                 AppLocalizations.of(context)!.checkout_news,
                 style: Theme.of(context)
                     .textTheme
                     .bodyMedium!
                     .copyWith(color: Colors.yellow,),
               ),
               SizedBox(
                 height: 25.h,

               ),
             ],
           ),)

          },
          InkWell(
            onTap: () {
              // Navigator.pushNamed(context, NewsListScreen.routeName);
              navigatorToPush(context: context, pageName: NewsListScreen());
            },
            child: Container(
              decoration: AppDecoration.outlineButton.copyWith(
                color: appTheme.white,
                borderRadius: BorderRadius.all(Radius.circular(30.r)),
              ),
              width: 70.w,
              height: 40.h,
              child: Center(
                  child: textNormal(
                      text: AppLocalizations.of(context)!.see_all,
                      fontSize: AppFontSize.fontSize_10,
                      fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ),
    );
  }

  String getNewsLineText({required List<NewsList> breakingNewsList}) {
    String text = "";

    for (int i = 0; i < breakingNewsList.length; i++) {
      if (i >= 5) break;

      text += " • ${breakingNewsList[i].title ?? '-'}";
    }

    return text;
  }

}
