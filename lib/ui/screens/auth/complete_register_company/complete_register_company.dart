import 'dart:io';
import 'dart:ui';
import 'package:syrians_in_uae/core/constants/app_font.dart';
import 'package:syrians_in_uae/core/helper/snack_bar_helper.dart';
import 'package:syrians_in_uae/data/models/company/activity_company_model.dart';
import 'package:syrians_in_uae/ui/screens/auth/register/cubit/cubit.dart';
import 'package:syrians_in_uae/ui/screens/auth/register/cubit/status.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/di_manager.dart';
import '../../../../core/shared_prefs/shared_prefs.dart';
import '../../../../core/utils/image_constant.dart';
import '../../../../data/models/add_ad_new/category_model.dart';
import '../../../../data/models/auth/register/register_company_from_data.dartregister_from_data.dart';
import 'package:syrians_in_uae/core/link_app.dart';
import '../../../../widgets/custom_elevated_button.dart';
import '../../../../widgets/custom_image_view.dart';
import '../../../../widgets/custom_text_form_field.dart';
import '../../../../widgets/loader_for_page.dart';
import '../../../app_general_bloc/handel_android_app.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/theme_helper.dart';
import '../../../theme/theme_text_form_field.dart';
import '../../../widget/back_ground_Auth.dart';
import '../../../widget/url_webview.dart';
import '../../company/info_company.dart';

import '../login/model_home_page.dart';

class CompleteRegisterCompany extends StatefulWidget {
  CompleteRegisterCompany({super.key,this.mobileNumber,required this.isTransferUserToCompany, this.activityCompanyList});
  String? mobileNumber;
  bool? isTransferUserToCompany;
  List<ActivityCompanyList>? activityCompanyList=[];
  @override
  State<CompleteRegisterCompany> createState() =>
      _CompleteRegisterCompanyState();
}

class _CompleteRegisterCompanyState extends State<CompleteRegisterCompany> {
  TextEditingController companyBusinessController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  TextEditingController nameAdminController = TextEditingController();
  TextEditingController licenseNumberController = TextEditingController();
  TextEditingController nameCompanyController = TextEditingController();
  TextEditingController companyDescriptionController = TextEditingController();
  TextEditingController dateTimeController = TextEditingController();
  final FocusNode _firstFocusNode = FocusNode();
  final FocusNode _secondFocusNode = FocusNode();
  final FocusNode _thirdFocusNode = FocusNode();
  final FocusNode _fordFocusNode = FocusNode();
  final FocusNode _fifthFocusNode = FocusNode();
  final FocusNode _sixthFocusNode = FocusNode();
  final FocusNode _seventhFocusNode = FocusNode();
  final FocusNode _companyDescriptionControllerFocusNode = FocusNode();
  List<Offset> _points = [];
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isPressing = false;
  bool isPressing2 = false;
  bool isCompany = false;

  XFile? fileLicense;
  String? selectedCountry;

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

  HomePageLoginModel? homePageData;
  Future<void> loadData() async {
    homePageData = await getDataHomePage();
    if (homePageData != null) {
      print("homePageData : ${homePageData!.homePageModel!.data!.adsBanner.length}");
    } else {
      print("لا توجد بيانات مخزنة.");
    }
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('${widget.mobileNumber}');

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: HandelAndroidApp(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery
                  .of(context)
                  .viewInsets
                  .bottom,
            ),
            child: Form(
              key: _formKey,
              child: SizedBox(
                width: double.maxFinite,
                child: Column(
                  children: [
                    BackGroundAuthNotAllScreen(

                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 28.h,
                        vertical: 7.w,
                      ),
                      child: BlocProvider(
                        create: (context) => RegisterCubit(),
                        child: BlocConsumer<RegisterCubit, RegisterStates>(
                          listener: (context, state) {

                            if(state is ErrorRegisterCompanyState){
                              SnackBarHelper.mySnackBarError(state.error, context);
                            }
                            if(state is ErrorLoadFileState) {
                              SnackBarHelper.mySnackBarSuccess('يوجد خطأ برفع الصورة', context);
                            }
                            if (state is ErrorLoginState) {
                              SnackBarHelper.mySnackBarError(
                                  state.error.toString(), context);
                            }
                            if(state is SuccessRegisterCompanyState){
                              SnackBarHelper.mySnackBarSuccess(state.registerCompanyModel.message, context);
                              RegisterCubit.get(context).login('971${widget.mobileNumber}', passwordController.text);

                              // navigatorToPushReplacementUntil(context: context, pageName: LoginScreen());
                            }

                            if(state is SuccessTransferUserToCompanyState){
                              DIManager.findDep<SharedPrefs>().setAccountType('company');
                              SnackBarHelper.mySnackBarSuccess(state.registerCompanyModel.message, context);
                              navigatorToPushReplacementUntil(context: context, location: '/homePage',
                                  extra: homePageData
                                  // extra:DIManager.findDep<SharedPrefs>().getDataHomePage()
                              );
                            }


                            if(state is UpToOneMegaLoadFileState) {
                              print('sadddddddddddddddd');
                              SnackBarHelper.mySnackBarError('خطأ: الحجم يجب أن يكون أصغر من 1 ميغا', context);
                            }
                            if (state is SuccessLoginState) {
                              DIManager.findDep<SharedPrefs>()
                                  .setUserInformation(
                                companyIsActive2:
                                state.loginModel.data!.user!.isActive ??
                                    '',
                                userNameCompany2:
                                state.loginModel.data!.user!.companyName,
                                mobileNumber2:
                                state.loginModel.data!.user!.mobile,
                                accountType2:
                                state.loginModel.data!.user!.accountType,
                                token: state.loginModel.data!.accessToken,
                                status: state.loginModel.data!.user!.status,
                                imageProfile2:
                                state.loginModel.data!.user!.profilePic,
                                userID2: int.parse(
                                    state.loginModel.data!.user!.userId!),
                                userNamePerson2:
                                state.loginModel.data!.user!.userName,
                                createdAd2:
                                state.loginModel.data!.user!.createdAt,
                                joinedAd2:
                                state.loginModel.data!.user!.joinedAt,
                                ratingUser2:
                                state.loginModel.data!.user!.rating,
                                membershipNumberValue: state.loginModel.data!.user!.membershipNumber,
                              );

                              navigatorToPushReplacementUntil(
                                  context: context,
                                 location: '/homePage',
                                  extra: homePageData
                                  // extra:DIManager.findDep<SharedPrefs>().getDataHomePage()
                              );

                            }
                            if(state is SuccessLoadFileState){
                              fileLicense =state.fileLicense;
                              isLoadPdf =true;
                              SnackBarHelper.mySnackBarSuccess('تم تحميل الرخصة بنجاح', context);
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
                                _buildPdf(context, _fordFocusNode,state),
                                // SizedBox(height: 20.h),
                                // _buildCompanyActive(context, _fifthFocusNode),
                                SizedBox(height: 20.h),
                                _buildActivityCompany(),
                                _buildSubActivityCompany(),
                                SizedBox(height: 20.h),
                                _buildDateEnd(context),
                                SizedBox(height: 20.h),
                                _buildDescriptionCompany(context, _companyDescriptionControllerFocusNode),
                                SizedBox(height: 20.h),
                                _buildPassword(context, _sixthFocusNode),
                                SizedBox(height: 20.h),
                                _buildAccept(),
                                SizedBox(height: 12.h),
                                isPressingAccept
                                    ? Row(
                                  children: [
                                    textNormal(
                                      text:
                                      'الرجاء الموافقة على',),
                                    InkWell(
                                      onTap: (){
                                        navigatorToPush(
                                            context: context,
                                            pageName: UrlWebViewPage(
                                              urlPage: DIManager.findDep<SharedPrefs>().getTermsLink(),
                                              titleAppBer: 'الأحكام والشروط',
                                            ));
                                      },
                                      child: textNormal(
                                          text:
                                          ' الشروط وسياسة التطبيق',
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ],
                                )
                                    : Container(),
                                _buildButtonRegister(context,state),
                                SizedBox(height: 15.h),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String activityCompanyTitle ='';
  int? activityCompanyId;
  String subActivityCompanyTitle ='';
  int? subActivityCompanyId;
  int indexActivityCompany =0;
  Widget _buildActivityCompany(){
    return widget.activityCompanyList==null?Container(): widget.activityCompanyList!.isEmpty
        ? Container()
        : Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<
          ActivityCompanyList>(
        value: widget.activityCompanyList![0],
        dropdownColor: appTheme.lightBlue100,
        onChanged: (newValue) {
          setState(() {
            activityCompanyTitle = newValue?.name ?? '';
            activityCompanyId = newValue?.id ?? 0;
            subActivityCompanyTitle ='';
            subActivityCompanyId = null;
            indexActivityCompany = widget.activityCompanyList!
                .indexWhere((element) => element.id == newValue?.id);
          });

          print('activityCompanyId: $activityCompanyId');
          print('activityCompanyId: $activityCompanyId');
          print('activityCompanyId: $activityCompanyId');
        },
        items: widget.activityCompanyList!
            .map((emirateData) {
          return DropdownMenuItem(
            value: emirateData,
            child: Text(
              emirateData.name ?? '',
              style: TextStyle(
                  color:  appTheme.black900),
            ), // Displaying title
          );
        }).toList(),
        decoration: InputDecoration(
          // labelText: ' نشاط الشركة الحالي ($activityCompanyTitle)',
          label: Container(
            decoration: AppDecoration.pointChoose,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: textNormal(text:'نشاط الشركة',),
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

  Widget _buildSubActivityCompany(){
    return widget.activityCompanyList==null || widget.activityCompanyList!.isEmpty?Container(): widget.activityCompanyList![indexActivityCompany].subcategories.length==0
        ? Container()
        : Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<
          SubCategoryModel>(
        value: widget.activityCompanyList![indexActivityCompany].subcategories[0],
        dropdownColor: appTheme.lightBlue100,
        onChanged: (newValue) {
          setState(() {
            subActivityCompanyTitle = newValue?.title ?? '';
            subActivityCompanyId = newValue?.id ?? 0;
          });
          print('subActivityCompanyId: $subActivityCompanyId');
          print('subActivityCompanyId: $subActivityCompanyId');
          print('subActivityCompanyId: $subActivityCompanyId');
        },
        items:widget.activityCompanyList![indexActivityCompany].subcategories
            .map((value) {
          return DropdownMenuItem(
            value: value,
            child: Text(
              value.title ?? '',
              style: TextStyle(
                  color:  appTheme.black900),
            ), // Displaying title
          );
        }).toList(),
        decoration: InputDecoration(
          // labelText: ' نشاط الشركة الحالي ($activityCompanyTitle)',
          label: Container(
            decoration: AppDecoration.pointChoose,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: textNormal(text:'نشاط الشركة',),
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
  Widget _buildAccept() {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          // IconButton(onPressed: (){}, icon: Icon(Icons.check_circle_outlined)),
          Container(
            decoration: AppDecoration.pointCyan.copyWith(
              borderRadius: BorderRadiusStyle.circleBorder24,
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  isPressing = !isPressing;
                });
              },
              child: CircleAvatar(
                radius: 8,
                backgroundColor:  appTheme.greenColor.withOpacity(0.7),
                child: Container(
                  width: 13.r,
                  height: 13.r,
                  decoration: BoxDecoration(
                      color: isPressing
                          ?  appTheme.greenColor.withOpacity(0.7)
                          : Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10.r))),
                ),
              ),
            ),
          ),
          sizeWidthNormal(),
          Row(
            children: [
              textNormal(
                text:
                'الرجاء الموافقة على',),
              InkWell(
                onTap: (){
                  navigatorToPush(
                      context: context,
                      pageName: UrlWebViewPage(
                        urlPage: DIManager.findDep<SharedPrefs>().getTermsLink(),
                        titleAppBer: 'الأحكام والشروط',
                      ));
                },
                child: textNormal(
                    text:
                    ' الشروط وسياسة التطبيق',
                    color: Colors.blue,
                    decoration: TextDecoration.underline),
              ),
            ],
          )
        ],
      ),
    );
  }

  void showPdfFile(context) {
    RegisterCubit cubit = BlocProvider.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double rating = 0.0;
        return AlertDialog(
          backgroundColor: appTheme.scaffoldBackgroundColor100,
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

  bool isPressingAccept = false;
  Widget _buildButtonRegister(BuildContext context,state) {
    RegisterCubit cubit = BlocProvider.of(context);
    return  state is LoadingRegisterCompanyState
        ? loaderNormal()
        :  CustomElevatedButton(
      onPressed: () {
        FocusScope.of(context).unfocus();
        if (_formKey.currentState!.validate()) {
          if(widget.isTransferUserToCompany == true){}else{}
          if(fileLicense == null || dateTimeController.text =='') {
          if(fileLicense == null) {
            setState(() {
              isLoadPdf = false;
            });
          }

          if( dateTimeController.text ==''){
            setState(() {
              isDateEndSelected = false;
            });
          }

          }else {
            if (isPressing == true) {
              setState(() {
                isPressingAccept = false;
              });

              if(widget.isTransferUserToCompany == true){

                RegisterCubit.get(context).transferUserToCompany(
                    transferUserToCompanyFromDataCompany: RegisterFromDataCompany(
                      password: passwordController.text,
                      mobile:'${widget.mobileNumber}',
                      // mobile:'971559075504',
                      accountType: 'company',

                      commercialLicense: File(fileLicense!.path),
                      // companyActivity: companyBusinessController.text,
                      companyName: nameCompanyController.text,
                      companyDescription: companyDescriptionController.text,
                      country
                          :selectedCountry,
                      expiryDate
                          :dateTimeController.text,
                      licenseNumber
                          :licenseNumberController.text,
                      personName: nameAdminController.text,
                    ));
              }else{

                if(activityCompanyId == null){
                  SnackBarHelper.mySnackBarError("الرجاء اختيار نشاط الشركة", context);
                  return;
                }
                RegisterCubit.get(context).registerCompany(
                    registerFromDataCompany: RegisterFromDataCompany(
                      password: passwordController.text,
                      mobile:'971${widget.mobileNumber}',
                      // mobile:'971559075504',
                      accountType: 'company',
                      commercialLicense: File(fileLicense!.path),
                      business_activity_id: activityCompanyId,
        subActivityCompanyId: subActivityCompanyId,
                      // companyActivity: companyBusinessController.text,
                      companyName: nameCompanyController.text,
                      companyDescription: companyDescriptionController.text,
                      country
                          :selectedCountry,
                      expiryDate
                          :dateTimeController.text,
                      licenseNumber
                          :licenseNumberController.text,
                      personName: nameAdminController.text,
                    ));
              }



            } else {
              setState(() {
                isPressingAccept = true;
              });
            }
          }



        }

      },
      width: 208.w,
      text: "إكمال التسجيل",
    );
  }



  Widget _buildNameAdmin(BuildContext context, focusNode) {
    var lang = Localizations
        .localeOf(context)
        .languageCode;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15.h,
        // vertical: 9.v,
      ),
      decoration: AppDecoration.outlineCyan,
      child: CustomTextFormField(
        width: 308.w,
        validator: (text) {
          if (text == null || text.isEmpty) {
            return AppLocalizations.of(context)!.field_is_empty;
          }
          return null;
        },
        focusNode: focusNode,
        //   textDirection: lang == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        controller: nameAdminController,
        hintText: "اسم الشخص المسؤول",maxLength: 35,
        // alignment: Alignment.center,
        textInputAction: TextInputAction.next,
        textInputType: TextInputType.text,
        autofocus: false,
      ),
    );
  }

  /// Section Widget
  Widget _buildNameCompany(BuildContext context, focusNode) {
    var lang = Localizations
        .localeOf(context)
        .languageCode;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15.h,
        // vertical: 9.v,
      ),
      decoration: AppDecoration.outlineCyan,
      child: CustomTextFormField(
        width: 308.w,
        validator: (text) {
          if (text == null || text.isEmpty) {
            return AppLocalizations.of(context)!.field_is_empty;
          }
          return null;
        },
        focusNode: focusNode,
        //   textDirection: lang == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        controller: nameCompanyController,maxLength: 35,
        hintText: "اسم الشركة (كما في الرخصة)",
        // alignment: Alignment.center,
        textInputAction: TextInputAction.next,
        textInputType: TextInputType.name,
        autofocus: false,
      ),
    );
  }

  /// Section Widget
  Widget _buildLicenseNumber(BuildContext context, focusNode) {
    var lang = Localizations
        .localeOf(context)
        .languageCode;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15.h,
        // vertical: 9.v,
      ),
      decoration: AppDecoration.outlineCyan,
      child: CustomTextFormField(
        width: 308.w,
        validator: (text) {
          if (text == null || text.isEmpty) {
            return AppLocalizations.of(context)!.field_is_empty;
          }
          return null;
        },
        focusNode: focusNode,
        // textDirection: lang == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        controller: licenseNumberController,
        hintText: "رقم الرخصة",
        // alignment: Alignment.center,
        textInputAction: TextInputAction.done,
        textInputType: TextInputType.name,
        autofocus: false,
      ),
    );
  }

  /// Section Widget
  Widget _buildCountry(BuildContext context, focusNode) {
    var lang = Localizations
        .localeOf(context)
        .languageCode;
    return Container(
      padding: EdgeInsets.symmetric(
        // horizontal: 15.h,
        // vertical: 9.v,
      ),
      decoration: AppDecoration.outlineCyan,
      child: DropdownButtonFormField(
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: appTheme.buttonColorBorder, width: 2),
              borderRadius: BorderRadius.circular(20.r),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: appTheme.buttonColorBorder, width: 2),
              borderRadius: BorderRadius.circular(20.r),
            ),
            filled: true,
            fillColor: appTheme.lightBlue100,
          ),
          validator: (value) => value == null ? "يجب أن تختار إمارة" : null,
          dropdownColor: appTheme.lightBlue100,
          hint: textNormal(text: 'الإمارة'),

          value: selectedCountry,
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
  Widget _buildPdf(BuildContext context, focusNode,state) {
    var lang = Localizations
        .localeOf(context)
        .languageCode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            showPdfFile(context);
          },
          child: Container(width: MediaQuery
              .of(context)
              .size
              .width,
            padding: EdgeInsets.symmetric(
              horizontal: 15.h,
              // vertical: 9.v,
            ),
            decoration: AppDecoration.outlineCyan,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 10.h, vertical: 10.w
              ),
              child: textNormal(text: 'تحميل الرخصة التجارية',
                  fontWeight: FontWeight.w200),
            ),
          ),
        ),
        !isLoadPdf?sizeHeightNormal():Container(),
        !isLoadPdf?textNormal(text: 'يجب تحميل الرخصة',color: appTheme.red300):Container(),
        state is SuccessLoadFileState ? sizeHeightNormal(height: 12.h) :Container() ,


        state is SuccessLoadFileState ? InkWell(
          onTap: (){

            navigatorToPush(context: context, pageName: ShowCommercialLicense(commercialLicense: fileLicense!.path,
                isPdf: isPDF(fileLicense!.path)));
          },
          child:isPDF(fileLicense!.path)?
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
          ): CustomImageView(
            imagePath: fileLicense!.path,
            width: 120.w,
            height: 140.w,
            fit: BoxFit.fill,
          ),
        ): Container(),
      ],
    );
  }
bool isLoadPdf =true;

  /// Section Widget
  Widget _buildCompanyActive(BuildContext context, focusNode) {
    var lang = Localizations
        .localeOf(context)
        .languageCode;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15.h,
        // vertical: 9.v,
      ),
      decoration: AppDecoration.outlineCyan,
      child: ThemeTextFormField(
        child: TextFormField(
          controller: companyBusinessController,
          focusNode: focusNode,
          // textDirection: DIManager.findDep<ApplicationCubit>().appLanguage.languageCode == AppConsts.LANG_AR? TextDirection.rtl:TextDirection.ltr,
          maxLines: null, validator: (text) {
          if (text == null || text.isEmpty) {
            return AppLocalizations.of(context)!.field_is_empty;
          }
          return null;
        },
          maxLength: 600,
          // cursorColor: AppColorsController().scaffoldBGColor,
          decoration: InputDecoration(
            border: InputBorder.none,counterStyle: TextStyle(color: appTheme.black900),
            hintText: "نشاط الشركة",
            hintStyle: themeLite.textTheme.bodyMedium!.copyWith(color: Colors.grey), // زيادة التباعد الرأسي لزيادة ارتفاع الحقل
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

  /// Section Widget
  Widget _buildDescriptionCompany(BuildContext context, focusNode) {
    var lang = Localizations
        .localeOf(context)
        .languageCode;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15.h,
        // vertical: 9.v,
      ),
      decoration: AppDecoration.outlineCyan,
      child:  ThemeTextFormField(
        child: TextFormField(
          controller: companyDescriptionController,
          focusNode: focusNode,
          // textDirection: DIManager.findDep<ApplicationCubit>().appLanguage.languageCode == AppConsts.LANG_AR? TextDirection.rtl:TextDirection.ltr,
          maxLines: null, validator: (text) {
          if (text == null || text.isEmpty) {
            return AppLocalizations.of(context)!.field_is_empty;
          }
          return null;
        },
          maxLength: 600,
          // cursorColor: AppColorsController().scaffoldBGColor,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'وصف للشركة',counterStyle: TextStyle(color: appTheme.black900),
         hintStyle: themeLite.textTheme.bodyMedium!.copyWith(color: Colors.grey), // زيادة التباعد الرأسي لزيادة ارتفاع الحقل
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

  DateTime selectedDate = DateTime.now();

  /// Section Widget
  Widget _buildDateEnd(BuildContext context) {
    var lang = Localizations
        .localeOf(context)
        .languageCode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () async {

            selectedDate = (await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
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
              print('Selected date: ${DateFormat('yyyy-MM-dd').format(
                  selectedDate)}');
              String formattedDate =
              DateFormat('yyyy-MM-dd').format(selectedDate);
              setState(() {
                dateTimeController.text =
                    formattedDate; //set output date to TextField value.
                isDateEndSelected =true;
              });

            }
          },
          child: Container(
            height: 40.h,
            width: MediaQuery
                .of(context)
                .size
                .width,
            padding: EdgeInsets.symmetric(
              horizontal: 15.h,
              // vertical: 9.v,
            ),
            decoration: AppDecoration.outlineCyan,
            child: dateTimeController.text == '' ? Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 10.w, horizontal: 10.h
              ),
              child: textNormal(text: AppLocalizations.of(context)!.choose_date_license,
                  fontWeight: FontWeight.w200,color: Colors.grey),
            ) : Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 10.w, horizontal: 10.h
              ),
              child: textNormal(text: dateTimeController.text,
                  fontWeight: FontWeight.w200),),
            // child: CustomTextFormField(
            //   width: 308.h,
            //   focusNode: focusNode,readOnly: true,
            //   validator: (text) {
            //     if (text == null || text.isEmpty) {
            //       return AppLocalizations.of(context)!.field_is_empty;
            //     }
            //     return null;
            //   },
            // //   textDirection: lang == 'ar' ? TextDirection.rtl : TextDirection.ltr,
            //   controller: licenseNumberController,
            //   hintText: "تاريخ انتهاء الرخصة",
            //   // alignment: Alignment.center,
            //   textInputAction: TextInputAction.done,
            //   textInputType: TextInputType.visiblePassword,
            //   autofocus: false,
            // ),
          ),
        ),
        !isDateEndSelected?sizeHeightNormal():Container(),
        !isDateEndSelected?textNormal(text: AppLocalizations.of(context)!.choose_date_license2,color: appTheme.red300):Container(),
      ],
    );
  }

  bool isObscureText = false;
  bool isDateEndSelected = true;

  /// Section Widget
  Widget _buildPassword(BuildContext context, focusNode) {
    var lang = Localizations
        .localeOf(context)
        .languageCode;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15.h,
        // vertical: 9.v,
      ),
      decoration: AppDecoration.outlineCyan,
      child: CustomTextFormField(
        width: 308.h,
        focusNode: focusNode,
          obscureText:isObscureText,
        validator: (text) {
          if (text == null || text.isEmpty) {
            return AppLocalizations.of(context)!.field_is_empty;
          }
          if (text.length < 8) {
            return 'يجب كلمة السر أن تكون أكثر من 8 أحرف';
          }
          return null;
        },
        //   textDirection: lang == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        controller: passwordController,
        hintText: "كلمة المرور",
        // alignment: Alignment.center,
        textInputAction: TextInputAction.done,

        suffix: InkWell(
          onTap: (){
            setState(() {
              isObscureText =!isObscureText;
            });
          },
              child: Container(
                        margin: EdgeInsets.fromLTRB(6.h, 9, 15.h, 9),
                        child: CustomImageView(
              imagePath: ImageConstant.iconEyes,
              height: 27.h,
              width: 20.h,
              color: appTheme.greenColor,
              margin: EdgeInsets.only(left: 6.w),
                        ),
                      ),
            ),
        suffixConstraints: lang == 'ar'
            ? null
            : BoxConstraints(
          maxHeight: 48.h,
        ),
        prefix:Container(
          margin: EdgeInsets.fromLTRB(6.h, 9, 15.h, 9),
          child: CustomImageView(
            imagePath: ImageConstant.imgLocation,
            height: 20.h,
            width: 17.h,color: appTheme.greenColor,
            margin: EdgeInsets.only(left: 6.w),
          ),
        ),
        // focusNode: FocusNode(),
        prefixConstraints: lang == 'en'
            ? null
            : BoxConstraints(
          maxHeight: 48.h,
        ),
        textInputType: TextInputType.visiblePassword,
        autofocus: false,
      ),
    );
  }
}
