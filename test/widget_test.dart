// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility in the flutter_test package. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.
//
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:integration_test/integration_test.dart';
//
// import 'package:syrians_in_uae/main.dart';
// import 'package:syrians_in_uae/main.dart'as app;
// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();
//
//   testWidgets('Counter increments smoke test', (WidgetTester tester) async {
//     // تشغيل التطبيق بالكامل
//     app.main();
//     await tester.pumpAndSettle();
//
//     // التأكد من أن العداد يبدأ من 0
//     expect(find.text('0'), findsOneWidget);
//     expect(find.text('1'), findsNothing);
//
//     // النقر على زر '+'
//     await tester.tap(find.byIcon(Icons.add));
//     await tester.pumpAndSettle();
//
//     // التأكد من أن العداد قد زاد إلى 1
//     expect(find.text('0'), findsNothing);
//     expect(find.text('1'), findsOneWidget);
//   });
// }