// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../../data/models/category/category_model.dart';
// class DynamicSubCategoryWidget extends StatefulWidget {
//   final List<SubCategoryModel> categories;
//
//   DynamicSubCategoryWidget({required this.categories});
//
//   @override
//   _DynamicSubCategoryWidgetState createState() =>
//       _DynamicSubCategoryWidgetState();
// }
//
// class _DynamicSubCategoryWidgetState extends State<DynamicSubCategoryWidget> {
//   List<SubCategoryModel> selectedCategories = []; // List of selected subcategories
//   List<SubCategoryModel> currentCategories = []; // List of currently displayed categories
//
//   @override
//   void initState() {
//     super.initState();
//     currentCategories = widget.categories;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       shrinkWrap: true,
//       scrollDirection: Axis.horizontal,
//       children: [
//         // Display the current category with selection option
//         buildPopupMenu(currentCategories),
//         // Display subcategories based on selection
//         ...selectedCategories.map(
//               (subCategory) =>buildSubCategoryWidget(subCategory),
//         ).toList(),
//       ],
//     );
//   }
//
//   // Build PopupMenu for selecting a subcategory
//   Widget buildPopupMenu(List<SubCategoryModel> subCategories) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 5.w),
//       child: PopupMenuButton<SubCategoryModel>(
//         color: Colors.white,
//         onSelected: (SubCategoryModel newValue) {
//           setState(() {
//             // أضف القيمة الجديدة إلى selectedCategories دون استبدال القيم القديمة
//             selectedCategories.add(newValue);
//
//             // إذا كانت القيمة الجديدة تحتوي على فئات فرعية، أضفها إلى currentCategories دون استبدال
//             if (newValue.hasSubcategory == true) {
//               // إذا كنت تريد منع التكرار:
//               // Set<SubCategoryModel> uniqueCategories = Set.from(currentCategories);
//               // uniqueCategories.addAll(newValue.subcategories!);
//               // currentCategories = uniqueCategories.toList();
//
//               currentCategories.addAll(newValue.subcategories);
//             }
//           });
//         },
//         itemBuilder: (BuildContext context) {
//           return subCategories.map((SubCategoryModel category) {
//             return PopupMenuItem<SubCategoryModel>(
//               value: category,
//               child: Text(
//                 category.title ?? "غير معروف", // Handle null titles
//                 style: Theme.of(context).textTheme.displaySmall,
//               ),
//             );
//           }).toList();
//         },
//         child: Container(
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.black),
//             borderRadius: BorderRadius.circular(5),
//           ),
//           padding: EdgeInsets.symmetric(horizontal: 10.w),
//           height: 35.h,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               if(subCategories.isNotEmpty)...{
//                 Text(
//                   subCategories.first.title ?? "اختر الصنف", // Use first item title
//                   style: Theme.of(context).textTheme.displaySmall,
//                 ),
//                 Icon(Icons.arrow_drop_down),
//               }
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   // Build widget for displaying the selected subcategory
//   Widget buildSubCategoryWidget(SubCategoryModel subCategory) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Text(
//           //   subCategory.title ?? "", // Display title without prefix
//           //   style: TextStyle(fontSize: 16.sp),
//           // ),
//           if (subCategory.hasSubcategory == true)
//             Padding(
//               padding: EdgeInsets.symmetric(vertical: 5.h),
//               child: buildPopupMenu(subCategory.subcategories),
//             ),
//         ],
//       ),
//     );
//   }
// }