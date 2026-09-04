import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syrians_in_uae/core/di/di_manager.dart';
import 'package:syrians_in_uae/core/shared_prefs/shared_prefs.dart';
import 'package:syrians_in_uae/core/utils/size_utils.dart';
import 'package:syrians_in_uae/data/models/profile_company/information_company.dart';
import 'package:syrians_in_uae/ui/screens/profile/cubit/cubit.dart';
import 'package:syrians_in_uae/ui/screens/profile/cubit/status.dart';
import 'package:syrians_in_uae/widgets/custom_image_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
// import '../../../l10n/app_localizations.dart';

import 'package:syrians_in_uae/core/link_app.dart';

// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart' ;
import '../../../core/constants/app_font.dart';
import '../../../core/utils/image_constant.dart';
import '../../../core/utils/endpoints.dart';
import '../../../widgets/components.dart';
import '../../app_general_bloc/handel_android_app.dart';
import '../../theme/app_decoration.dart';
import '../../theme/theme_helper.dart';

class InformationCompanyPage extends StatefulWidget {
  InformationCompanyPage(
      {super.key, this.informationCompany, this.createAt, this.joinAt});

  ProfileInformationCompanyModel? informationCompany;
  String? createAt;
  String? joinAt;

  @override
  State<InformationCompanyPage> createState() => _InformationCompanyPageState();
}

class _InformationCompanyPageState extends State<InformationCompanyPage> {
  bool isPressing2 = false;

  String? expiryDate;

  String? userId = DIManager.findDep<SharedPrefs>().getUserID();

  bool _isPDF(String url) {
    return url.toLowerCase().endsWith('.pdf');
  }

  @override
  void initState() {
    String createdAt =
        widget.informationCompany!.data!.user!.expiryDate.toString();

    DateTime createdAtDateTime = DateTime.parse(createdAt);

    expiryDate = DateFormat('yyyy-MM-dd').format(createdAtDateTime);
    _isPDF(widget.informationCompany!.data!.user!.commercialLicense.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var info = widget.informationCompany!.data!.user!;
    return HandelAndroidApp(
      child: Scaffold(
        appBar: appBarNormalWithIcon(text: 'ملف الشركة', context: context,isShowBack: true),
        body: SingleChildScrollView(
      child: BlocProvider(
        create: (context) => ProfileCubit(),
        child: BlocConsumer<ProfileCubit, ProfileStates>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return _buildAboutCompany(context, info);
          },
        ),
      ),
            ),
          ),
    );
  }

  // void showChats(BuildContext context, info) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       double rating = 0.0;
  //       return StatefulBuilder(
  //           builder: (BuildContext context, StateSetter setState) {
  //         return AlertDialog(
  //           backgroundColor: appTheme.buttonColor,
  //           content: Container(
  //             // height: 400.h,
  //             child: SfPdfViewer.network(
  //               AppEndpoints.baseUrlWithoutApi + info.commercialLicense.toString(),
  //             ),
  //           ),
  //         );
  //       });
  //     },
  //   );
  // }

  /// Section Widget
  Widget _buildAboutCompany(BuildContext context, User info) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sizeHeightNormal(),
          textNormal(text: 'عن الشركة:',  fontSize: AppFontSize.fontSize_16,),
          sizeHeightNormal(),
          Container(
            width: MediaQuery.of(context).size.width,
            // height: 254.h,
            margin: EdgeInsets.only(left: 2.w, right: 2.w),
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 10.h,
            ),
            decoration: AppDecoration.fillWhiteA.copyWith(
              borderRadius: BorderRadiusStyle.circleBorder40,
              boxShadow: [
                BoxShadow(
                    color: appTheme.buttonColor,
                    blurRadius: 2.h,
                    spreadRadius: 2.h,
                    offset: Offset(0, 0)),
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _textNormalItem(
                    textTitle: 'اسم الشركة: ',
                    textContent: '${info.companyName}'),
                _textNormalItem(
                    textTitle: 'اسم الشخص المسؤول: ',
                    textContent: '${info.ownerName}'),
                _textNormalItem(
                    textTitle: 'رقم الرخصة: ',
                    textContent: '${info.licenseNumber}'),
                InkWell(
                    onTap: () {
                      // showChats(context,info);
                      navigatorToPush(
                          context: context,
                          pageName: ShowCommercialLicense(
                            commercialLicense: info.commercialLicense.toString().contains('http')?info.commercialLicense.toString(): AppEndpoints.baseUrlWithoutApi +
                                info.commercialLicense.toString(),
                            isPdf: _isPDF(info.commercialLicense.toString()),
                          ));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _textNormalItem(
                            textTitle: 'ملف الرخصة التجارية: ',
                            textContent: ''),
                        InkWell(
                          onTap: () {
                            navigatorToPush(
                                context: context,
                                pageName: ShowCommercialLicense(
                                    commercialLicense:
                                    widget.informationCompany!.data!
                                        .user!.commercialLicense
                                        .toString().contains('http') ?widget.informationCompany!.data!
                                        .user!.commercialLicense
                                        .toString():AppEndpoints.baseUrlWithoutApi +
                                            widget.informationCompany!.data!
                                                .user!.commercialLicense
                                                .toString(),
                                    isPdf: isPDF(widget.informationCompany!.data!
                                        .user!.commercialLicense
                                        .toString().contains('http') ?widget.informationCompany!.data!
                                        .user!.commercialLicense
                                        .toString():AppEndpoints.baseUrlWithoutApi +
                                        widget.informationCompany!.data!
                                            .user!.commercialLicense
                                            .toString())));
                          },
                          child: isPDF(widget.informationCompany!.data!
                              .user!.commercialLicense
                              .toString().contains('http') ?widget.informationCompany!.data!
                              .user!.commercialLicense
                              .toString():AppEndpoints.baseUrlWithoutApi +
                              widget.informationCompany!.data!
                                  .user!.commercialLicense
                                  .toString())
                              ? Column(
                                  children: [
                                    CustomImageView(
                                      imagePath: ImageConstant.imgPDF,
                                      // width: 60.w,
                                      height: 40.w,
                                      fit: BoxFit.fill,
                                    ),
                                    // textNormal(text: '.pdf'),
                                  ],
                                )
                              : CustomImageView(
                                  imagePath:widget.informationCompany!.data!.user!
                                      .commercialLicense
                                      .toString().contains('http')?widget.informationCompany!.data!.user!
                                      .commercialLicense
                                      .toString(): AppEndpoints.baseUrlWithoutApi +
                                      widget.informationCompany!.data!.user!
                                          .commercialLicense
                                          .toString(),
                                  width: 120.w,
                                  height: 140.w,
                                  fit: BoxFit.fill,
                                ),
                        ),
                      ],
                    )),
                _textNormalItem(
                    textTitle: 'نشاط الشركة: ',
                    textContent: '${info.companyActivity}'),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textNormal(
                            text: 'عن الشركة: ',
                            fontWeight: FontWeight.w800,
                            color: appTheme.black900,
                            fontSize: 15.fSize),
                        Container(
                            width: 197.w,
                            child: textNormal(
                                text: info.description ??
                                    'أنت بحاجة لإضافة وصف ..',
                                fontWeight: FontWeight.w400,
                                color: appTheme.black900,
                                fontSize: 15.fSize,
                                overflow: TextOverflow.visible)),
                      ],
                    )),
                _textNormalItem(
                    textTitle:
                        '${AppLocalizations.of(context)!.choose_date_license}: ',
                    textContent: expiryDate.toString()),
                sizeHeightNormal(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _textNormalItem(
      {required String textTitle, required String textContent}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.w),
      child: Row(
        children: [
          textNormal(
              text: textTitle,
              fontWeight: FontWeight.w800,
              color: appTheme.black900,
            fontSize: AppFontSize.fontSize_15,),
          Container(
              width: 160.w,
              child: textNormal(
                  text: textContent,
                  fontWeight: FontWeight.w400,
                  color: appTheme.black900,
                fontSize: AppFontSize.fontSize_15,)),
        ],
      ),
    );
  }
}

class ShowCommercialLicense extends StatefulWidget {
  ShowCommercialLicense(
      {super.key,
      required this.commercialLicense,
      required this.isPdf,
       this.isProfile =false,
       this.isNotNeedTitleAppbar =false,
      this.isChats = false});

  String commercialLicense;
  bool isPdf;
  bool isChats = false;
  bool isProfile = false;
  bool isNotNeedTitleAppbar = false;

  @override
  State<ShowCommercialLicense> createState() => _ShowCommercialLicenseState();
}

class _ShowCommercialLicenseState extends State<ShowCommercialLicense> {
  int totalPages = 0;
  int currentPage = 0;
  bool isReady = false;
  late PDFViewController pdfViewController;

  @override
  Widget build(BuildContext context) {
    print(widget.isPdf);
    print(widget.commercialLicense.toString());
    return Scaffold(
      appBar: appBarNormalWithIcon(
        text: widget.isNotNeedTitleAppbar?'':  widget.isProfile?'الصورة الشخصية' :widget.isChats ? 'الدردشة' : 'ملف الرخصة التجارية',
        context: context,
        isShowBack: true,
      ),
      body: widget.isPdf
          ? widget.commercialLicense.toString().startsWith('http')
          ? FutureBuilder<File>(
        future: _downloadPdfFile(widget.commercialLicense.toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return  Center(child: CircularProgressIndicator(color: appTheme.greenColor,),);
          } else if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ أثناء تحميل الملف'));
          } else {
            return PDFView(
              filePath: snapshot.data!.path,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: true,
              pageFling: true,
              defaultPage: 0,
              onRender: (_pages) {
                setState(() {
                  isReady = true;
                  totalPages = _pages!;
                });
              },
              onViewCreated: (PDFViewController vc) {
                pdfViewController = vc;
              },
              onPageChanged: (int? page, int? total) {
                setState(() {
                  currentPage = page!;
                });
              },
              onError: (error) {
                print(error.toString());
              },
              onPageError: (page, error) {
                print('$page: ${error.toString()}');
              },
            )
            ;
          }
        },
      )
          :   PDFView(filePath: widget.commercialLicense.toString(),
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageFling: true,
        defaultPage: 0,
        onRender: (_pages) {
          setState(() {
            isReady = true;
            totalPages = _pages!;
          });
        },
        onViewCreated: (PDFViewController vc) {
          pdfViewController = vc;
        },
        onPageChanged: (int? page, int? total) {
          setState(() {
            currentPage = page!;
          });
        },
        onError: (error) {
          print(error.toString());
        },
        onPageError: (page, error) {
          print('$page: ${error.toString()}');
        },
      )
          : CustomImageView(
        imagePath: widget.commercialLicense.toString(),
      ),
    );
  }


  Future<File> _downloadPdfFile(String url) async {
    final httpClient = HttpClient();
    final request = await httpClient.getUrl(Uri.parse(url));
    final response = await request.close();
    final bytes = await consolidateHttpClientResponseBytes(response);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/temp.pdf');
    await file.writeAsBytes(bytes);
    return file;
  }
}
