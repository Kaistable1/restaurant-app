// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:multiselect_dropdown_flutter/multiselect_dropdown_flutter.dart';
//
// class MultiSelectExample extends StatefulWidget {
//   const MultiSelectExample({super.key});
//
//   @override
//   State<MultiSelectExample> createState() => _MultiSelectExampleState();
// }
//
// class _MultiSelectExampleState extends State<MultiSelectExample> {
//   final List<String> myList2 = const ['Dog', 'Cat', 'Mouse', 'Rabbit'];
//   String? selectedItem;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const SizedBox(height: 50),
//         MultiSelectDropdown.simpleList(
//           list: myList2,
//           initiallySelected: selectedItem != null ? [selectedItem!] : [],
//           onChange: (newList) {
//             // Allow only one selection at a time
//             setState(() {
//               // Set selectedItem to the first element of newList or null if empty
//               selectedItem = newList.isNotEmpty ? newList.first : null;
//             });
//           },
//           includeSearch: true,
//           includeSelectAll: false,
//           numberOfItemsLabelToShow: 1,
//
//           // Customize appearance to indicate single selection
//           //: selectedItem ?? 'Select an animal', // Update hint based on selection
//         ),
//       ],
//     );
//   }
// }
