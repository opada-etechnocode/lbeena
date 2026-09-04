import 'dart:io';
import 'dart:ui';
import 'package:syrians_in_uae/core/constants/app_font.dart';
import 'package:syrians_in_uae/core/helper/snack_bar_helper.dart';
import 'package:syrians_in_uae/core/utils/image_constant.dart';
import 'package:syrians_in_uae/data/models/profile_company/information_company.dart';
import 'package:syrians_in_uae/core/utils/endpoints.dart';
import 'package:syrians_in_uae/ui/screens/auth/register/cubit/cubit.dart';
import 'package:syrians_in_uae/ui/screens/auth/register/cubit/status.dart';
import 'package:syrians_in_uae/ui/screens/profile/cubit/cubit.dart';
import 'package:syrians_in_uae/ui/screens/profile/cubit/status.dart';
import 'package:syrians_in_uae/ui/theme/app_decoration.dart';
import 'package:syrians_in_uae/ui/theme/theme_helper.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:syrians_in_uae/widgets/custom_image_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../widgets/custom_elevated_button.dart';
import '../../../../widgets/custom_text_form_field.dart';
import '../../../../widgets/loader_for_page.dart';
import '../../../data/models/add_ad_new/category_model.dart';
import '../../../data/models/company/activity_company_model.dart';
import '../../../data/models/profile_company/profile_company_model.dart';
// import '../../../l10n/app_localizations.dart';

import 'package:syrians_in_uae/core/link_app.dart';

import '../../app_general_bloc/handel_android_app.dart';
import '../../theme/theme_text_form_field.dart';
import 'info_company.dart';

class EditCompanyPage extends StatefulWidget {
  EditCompanyPage({
    super.key,
    this.mobileNumber,
    this.informationCompany,
    this.companyData,
  });

  ProfileInformationCompanyModel? informationCompany;
  String? mobileNumber;
  DataCompany? companyData ;
  @override
  State<EditCompanyPage> createState() => _EditCompanyPageState();
}

class _EditCompanyPageState extends State<EditCompanyPage> {
  // TextEditingController companyBusinessController = TextEditingController();
  TextEditingController nameAdminController = TextEditingController();
  TextEditingController licenseNumberController = TextEditingController();
  TextEditingController nameCompanyController = TextEditingController();
  TextEditingController companyDescriptionController = TextEditingController();
  TextEditingController dateTimeController = TextEditingController();
  final FocusNode _firstFocusNode = FocusNode();
  final FocusNode _secondFocusNode = FocusNode();
  final FocusNode _thirdFocusNode = FocusNode();
  final FocusNode _fordFocusNode = FocusNode();
  final FocusNode _seventhFocusNode = FocusNode();
  final FocusNode _companyDescriptionControllerFocusNode = FocusNode();
  List<Offset> _points = [];
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isCompany = false;
  String? companyBusiness;
  XFile? fileLicense;
  String formattedDate = '';
  @override
  void initState() {
    // companyBusinessController.text = widget.informationCompany!.data!.user!.companyActivity ?? '';
    activityCompanyTitle = widget.informationCompany!.data!.user!.companyActivity ?? '';
    nameAdminController.text = widget.informationCompany!.data!.user!.ownerName ?? '';
    activityCompanyId = widget.informationCompany?.data?.user?.business_activity_id;
    licenseNumberController.text =
        widget.informationCompany!.data!.user!.licenseNumber ?? '';
    nameCompanyController.text =
        widget.informationCompany!.data!.user!.companyName ?? '';
     formattedDate = DateFormat('yyyy-MM-dd').format(widget.informationCompany!.data!.user!.expiryDate!);
    dateTimeController.text =
        formattedDate ?? '';
    companyDescriptionController.text = widget.informationCompany!.data!.user!.description.toString() ?? '';
    selectedCountry = widget.informationCompany!.data!.user!.country.toString() ?? '';

    super.initState();
  }

  String? selectedCountry = '';

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: textNormal(text: 'أبو ظبي'), value: selectedCountry == 'Abu Dhabi'?'Abu Dhabi':"أبو ظبي"),

      DropdownMenuItem(child: textNormal(text: "دبي"), value:selectedCountry == 'Dubai'?'Dubai': "دبي"),
      DropdownMenuItem(child: textNormal(text: "العين"), value:selectedCountry == 'Al Ain'?'Al Ain': "العين"),
      DropdownMenuItem(child: textNormal(text: "الشارقة"), value: selectedCountry == 'Sharjah'?'Sharjah':"الشارقة"),
      DropdownMenuItem(child: textNormal(text: "عجمان"), value:selectedCountry == 'Ajman'?'Ajman': "عجمان"),
      DropdownMenuItem(
          child: textNormal(text: "أم القيوين"), value: selectedCountry == 'Umm al-Quwain'?'Umm al-Quwain':"أم القيوين"),
      DropdownMenuItem(child: textNormal(text: 'الفجيرة'), value: selectedCountry == 'Fujairah'?'Fujairah':"الفجيرة"),
      DropdownMenuItem(
          child: textNormal(text: "رأس الخيمة"), value:selectedCountry == 'Ras el Khaimah'?'Ras el Khaimah': "رأس الخيمة"),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    // print('971${widget.mobileNumber}');

    return HandelAndroidApp(
      child: Scaffold(

        appBar: appBarNormalWithIcon(text: 'ملف الشركة', context: context,isShowBack: true),
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Form(
              key: _formKey,
              child: SizedBox(
                width: double.maxFinite,
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 28.h,
                      vertical: 7.w,
                    ),
                    child: MultiBlocProvider(
        providers: [
      BlocProvider(
                      create: (context) => ProfileCubit(),
      ),
      BlocProvider(
        create: (context) => RegisterCubit()..getActivityCompany(),
        lazy: false,
      ),
        ],
        child: BlocConsumer<ProfileCubit, ProfileStates>(
                        listener: (context, state) {
                          if (state is SuccessEditInformationCompanyState) {
                            SnackBarHelper.mySnackBarSuccess(
                                state.editInformationCompanyModel.message,
                                context);
                          }
                          if (state is UpToOneMegaLoadFileProfileState) {
                            print('sadddddddddddddddd');
                            SnackBarHelper.mySnackBarError(
                                'خطأ: الحجم يجب أن يكون أصغر من 1 ميغا',
                                context);
                          }

                          if (state is SuccessLoadFileProfileState) {
                            fileLicense = state.fileLicense;
                            SnackBarHelper.mySnackBarSuccess(
                                'تم تحميل الرخصة بنجاح', context);
                          }
                        },
                        builder: (context, state) {
                          return Column(
                            children: [
                              _buildNameCompany(context, _firstFocusNode),
                              SizedBox(height: 20.h),
                              _buildNameAdmin(context, _secondFocusNode),
                              SizedBox(height: 20.h),
                              _buildLicenseNumber(context, _thirdFocusNode),
                              SizedBox(height: 20.h),
                              _buildCountry(context, _seventhFocusNode),
                              SizedBox(height: 20.h),
                              _buildPdf(context, _fordFocusNode, state),
                              SizedBox(height: 20.h),
                              _buildDateEnd(context),
                              SizedBox(height: 20.h),
                              BlocConsumer<RegisterCubit,RegisterStates>(listener:  (context,stateNew){
                                if(stateNew is SuccessActivityCompanyState){
                                  activityCompanyList =stateNew.activityCompanyModel.data;
                                  if (activityCompanyList != null) {
                                    final index = activityCompanyList!.indexWhere(
                                          (element) {
                                        print('element.id: ${element.id}');
                                        print('widget.companyData?.business_activities_id: ${widget.companyData?.business_activities_id}');
                                        return element.id == widget.companyData?.business_activities_id;
                                      },

                                    );
                                    if (index != -1) {
                                      indexActivityCompany = index;
                                    }

                                    if(activityCompanyList?[indexActivityCompany].subcategories != null && activityCompanyList![indexActivityCompany].subcategories.isNotEmpty){
                                      final subIndex = activityCompanyList![indexActivityCompany].subcategories!.indexWhere(
                                            (element) {
                                          return element.id == int.parse(widget.companyData?.subcategory_id.toString() ?? '0');
                                        },
                                      );
                                      if (subIndex != -1) {
                                        setState(() {
                                          indexSubActivityCompany = subIndex;
                                          subActivityCompanyId = activityCompanyList![indexActivityCompany].subcategories![indexSubActivityCompany].id ?? 0;
                                          subActivityCompanyTitle = activityCompanyList![indexActivityCompany].subcategories![indexSubActivityCompany].title ?? '';
                                        });
                                      }

                                    }
                                    //indexSubActivityCompany
                                  }


                                }
                              },builder: (context,stateNew)
                              {
                                return stateNew is SuccessActivityCompanyState? Column(
                                  children: [
                                    _buildActivityCompany(),
                                    SizedBox(height: 5.h),
                                    _buildSubActivityCompany(),
                                  ],
                                ):Container();
                              }, ),


                              SizedBox(height: 20.h),
                              _buildDescriptionCompany(context,
                                  _companyDescriptionControllerFocusNode),
                              SizedBox(height: 20.h),
                              isNotChange?textNormal(text: 'لم يتم تغيير أي شيء',color: Colors.red):Container(),
                              isNotChange?SizedBox(height: 15.h):Container(),
                              _buildButtonProfile(context, state),
                              SizedBox(height: 15.h),
                            ],
                          );
                        },
                      ),
      ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildDescriptionCompany(BuildContext context, focusNode) {
    var lang = Localizations.localeOf(context).languageCode;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15.h,
        // vertical: 9.v,
      ),
      decoration: AppDecoration.outlineCyan.copyWith(
        borderRadius: BorderRadiusStyle.circleBorder24,
      ),
      child:  ThemeTextFormField(
        child: TextFormField(
          controller: companyDescriptionController,
          focusNode: focusNode,
          // textDirection: DIManager.findDep<ApplicationCubit>().appLanguage.languageCode == AppConsts.LANG_AR? TextDirection.rtl:TextDirection.ltr,
          maxLines: null,
          validator: (text) {
            if (text == null || text.isEmpty) {
              return AppLocalizations.of(context)!.field_is_empty;
            }
            return null;
          },
          maxLength: 600,
          onChanged: (text) {
            setState(() {
              companyDescriptionController.text = text;
            });
          },
          // cursorColor: AppColorsController().scaffoldBGColor,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'وصف للشركة',counterStyle: TextStyle(color: appTheme.black900),
            suffix: suffix(context: context,content: 'وصف للشركة',),
            hintStyle: themeLite
                .textTheme.bodyMedium!.copyWith(color: Colors.grey), // زيادة التباعد الرأسي لزيادة ارتفاع الحقل
          ),
          // onChanged: (value) {
          //   setState(() {
          //     // aboutMeValue = value;
          //   });
          // },
        ),
      ),
    );
  }

  List<ActivityCompanyList>? activityCompanyList=[];
  String activityCompanyTitle ='';
  int? activityCompanyId;
  int indexActivityCompany = 0; // متغير عام داخل الـ State
  int indexSubActivityCompany = 0; // متغير عام داخل الـ State

  String subActivityCompanyTitle ='';

  int? subActivityCompanyId;

  Widget _buildActivityCompany() {
    if (activityCompanyList == null || activityCompanyList!.isEmpty) {
      return Container();
    }

    final selectedActivity = activityCompanyList![indexActivityCompany];

    activityCompanyTitle = selectedActivity.name ?? '';
    activityCompanyId = selectedActivity.id ?? 0;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<ActivityCompanyList>(
        value: selectedActivity,
        dropdownColor: appTheme.lightBlue100,
          onChanged: (newValue) {
            final newIndex = activityCompanyList!.indexOf(newValue!);

            // تحديث قائمة sub بناءً على النشاط الجديد
            List<SubCategoryModel>? newSubList = newValue.subcategories; // تأكد أن كل عنصر من activityCompanyList يحتوي على هذه القائمة

            setState(() {
              // النشاط الرئيسي
              activityCompanyTitle = newValue.name ?? '';
              activityCompanyId = newValue.id ?? 0;
              indexActivityCompany = newIndex;

              // النشاط الفرعي
              if (newSubList.isNotEmpty) {
                subActivityCompanyTitle = newSubList[0].title ?? '';
                subActivityCompanyId = newSubList[0].id;
                indexSubActivityCompany = 0;
              } else {
                subActivityCompanyTitle = '';
                subActivityCompanyId = null;
                indexSubActivityCompany = 0;
              }
            });
          }
,
          items: activityCompanyList!.map((data) {
          return DropdownMenuItem(
            value: data,
            child: Text(data.name ?? '', style: TextStyle(color: appTheme.black900)),
          );
        }).toList(),
        decoration: InputDecoration(
          label: Container(
            decoration: AppDecoration.pointChoose,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: textNormal(text: 'نشاط الشركة الحالي ($activityCompanyTitle)'),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: appTheme.buttonColorBorder, width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: appTheme.buttonColorBorder, width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          filled: true,
          fillColor: appTheme.lightBlue100,
        ),
      ),
    );
  }

  Widget _buildSubActivityCompany() {
    final subcategories = activityCompanyList?[indexActivityCompany].subcategories ?? [];

    if (subcategories.isEmpty) return Container();

    // // ابحث عن العنصر الفرعي المختار بناءً على id المحفوظ
    // final selectedSubCategory = subcategories.firstWhere(
    //       (sub) => sub.id == widget.companyData!.id,
    //   orElse: () => subcategories[0],
    // );

    // subActivityCompanyTitle = subcategories[indexSubActivityCompany].title ?? '';
    // subActivityCompanyId =  subcategories[indexSubActivityCompany].id ?? 0;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<SubCategoryModel>(
        value: subcategories[indexSubActivityCompany],
        dropdownColor: appTheme.lightBlue100,
        onChanged: (newValue) {
          setState(() {
            subActivityCompanyTitle = newValue?.title ?? '';
            subActivityCompanyId = newValue?.id ?? 0;
            indexSubActivityCompany = subcategories.indexWhere((element) => element.id == newValue?.id);
          });
          print('Selected Subcategory: $subActivityCompanyTitle, ID: $subActivityCompanyId');
        },

        items: subcategories.map((value) {
          return DropdownMenuItem(
            value: value,
            child: Text(
              value.title ?? '',
              style: TextStyle(color: appTheme.black900),
            ),
          );
        }).toList(),
        decoration: InputDecoration(
          label: Container(
            decoration: AppDecoration.pointChoose,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: textNormal(text: 'نشاط الشركة الفرعي'),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: appTheme.buttonColorBorder, width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: appTheme.buttonColorBorder, width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          filled: true,
          fillColor: appTheme.lightBlue100,
        ),
      ),
    );
  }

  void showPdfFile(context) {
    ProfileCubit cubit = BlocProvider.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double rating = 0.0;
        return AlertDialog(
          backgroundColor: appTheme.lightBlue100,
          title: Center(
              child: Text(
            'اختر طريقة لتقديم الرخصة',
            style: themeLite.textTheme.titleSmall,
          )),
          content: Container(
            height: 95.h,
            child: Column(
              children: [
                //
                // image == null
                //     ? Text(' ')
                //     : Image.file(
                //   image!,
                //   width: 180.h,
                //   height: 180.h,
                // ),
                //

                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        cubit.openCamera();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.w),
                        child: Row(
                          children: [
                            Icon(
                              Icons.camera,
                              color: appTheme.greenColor,
                            ),
                            sizeWidthNormal(),
                            textNormal(
                                text: 'عن طريق الكميرا',
                                fontSize: AppFontSize.fontSize_14),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        cubit.loadImages();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.w),
                        child: Row(
                          children: [
                            Icon(
                              Icons.image,
                              color: appTheme.greenColor,
                            ),
                            sizeWidthNormal(),
                            textNormal(
                                text: 'تحميل صورة مخزنة',
                                fontSize: AppFontSize.fontSize_14),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        cubit.pickPDFAndUpload();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 3.h),
                        child: Row(
                          children: [
                            Icon(
                              Icons.picture_as_pdf,
                              color: appTheme.greenColor,
                            ),
                            sizeWidthNormal(),
                            textNormal(
                                text: 'تحميل ملف PDF',
                                fontSize: AppFontSize.fontSize_14),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                // setState(() {
                //   cubit.fileLicense = null;
                // });
                Navigator.of(context).pop();
              },
            ),
            // image == null?Container(): TextButton(
            //   child: Text('تأكيد', style: TextStyle(color: Colors.green),),
            //   onPressed: () async {
            //     // Save the rating                        // and close the dialog box
            //     Navigator.of(context).pop();
            //   },
            // ),
          ],
        );
      },
    );
  }

  bool isLoadPdf = true;

  Widget _buildButtonProfile(BuildContext context, state) {
    ProfileCubit cubit = BlocProvider.of(context);
    return state is LoadingEditInformationCompanyState
        ? loaderNormal()
        : CustomElevatedButton(
            onPressed: () {

              FocusScope.of(context).unfocus();

              if (_formKey.currentState!.validate()) {


                /*

                 */







                if(activityCompanyId==
                    widget.informationCompany!.data!.user?.business_activity_id&&nameAdminController.text ==
              widget.informationCompany!.data!.user!.ownerName &&licenseNumberController.text ==
                    widget.informationCompany!.data!.user!.licenseNumber &&nameCompanyController.text ==
                    widget.informationCompany!.data!.user!.companyName&& companyDescriptionController.text == widget.informationCompany!.data!.user!.description.toString()&&     selectedCountry == widget.informationCompany!.data!.user!.country.toString()&&  dateTimeController.text ==formattedDate &&fileLicense == null){

                  setState(() {
                    isNotChange =true;
                  });
                }else
                    {
                      setState(() {
                        isNotChange =false;
                      });

                      if(activityCompanyId ==null){
                        SnackBarHelper.mySnackBarError('الرجاء إضافة نشاط للشركة', context);
                        return;
                      }
                      ProfileCubit.get(context).editInformationCompany(
                        commercialLicense:
                        fileLicense == null ? null : File(fileLicense!.path),
                        companyActivity: activityCompanyId,
                        subcategory_id: subActivityCompanyId,
                        companyName: nameCompanyController.text,
                        country: selectedCountry ?? '',
                        expiryDate: dateTimeController.text,companyDescription: companyDescriptionController.text,
                        licenseName: licenseNumberController.text,
                        personName: nameAdminController.text,
                      );
                    }

              }
            },
            width: 208.h,
            text: AppLocalizations.of(context)!.save,
          );
  }
bool isNotChange =false;
  Widget _buildNameAdmin(BuildContext context, focusNode) {
    var lang = Localizations.localeOf(context).languageCode;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15.h,
        // vertical: 9.v,
      ),
      decoration: AppDecoration.outlineCyan.copyWith(
        borderRadius: BorderRadiusStyle.circleBorder24,
      ),
      child: CustomTextFormField(
        width: 308.h,
        validator: (text) {
          if (text == null || text.isEmpty) {
            return AppLocalizations.of(context)!.field_is_empty;
          }
          return null;
        },
        focusNode: focusNode,
        //   textDirection: lang == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        controller: nameAdminController,maxLength: 35,
    suffix: suffix(context: context,content: "اسم الشخص المسؤول"),

        hintText: "اسم الشخص المسؤول",
        // alignment: Alignment.center,
        textInputAction: TextInputAction.done,
        textInputType: TextInputType.text,
        autofocus: false,
      ),
    );
  }

  /// Section Widget
  Widget _buildNameCompany(BuildContext context, focusNode) {
    var lang = Localizations.localeOf(context).languageCode;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15.h,
        // vertical: 9.v,
      ),
      decoration: AppDecoration.outlineCyan.copyWith(
        borderRadius: BorderRadiusStyle.circleBorder24,
      ),
      child: CustomTextFormField(
        width: 308.h,
        validator: (text) {
          if (text == null || text.isEmpty) {
            return AppLocalizations.of(context)!.field_is_empty;
          }
          return null;
        },
        focusNode: focusNode,
        suffix: suffix(context: context,content: "اسم الشركة (كما في الرخصة)"),
        //   textDirection: lang == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        controller: nameCompanyController,maxLength: 35,
        hintText: "اسم الشركة (كما في الرخصة)",
        // alignment: Alignment.center,
        textInputAction: TextInputAction.next,

        textInputType: TextInputType.name,
        onChanged: (text) {
          setState(() {
            nameCompanyController.text = text;
          });
        },
        onSubmitted: (text) {
          setState(() {
            nameCompanyController.text = text;
          });
        },
        autofocus: false,
      ),
    );
  }

  /// Section Widget
  Widget _buildLicenseNumber(BuildContext context, focusNode) {
    var lang = Localizations.localeOf(context).languageCode;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15.h,
        // vertical: 9.v,
      ),
      decoration: AppDecoration.outlineCyan.copyWith(
        borderRadius: BorderRadiusStyle.circleBorder24,
      ),
      child: CustomTextFormField(
        width: 308.h,
        validator: (text) {
          if (text == null || text.isEmpty) {
            return AppLocalizations.of(context)!.field_is_empty;
          }
          return null;
        },
        focusNode: focusNode,
        suffix: suffix(context: context,content:"رقم الرخصة"),

        // textDirection: lang == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        controller: licenseNumberController,
        hintText: "رقم الرخصة",
        // alignment: Alignment.center,
        textInputAction: TextInputAction.done,
        onChanged: (text) {
          setState(() {
            licenseNumberController.text = text;
          });
        },
        onSubmitted: (text) {
          setState(() {
            licenseNumberController.text = text;
          });
        },
        textInputType: TextInputType.name,
        autofocus: false,
      ),
    );
  }

  /// Section Widget
  Widget _buildCountry(BuildContext context, focusNode) {
    var lang = Localizations.localeOf(context).languageCode;
    return Container(
      padding: EdgeInsets.symmetric(
          // horizontal: 15.h,
          // vertical: 9.v,
          ),
      decoration: AppDecoration.outlineCyan.copyWith(
        borderRadius: BorderRadiusStyle.circleBorder24,
      ),
      child: DropdownButtonFormField(
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: appTheme.buttonColorBorder, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: appTheme.buttonColorBorder, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            filled: true,
            fillColor: appTheme.lightBlue100,
          ),
          validator: (value) => value == null ? "يجب أن تختار إمارة" : null,
          dropdownColor: appTheme.lightBlue100,
          hint: textNormal(text: 'الإمارة'),
          value: selectedCountry??'',
          focusNode: focusNode,
          onChanged: (String? newValue) {
            setState(() {
              selectedCountry = newValue!;
            });
          },
          items: dropdownItems),
    );
  }

  /// Section Widget
  Widget _buildPdf(BuildContext context, focusNode, state) {
    var lang = Localizations.localeOf(context).languageCode;
    print( widget.informationCompany!.data!.user!.commercialLicense);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            showPdfFile(context);
            // print( widget.informationCompany!.data!.user!.commercialLicense);
          },

          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(
              horizontal: 15.h,
              // vertical: 9.v,
            ),
            decoration: AppDecoration.outlineCyan.copyWith(
              borderRadius: BorderRadiusStyle.circleBorder24,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: textNormal(
                  text: 'تحميل الرخصة التجارية', fontWeight: FontWeight.w200),
            ),
          ),
        ),

sizeHeightNormal(),
        // _isPDF(AppEndpoints.baseImageUrl+ widget.informationCompany!.data!.user!.commercialLicense.toString())?:

        if(fileLicense == null)...{
          InkWell(
            onTap: () {
              navigatorToPush(context: context,
                  pageName: ShowCommercialLicense(
                      commercialLicense:widget.informationCompany!.data!.user!
                          .commercialLicense.toString().contains('http')?widget.informationCompany!.data!.user!
                          .commercialLicense.toString(): AppEndpoints.baseUrlWithoutApi +
                          widget.informationCompany!.data!.user!
                              .commercialLicense.toString(),
                      isPdf: isPDF(widget.informationCompany!.data!.user!
                          .commercialLicense.toString().contains('http')?widget.informationCompany!.data!.user!
                          .commercialLicense.toString(): AppEndpoints.baseUrlWithoutApi +
                          widget.informationCompany!.data!.user!
                              .commercialLicense.toString())));
            },
            child: isPDF(widget.informationCompany!.data!.user!
                .commercialLicense.toString().contains('http')?widget.informationCompany!.data!.user!
                .commercialLicense.toString(): AppEndpoints.baseUrlWithoutApi +
                widget.informationCompany!.data!.user!
                    .commercialLicense.toString()) ?
            Column(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgPDF,
                  // width: 60.w,
                  height: 40.w,
                  fit: BoxFit.fill,
                ),
                // textNormal(text: '.pdf'),
              ],
            ) : CustomImageView(
              imagePath: widget.informationCompany!.data!.user!.commercialLicense
        .toString().contains('http')?widget.informationCompany!.data!.user!.commercialLicense
                  .toString(): AppEndpoints.baseUrlWithoutApi +
                  widget.informationCompany!.data!.user!.commercialLicense
                      .toString(),
              width: 120.w,
              height: 140.w,
              fit: BoxFit.fill,
            ),
          ),
        }else...{
          InkWell(
            onTap: () {
              navigatorToPush(context: context,
                  pageName: ShowCommercialLicense(
                      commercialLicense: fileLicense!.path,
                      isPdf: isPDF(fileLicense!.path)));
            },
            child: isPDF(fileLicense!.path) ?
            Column(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgPDF,
                  // width: 60.w,
                  height: 40.w,
                  fit: BoxFit.fill,
                ),
                // textNormal(text: '.pdf'),
              ],
            ) : CustomImageView(
              imagePath: fileLicense!.path,
              width: 120.w,
              height: 140.w,
              fit: BoxFit.fill,
            ),
          ),
        }

      ],
    );
  }
  DateTime selectedDate = DateTime.now();

  /// Section Widget
  Widget _buildDateEnd(BuildContext context) {
    var lang = Localizations.localeOf(context).languageCode;
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        InkWell(
          onTap: () async {
            selectedDate = (await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              cancelText: AppLocalizations.of(context)!.cancel,
              confirmText: AppLocalizations.of(context)!.sure,
              helpText: AppLocalizations.of(context)!.choose_date,
              builder: (context, child) {
                return Theme(
                  data: ThemeData.light(), // This will change to light theme.
                  child: child!,
                );
              },
            ))!;
            if (selectedDate != null) {
              print(
                  'Selected date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}');
              String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
              setState(() {
                dateTimeController.text =
                    formattedDate; //set output date to TextField value.
              });
            }
          },
          child: Container(
            height: 40.h,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(
              horizontal: 15.h,
              // vertical: 9.v,
            ),
            decoration: AppDecoration.outlineCyan.copyWith(
              borderRadius: BorderRadiusStyle.circleBorder24,
            ),
            child: dateTimeController.text == ''
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 10.h),
                    child: textNormal(
                        text: AppLocalizations.of(context)!.choose_date_license, fontWeight: FontWeight.w200),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.h),
                    child: textNormal(
                        text: dateTimeController.text, fontWeight: FontWeight.w200),
                  ),

          ),
        ),
        Padding(
          padding:  EdgeInsets.only(left: 15.w,right: 15.w),
          child: suffix(context: context,content:AppLocalizations.of(context)!.choose_date_license),
        ),
      ],
    );
  }

  bool isObscureText = false;
}
