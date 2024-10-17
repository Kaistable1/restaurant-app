import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:kaistable_website/screens/home_screen/home_screen.dart';
import 'package:kaistable_website/screens/onboarding_screen/onboarding_screen.dart';
import 'package:kaistable_website/widgets/top_bar_widget.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return   GetMaterialApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(dragDevices: {
        PointerDeviceKind.invertedStylus,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.touch,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.unknown,
      }),
      debugShowCheckedModeBanner: false,
      title: 'Kaistable Website',

      home: TopBarWidget(),
      // home: OnboardingScreen(),
    );
  }
}

// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text("Menu Items Table")),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: MenuTable(),
//         ),
//       ),
//     );
//   }
// }

// class MenuTable extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         // First part: Menu items and before discount columns
//         Expanded(
//           flex: 2,
//           child: Table(
//             border: TableBorder.all(color: Colors.grey),
//             columnWidths: {
//               0: FixedColumnWidth(150.0),
//               1: FlexColumnWidth(),
//             },
//             children: [
//               _buildTableHeader(),
//               _buildTableRow(
//                 image: 'assets/specialty.jpg',
//                 menuItem: 'Specialty',
//                 beforePrice: '\$30',
//               ),
//               _buildTableRow(
//                 image: 'assets/raddish_pastry.jpg',
//                 menuItem: 'Raddish Pastry',
//                 beforePrice: '\$20',
//               ),
//               _buildTableRow(
//                 image: 'assets/nam_temporibus.jpg',
//                 menuItem: 'Nam temporibus repellat ullam odit.',
//                 beforePrice: '\$30',
//               ),
//               _buildTableRow(
//                 image: 'assets/aut_consectetur.jpg',
//                 menuItem: 'Aut consectetur temporibus in',
//                 beforePrice: '\$40',
//               ),
//               _buildTableRow(
//                 image: 'assets/nam_non.jpg',
//                 menuItem: 'Nam non eum velit tenetur',
//                 beforePrice: '\$20',
//               ),
//             ],
//           ),
//         ),
//         // Second part: After discount (green column)
//         Expanded(
//           child: Container(
//             color: Colors.teal, // Green background for entire column
//             child: Table(
//               columnWidths: {
//                 0: FlexColumnWidth(),
//               },
//               children: [
//                 _buildGreenHeader(),
//                 _buildGreenRow(afterPrice: '\$20'),
//                 _buildGreenRow(afterPrice: '\$10'),
//                 _buildGreenRow(afterPrice: '\$20'),
//                 _buildGreenRow(afterPrice: '\$30'),
//                 _buildGreenRow(afterPrice: '\$10'),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   // Normal table rows for "Menu Items" and "Before Discount" columns
//   TableRow _buildTableRow({
//     required String image,
//     required String menuItem,
//     required String beforePrice,
//   }) {
//     return TableRow(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             children: [
//               Image.asset(image, width: 50, height: 50),
//               SizedBox(width: 8),
//               Text(menuItem, style: TextStyle(fontSize: 16)),
//             ],
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             beforePrice,
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ],
//     );
//   }
//
//   // Header row for the first part (Menu items and Before discount)
//   TableRow _buildTableHeader() {
//     return TableRow(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             'Menu Items',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             'Before Discount',
//             style: TextStyle(fontWeight: FontWeight.bold),
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ],
//     );
//   }
//
//   // Header for the green column (After discount)
//   TableRow _buildGreenHeader() {
//     return TableRow(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             'After Discount',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ],
//     );
//   }
//
//   // Rows for the green column
//   TableRow _buildGreenRow({required String afterPrice}) {
//     return TableRow(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Text(
//             afterPrice,
//             style: TextStyle(color: Colors.white),
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ],
//     );
//   }
// }
///try 1
// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text("Menu Items Table")),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: MenuTable(),
//         ),
//       ),
//     );
//   }
// }
//
// class MenuTable extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Table(
//       border: TableBorder.all(color: Colors.grey),
//       columnWidths: {
//         0: FixedColumnWidth(150.0),
//         1: FlexColumnWidth(),
//         2: FlexColumnWidth(),
//       },
//       children: [
//         _buildTableHeader(),
//         _buildTableRow(
//           image: 'assets/specialty.jpg',
//           menuItem: 'Specialty',
//           beforePrice: '\$30',
//           afterPrice: '\$20',
//         ),
//         _buildTableRow(
//           image: 'assets/raddish_pastry.jpg',
//           menuItem: 'Raddish Pastry',
//           beforePrice: '\$20',
//           afterPrice: '\$10',
//         ),
//         _buildTableRow(
//           image: 'assets/nam_temporibus.jpg',
//           menuItem: 'Nam temporibus repellat ullam odit.',
//           beforePrice: '\$30',
//           afterPrice: '\$20',
//         ),
//         _buildTableRow(
//           image: 'assets/aut_consectetur.jpg',
//           menuItem: 'Aut consectetur temporibus in',
//           beforePrice: '\$40',
//           afterPrice: '\$30',
//         ),
//         _buildTableRow(
//           image: 'assets/nam_non.jpg',
//           menuItem: 'Nam non eum velit tenetur',
//           beforePrice: '\$20',
//           afterPrice: '\$10',
//         ),
//       ],
//     );
//   }
//
//   TableRow _buildTableHeader() {
//     return TableRow(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             'Menu Items',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             'Before Discount',
//             style: TextStyle(fontWeight: FontWeight.bold),
//             textAlign: TextAlign.center,
//           ),
//         ),
//         Container(
//           color: Colors.teal,
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             'After Discount',
//             style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ],
//     );
//   }
//
//   TableRow _buildTableRow({
//     required String image,
//     required String menuItem,
//     required String beforePrice,
//     required String afterPrice,
//   }) {
//     return TableRow(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             children: [
//               Image.asset(image, width: 50, height: 50),
//               SizedBox(width: 8),
//               Text(menuItem, style: TextStyle(fontSize: 16)),
//             ],
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             beforePrice,
//             textAlign: TextAlign.center,
//           ),
//         ),
//         Container(
//           color: Colors.teal,
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             afterPrice,
//             style: TextStyle(color: Colors.white),
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ],
//     );
//   }
// }
