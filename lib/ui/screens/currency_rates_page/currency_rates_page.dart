import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syrians_in_uae/widgets/BoothShimmer.dart';
import 'package:syrians_in_uae/widgets/components.dart';
import 'package:syrians_in_uae/widgets/custom_text_form_field.dart';

import 'cubit/currency_rates_cubit.dart';
import 'cubit/currency_rates_state.dart';

class CurrencyPage extends StatefulWidget {
  @override
  _CurrencyPageState createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> {
  Map<String, dynamic> _rates = {};
  double _amount = 1;
  bool _isLoading = true;
  bool _isError= false;

  @override
  void initState() {
    super.initState();
  }

  final FocusNode _firstFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(resizeToAvoidBottomInset: false,
        appBar: appBarNormalWithIcon(
            text: 'تحويل العملات', context: context, isShowBack: true),
        body: BlocProvider(
          create: (context) => CurrencyRatesCubit()..getCurrencyRates(),
          child: BlocConsumer<CurrencyRatesCubit, CurrencyRatesState>(
            listener: (context, state) {
            if(state is LoadingCurrencyRatesState){
              _isLoading = true;
            }
            if(state is SuccessCurrencyRatesState){
              _isLoading = false;
              _rates =state.currencyRateModel.conversionRates;
            }
            if(state is ErrorCurrencyRatesState){
              _isLoading = false;
              _isError= true;
            }
            },
            builder: (context, state) {
              return _isLoading?BoothShimmer():_isError?Container(): Column(
                children: [
                  Padding(
                    padding:  EdgeInsets.all(16.sp),
                    child: CustomTextFormField(
                     hintText: 'أدخل المبلغ بالدولار',
              focusNode: _firstFocusNode,
              textInputType: TextInputType.number,
              borderDecoration:  OutlineInputBorder(
                borderRadius: BorderRadius.circular(7.r),
                borderSide: BorderSide.none,
              ),
                      onChanged: (value) {
                        setState(() {
                          _amount = double.tryParse(value) ?? 1;
                        });
                      },
                    ),
                  ),
                  //'SYP'
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text('العملة')),
                          DataColumn(label: Text('السعر مقابل USD')),
                          DataColumn(label: Text('القيمة المحولة')),
                        ],
                        rows: _rates.entries
                            .where((entry) => ['USD', 'AED', 'SYP','KWD', 'QAR', 'JOD', 'EUR'].contains(entry.key))
                            .map((entry) {
                          return DataRow(cells: [
                            DataCell(Text(entry.key)),
                            DataCell(Text(entry.value.toString())),
                            DataCell(Text((_amount * entry.value).toStringAsFixed(2))),
                          ]);
                        }).toList(),

                      ),
                    ),
                  ),

                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 10.w),
                          child: textNormal(text: 'ملاحظة: '),
                        ),
                        textNormal(text: 'تطبيقينا لا يقدّم خدمة تحويل العملات بين الدول، بل يعرض فقط قيمة العملة مقارنة بالدولار الأمريكي.',
                        maxLines: 2,textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                sizeHeightNormal(
                  height: 200.h
                )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
