///userMetricsCard
//Widget userMetricsCard(context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Container(
//           width: 65.h,
//           height: 85.h,
//           child: Center(
//             child: Stack(
//               // alignment: Alignment.center,
//               children: [
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Container(
//                     width: 65.h,
//                     height: 65.h,
//                     // color: Colors.green,
//                     decoration: AppDecoration.outlineCircular4,
//                     // child: Image.asset(
//                     //     ImageConstant.imgLogoWhite13,),
//                     child: imageCompany == null
//                         ? CustomImageView(
//                             width: 45.h,
//                             height: 45.h,
//                             alignment: Alignment.center,
//                             fit: BoxFit.contain,
//                             radius: BorderRadius.circular(30.h),
//                             placeHolder: ImageConstant.imgPerson,
//                           )
//                         : CustomImageView(
//                             imagePath: imageCompany.toString().contains('http')
//                                 ? imageCompany.toString()
//                                 : AppEndpoints.baseUrlWithoutApi +
//                                     imageCompany.toString(),
//                             width: 50.h,
//                             height: 50.h,
//                             alignment: Alignment.center,
//                             radius: BorderRadius.circular(30.h),
//                             fit: BoxFit.fill,
//                             placeHolder: ImageConstant.imgPerson,
//                           ),
//                   ),
//                 ),
//                 isOwnerAccount()
//                     ? Align(
//                         alignment: Alignment.topLeft,
//                         child: IconButton(
//                             onPressed: () {
//                               // showNumberWhatsapp(context);
//                               ProfileCubit.get(context).loadImages();
//                             },
//                             icon: Icon(
//                               Icons.camera_alt,
//                               color: appTheme.deepPurpleA10001,
//                             )))
//                     : Container(),
//               ],
//             ),
//           ),
//         ),
//         sizeWidthNormal(),
//         Padding(
//           padding: EdgeInsets.only(top: 20.h),
//           child: Column(
//             children: [
//               Text(
//                 companyInformation?[0].companyName.toString() ?? '',
//                 style: themeLite.textTheme.titleSmall!
//                     .copyWith(fontSize: 13.fSize),
//               ),
//               sizeHeightNormal(),
//               Container(
//                 width: 220.w,
//                 child: Row(
//                   children: [
//                     profileOverview(
//                         titleTop: '${followersCount ?? 0}',
//                         titleBottom: 'المتابعين',
//                         onTap: () {
//                           navigatorToPush(
//                               context: context,
//                               pageName: FollowingUsersPage(
//                                 titleAppBar: 'المتابعين',
//                                 isFollowers: true,
//                                 userId: widget.idCompany,
//                               ));
//                         }),
//                     profileOverview(
//                         titleTop: '${followingCount ?? 0}',
//                         titleBottom: 'المتابعون',
//                         onTap: () {
//                           navigatorToPush(
//                               context: context,
//                               pageName: FollowingUsersPage(
//                                 titleAppBar: 'المتابعون',
//                                 isFollowers: false,
//                                 userId: widget.idCompany,
//                               ));
//                         }),
//                     profileOverview(
//                         titleTop: '${adsCount ?? '0'}',
//                         titleBottom: 'الإعلانات',
//                         onTap: () {}),
//                     profileOverview(
//                         titleTop: '${postCount ?? '0'}',
//                         titleBottom: 'منشورات',
//                         onTap: () {}),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Padding(
//           padding: EdgeInsets.only(top: 10.h, right: 1.w),
//           child: PopupMenuButton(
//             padding: EdgeInsets.zero,
//             color: appTheme.lightBlueBottomNavigatorBar,
//             child: Icon(
//               Icons.more_vert,
//               color: appTheme.deepPurple,
//               size: 25.fSize,
//             ),
//             // Use a specific widget
//             itemBuilder: (BuildContext context) => [
//               PopupMenuItem(
//                 value: 'share',
//                 child: textNormal(text: 'مشاركة', fontSize: 13.fSize),
//               ),
//             ],
//             onSelected: (value) {
//               if (value == "share") {
//                 shareCompany(
//                   idCompany: widget.idCompany.toString(),
//                   imageUrl: imageCompany.toString() != 'null'
//                       ? (imageCompany.toString().contains('http')
//                           ? imageCompany.toString()
//                           : AppEndpoints.baseUrlWithoutApi +
//                               imageCompany.toString())
//                       : 'null',
//                   nameCompany:
//                       companyInformation?[0].companyName.toString() ?? '',
//                 );
//               }
//             },
//           ),
//         )
//       ],
//     );
//   }
///