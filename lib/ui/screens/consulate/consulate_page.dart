import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syrians_in_uae/core/constants/app_font.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/ui/screens/home/cubit/cubit.dart';
import 'package:syrians_in_uae/ui/screens/home/home_screen.dart';
import 'package:syrians_in_uae/ui/theme/app_decoration.dart';

import '../../../core/di/di_manager.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../../data/models/government_with_services/government_with_services.dart';
import '../../../widgets/components.dart';
import '../../../widgets/loader_page/loader_page.dart';
import '../../app_general_bloc/handel_android_app.dart';
import '../../theme/theme_helper.dart';
import '../../widget/url_webview.dart';
import '../home/cubit/status.dart';

class ConsulatePage extends StatefulWidget {
  const ConsulatePage({super.key});

  @override
  State<ConsulatePage> createState() => _ConsulatePageState();
}

class _ConsulatePageState extends State<ConsulatePage> {

  int indexSelected =0 ;
  int? departmentSelectedId;
  @override
  Widget build(BuildContext context) {
    return HandelAndroidApp(
      child: Scaffold(
        appBar: appBarNormalWithIcon(text:'خدمات القنصلية', context: context,isShowBack: true),
        body: BlocProvider(
          create: (context) => HomeCubit()..getGovernmentWithServices(),
          child: BlocConsumer<HomeCubit, HomeStates>(
            listener: (context,state){},
            builder: (context,state){
              if(state is ErrorGovernmentWithServicesState){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: textNormal(text: 'حدث خطأ ما ..')),
                    sizeHeightNormal(),
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 70.w),
                      child: ElevatedButton(onPressed: (){
                        HomeCubit.get(context).getGovernmentWithServices();
                      }, child:    Center(child: textNormal(text: 'تحديث الصفحة')),),
                    )
                  ],
                );
              }
              if(state is LoadingGovernmentWithServicesState){
                return Center(child: const LoadingPage());
              }
              if(state is SuccessGovernmentWithServicesState){
                return  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    sizeHeightNormal(),
                    Container(
      // width: 300.w,
                      height: 50.h,
                      child:ListView.builder(
                          itemCount: state.detailsProductModel.data.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context,index){
                        return InkWell(
                          onTap: (){
                            setState(() {
                              indexSelected =index;
                            });
                            print(indexSelected);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 8.h),
                            child: Container(
                                decoration: AppDecoration.profileUi.copyWith(
                                  borderRadius: BorderRadius.all(Radius.circular(7.r)),
                                  color:  indexSelected ==index?appTheme.greenColor: (DIManager.findDep<
                                      SharedPrefs>()
                                      .getThemeApp() ==
                                      'd'
                                      ? appTheme
                                      .lightBlueBottomNavigatorBar
                                      .withOpacity(.7)
                                      : appTheme.whiteA100.withOpacity(.9)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: appTheme.colorAppBar,
                                      spreadRadius: 0.5,
                                      blurRadius: 0.5,
                                      offset: Offset(
                                        0,
                                        0,
                                      ),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: 6 .w),
                                  child: Center(
                                      child: textNormal(text: state.detailsProductModel.data[index].departmentName ??'',fontSize: AppFontSize.fontSize_12,color: indexSelected ==index?Colors.white   : appTheme.black900 )),
                                )),
                          ),
                        );
                      }),
                    ),

              if(state.detailsProductModel.data[indexSelected].services.isEmpty)...{
                sizeHeightNormal(height: 250.h
                ),
               Center(child:  textNormal(text: 'لايوجد معلومات بعد ..'),)
              }else...{
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,       mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ...state.detailsProductModel.data[indexSelected].services.map((service) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: (){
                                    setState(() {
                                      if(service.url != null){
                                        navigatorToPush(
                                            context: context,
                                            pageName:  UrlWebViewPage(
                                              urlPage: service.url,
                                              titleAppBer:service.serviceName ??'',
                                            ));

                                      }
                                      else{
                                        if( departmentSelectedId !=  service.id!){
                                          departmentSelectedId =  service.id!;
                                        }else {
                                          departmentSelectedId =  null;
                                        }
                                      }


                                    });
                                  },
                                  child: Text(
                                    service.serviceName ??'',
                                    style: TextStyle(fontSize: 18.fSize, fontWeight: FontWeight.bold,color: appTheme.greenColor,overflow: TextOverflow.visible),
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                service.description ==null?Container():Html(data: """${service.description}""",),
                                // SizedBox(height: 16.h),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                )
              }


                  ],
                );
              }
              return Container();
            },
          ) ,
        ),
      ),
    );
  }

}
