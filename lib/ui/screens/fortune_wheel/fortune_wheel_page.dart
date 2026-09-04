import 'dart:async';
import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
// import '../../../l10n/app_localizations.dart';

import 'package:syrians_in_uae/core/link_app.dart';

import '../../../widgets/components.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../app_general_bloc/handel_android_app.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_button_style.dart';
import '../../theme/theme_helper.dart';
import 'cubit/fortune_wheel_cubit.dart';
import 'cubit/fortune_wheel_state.dart';

class FortuneWheelPage extends StatefulWidget {
  const FortuneWheelPage({super.key});

  @override
  State<FortuneWheelPage> createState() => _FortuneWheelPageState();
}

class _FortuneWheelPageState extends State<FortuneWheelPage> {
  TextEditingController addNameToFortuneWheeController =
      TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late ConfettiController _confettiController;
  String? winnersName;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    // FortuneWheelCubit.get(context).controller.close();
    _confettiController.dispose();
    super.dispose();
  }

  final FocusNode _secondFocusNode = FocusNode();
  bool isErrorButton = false;
  bool isErrorDelete = false;
  bool isNotChange = false;
  List value = [];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FortuneWheelCubit, FortuneWheelState>(
      listener: (context, state) {
        if (state is FortuneWheelCustomerStateSuccess) {
          FortuneWheelCubit.get(context).fortuneWheelCustomerList =
              state.fortuneWheelCustomerModel.data;
          isNotChange = false;
          String valueFirst = FortuneWheelCubit.get(context).fortuneWheelList!.toString();
          print(valueFirst);
          print(FortuneWheelCubit.get(context).fortuneWheelList!);
          print(isNotChange);
          print('------------------------------------------------------------');
          for (int i = 0;
              i < state.fortuneWheelCustomerModel.data.length;
              i++) {
            if (!(FortuneWheelCubit.get(context).fortuneWheelList!.contains(
                state.fortuneWheelCustomerModel.data[i].mobile))) {
              value.add(state.fortuneWheelCustomerModel.data[i].mobile);
            }
          }

          //
          // for (int i = 0;
          //     i < state.fortuneWheelCustomerModel.data.length;
          //     i++) {
          //   if (!(DIManager.findDep<SharedPrefs>()
          //       .getListFortuneCustomerId()!
          //       .contains(state.fortuneWheelCustomerModel.data[i].id))) {
          //     FortuneWheelCubit.get(context)
          //         .valueCustomerId
          //         .add(state.fortuneWheelCustomerModel.data[i].id);
          //   }
          // }
          // DIManager.findDep<SharedPrefs>().setListFortuneCustomerId(
          //     FortuneWheelCubit.get(context).valueCustomerId);
          FortuneWheelCubit.get(context).addAllToList(value: value);
          if(valueFirst ==FortuneWheelCubit.get(context).fortuneWheelList!.toString()){
            isNotChange = true;
          }else {
            isNotChange = false;
          }
          print(valueFirst);
          print(FortuneWheelCubit.get(context).fortuneWheelList!);
          print(isNotChange);
          value.clear();
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: HandelAndroidApp(
            child: Scaffold(
              appBar: appBarNormalWithIcon(
                text: 'عجلة الحظ',
                context: context,
                isShowBack: true,
              ),
              body: Stack(
                alignment: Alignment.center,
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          sizeHeightNormal(),
                          Row(crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CustomTextFormField(
                                    width: 240.w,
                                    height: 30.h,
                                    controller: addNameToFortuneWheeController,
                                    focusNode: _secondFocusNode,
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return AppLocalizations.of(context)!
                                            .field_is_empty;
                                      }
                                      return null;
                                    },
                                  ),
                                  sizeHeightNormal(height: 4.h),
                                  CustomElevatedButton(
                                    width: 140.w,
                                    height: 30.h,
                                    buttonStyle: CustomButtonStyles.buttonGeneral,
                                    text: 'استيراد من قائمة المتابعين',
                                    buttonTextStyle: themeLite.textTheme.titleSmall!
                                        .copyWith(
                                        color: isErrorButton ? Colors.red : null,
                                        fontSize: 10.fSize),
                                    onPressed: () {
                                      FortuneWheelCubit.get(context)
                                          .getFortuneWheelCustomer();
                                      setState(() {
                                        isNotChange = false;
                                        isErrorDelete = false;
                                      });
                                    },
                                    isDisabled: state is FortuneWheelCustomerStateLoading
                                        ? true
                                        : false,
                                    child: state is FortuneWheelCustomerStateLoading
                                        ? loadingButton()
                                        : null,
                                  ),

                                ],
                              ),
                              sizeWidthNormal(),
                              Column(crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CustomElevatedButton(
                                    width: 70.w,
                                    height: 30.h,
                                    buttonStyle: CustomButtonStyles.buttonGeneral,
                                    text: 'أضف',
                                    buttonTextStyle: themeLite.textTheme.titleSmall!
                                        .copyWith(
                                            color: isErrorButton ? Colors.red : null,
                                            fontSize: 12.fSize),
                                    onPressed: () {
                                      if (addNameToFortuneWheeController
                                          .text.isNotEmpty) {
                                        FortuneWheelCubit.get(context).addNameToList(
                                            name:
                                                addNameToFortuneWheeController.text);

                                        addNameToFortuneWheeController.clear();
                                        setState(() {
                                          isErrorButton = false;
                                        });
                                        setState(() {
                                          isErrorDelete = false;
                                        });
                                      } else {
                                        setState(() {
                                          isErrorButton = true;
                                        });
                                        setState(() {
                                          isErrorDelete = false;
                                        });
                                      }

                                      setState(() {
                                        isNotChange = false;
                                      });
                                    },
                                  ),
                                  sizeHeightNormal(height: 5.h),
                                  CustomElevatedButton(
                                    text: 'إعادة الضبط',        width: 70.w,
                                    height: 30.h,
                                    buttonTextStyle: themeLite.textTheme.titleSmall!.copyWith(fontSize:10.fSize ),
                                    onPressed: (){
                                      FortuneWheelCubit.get(context).clearList();
                                      setState(() {
                                        isNotChange = false;
                                        isErrorDelete = false;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              sizeWidthNormal(),
                              Column(        crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [sizeHeightNormal(height: 4.h),
                                  textNormal(
                                      text: DIManager.findDep<SharedPrefs>()
                                          .getListFortuneWheel()!
                                          .length
                                          .toString(),
                                      color: appTheme.black900,textAlign: TextAlign.center,
                                      fontSize: 12.fSize),
                                ],
                              ),
                            ],
                          ),



                          // sizeHeightNormal(height: 10.h),
                          Container(
                            height: 35.h,
                            // width: 200.w,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  for (int index = 0;
                                      index <
                                          DIManager.findDep<SharedPrefs>()
                                              .getListFortuneWheel()!
                                              .length;
                                      index++) ...{
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2.w,),
                                      child: InkWell(
                                        onTap: () {
                                          if (DIManager.findDep<SharedPrefs>()
                                                  .getListFortuneWheel()!
                                                  .length ==
                                              2) {
                                            setState(() {
                                              isErrorDelete = true;
                                            });
                                            return;
                                          }
                                          FortuneWheelCubit.get(context)
                                              .removeNameToList(
                                                  name: DIManager.findDep<
                                                              SharedPrefs>()
                                                          .getListFortuneWheel()![
                                                      index]);
                                          setState(() {
                                            isNotChange = false;
                                          });
                                        },
                                        child: Container(
                                            decoration: AppDecoration.itemCartNew,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 6.w,vertical: 5.h),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 6.w),
                                                    child: textNormal(
                                                        text: DIManager.findDep<
                                                                    SharedPrefs>()
                                                                .getListFortuneWheel()![
                                                            index],
                                                        fontSize: 12.fSize),
                                                  ),
                                                  Icon(
                                                    Icons.delete_outline,
                                                    size: 17.fSize,
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ),
                                    )
                                  },

                                  // for (int index = 0;
                                  // index <
                                  //     FortuneWheelCubit.get(context).fortuneWheelCustomerList.length;
                                  // index++) ...{
                                  //   Padding(
                                  //     padding:
                                  //     EdgeInsets.symmetric(horizontal: 2.w),
                                  //     child: InkWell(
                                  //       onTap: () {
                                  //         FortuneWheelCubit.get(context).fortuneWheelCustomerList.remove(FortuneWheelCubit.get(context).fortuneWheelCustomerList[index]);
                                  //         setState(() {
                                  //
                                  //         });
                                  //       },
                                  //       child: Container(
                                  //           decoration: AppDecoration.itemCartNew,
                                  //           child: Padding(
                                  //             padding: EdgeInsets.symmetric(
                                  //                 horizontal: 6.w),
                                  //             child: Row(
                                  //               crossAxisAlignment:
                                  //               CrossAxisAlignment.center,
                                  //               mainAxisAlignment:
                                  //               MainAxisAlignment.center,
                                  //               children: [
                                  //                 Padding(
                                  //                   padding: EdgeInsets.symmetric(
                                  //                       horizontal: 6.w),
                                  //                   child: textNormal(
                                  //                       text: FortuneWheelCubit.get(context).fortuneWheelCustomerList![
                                  //                       index].companyName!,
                                  //                       fontSize: 12.fSize),
                                  //                 ),
                                  //                 Icon(
                                  //                   Icons.dangerous_outlined,
                                  //                   size: 17.fSize,
                                  //                 ),
                                  //               ],
                                  //             ),
                                  //           )),
                                  //     ),
                                  //   )
                                  // },
                                ],
                              ),
                            ),
                          ),
                          if (isErrorDelete) ...{
                            textNormal(
                                text: 'يجب أن يكون في العجلة أقل شيء عنصرين',
                                color: Colors.red,
                                fontSize: 10.fSize),
                          }else...{
                            sizeHeightNormal(height: 14.h )
                          },
                          if (isNotChange) ...{
                            textNormal(
                                text: 'لايوجد عناصر جديدة',
                                color: Colors.red,
                                fontSize: 10.fSize),
                          }else...{
                            sizeHeightNormal(height: 14.h )
                          },
                          sizeHeightNormal(height: 50.h),
                          DIManager.findDep<SharedPrefs>()
                                      .getListFortuneWheel()!
                                      .isEmpty ||
                                  DIManager.findDep<SharedPrefs>()
                                          .getListFortuneWheel()!
                                          .length <
                                      2
                              ? Container()
                              : Center(
                                  child: Container(
                                    height: 290.w,
                                    width: 290.w,
                                    child: FortuneWheel(
                                      physics: CircularPanPhysics(
                                        duration: Duration(seconds: 2),
                                        curve: Curves.decelerate,
                                      ),
                                      onFling: () {
                                        FortuneWheelCubit.get(context)
                                            .spinWheel();
                                        final cubit =
                                            FortuneWheelCubit.get(context);
                                        final randomIndex = Random().nextInt(
                                            DIManager.findDep<SharedPrefs>()
                                                .getListFortuneWheel()!
                                                .length);

                                        cubit.controller.add(randomIndex);

                                        Future.delayed(Duration(seconds: 2), () {
                                          setState(() {
                                            winnersName =
                                                DIManager.findDep<SharedPrefs>()
                                                        .getListFortuneWheel()![
                                                    randomIndex];
                                          });
                                          _confettiController.play();
                                        });
                                      },
                                      hapticImpact: HapticImpact.heavy,
                                      duration: Duration(seconds: 2),
                                      selected: FortuneWheelCubit.get(context)
                                          .selectedStream,
                                      items: DIManager.findDep<SharedPrefs>()
                                          .getListFortuneWheel()!
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        final index = entry.key;
                                        final name = entry.value;

                                        final colors = [
                                          Colors.blueAccent.withOpacity(.7),
                                          Colors.redAccent.withOpacity(.7),
                                          Colors.greenAccent.withOpacity(.7),
                                          Colors.orangeAccent.withOpacity(.7),
                                          Colors.purpleAccent.withOpacity(.7),
                                          Colors.indigoAccent.withOpacity(.7),
                                          Colors.yellowAccent.withOpacity(.7),
                                          Colors.deepOrangeAccent.withOpacity(.7),
                                        ];
                                        final color =
                                            colors[index % colors.length];

                                        return FortuneItem(
                                          child: textNormal(
                                            text: name,
                                          ),
                                          style: FortuneItemStyle(
                                            color: color,
                                            borderColor: Colors.white,
                                            borderWidth: 2,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),

                          sizeHeightNormal(height: 40.h),
                          winnersName == null
                              ? Container()
                              : Center(
                                  child: textNormal(
                                      text: "🎉 الفائز! $winnersName",
                                      fontSize: 17.fSize)),
                        ],
                      ),
                    ),
                  ),

                  // تأثير الاحتفال عند إعلان الفائز
                  ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirection: -pi / 2,
                    // إطلاق للأعلى
                    emissionFrequency: 0.06,
                    // كثافة التأثير
                    numberOfParticles: 150,particleDrag: 0.006,
                    // عدد القطع المتطايرة
                    gravity: 0.1, // تأثير الجاذبية
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
