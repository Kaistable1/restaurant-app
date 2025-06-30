// import 'package:flutter/material.dart';

// class MultiSelectDropdown extends StatefulWidget {
//   final String label;
//   final List<String> options;
//   final List<String> selectedValues;
//   final ValueChanged<List<String>> onChanged;

//   const MultiSelectDropdown({
//     Key? key,
//     required this.label,
//     required this.options,
//     required this.selectedValues,
//     required this.onChanged,
//   }) : super(key: key);

//   @override
//   _MultiSelectDropdownState createState() => _MultiSelectDropdownState();
// }

// class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
//   final LayerLink _layerLink = LayerLink();
//   OverlayEntry? _overlayEntry;
//   bool _isOpen = false;

//   void _toggleDropdown() {
//     if (_isOpen) {
//       _overlayEntry?.remove();
//       _isOpen = false;
//     } else {
//       _overlayEntry = _createOverlayEntry();
//       Overlay.of(context).insert(_overlayEntry!);
//       _isOpen = true;
//     }
//   }

//   OverlayEntry _createOverlayEntry() {
//     RenderBox renderBox = context.findRenderObject() as RenderBox;
//     final size = renderBox.size;
//     final position = renderBox.localToGlobal(Offset.zero);

//     return OverlayEntry(
//       builder: (context) => Positioned(
//         left: position.dx,
//         top: position.dy + size.height,
//         width: size.width,
//         child: CompositedTransformFollower(
//           link: _layerLink,
//           showWhenUnlinked: false,
//           offset: Offset(0, size.height + 4),
//           child: Material(
//             elevation: 4,
//             borderRadius: BorderRadius.circular(12),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: SizedBox(
//                 height: 250, // LIMIT height for scrolling
//                 child: Scrollbar(
//                   thumbVisibility: true,
//                   child: ListView(
//                     padding: EdgeInsets.zero,
//                     children: widget.options.map((option) {
//                       final isChecked = widget.selectedValues.contains(option);
//                       return CheckboxListTile(
//                         title: Text(option),
//                         value: isChecked,
//                         onChanged: (bool? checked) {
//                           final newValues =
//                               List<String>.from(widget.selectedValues);
//                           if (checked == true && !newValues.contains(option)) {
//                             newValues.add(option);
//                           } else if (checked == false &&
//                               newValues.contains(option)) {
//                             newValues.remove(option);
//                           }
//                           widget.onChanged(newValues);
//                           setState(() {});
//                         },
//                         controlAffinity: ListTileControlAffinity.leading,
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _overlayEntry?.remove();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CompositedTransformTarget(
//       link: _layerLink,
//       child: GestureDetector(
//         onTap: _toggleDropdown,
//         child: Container(
//           height: 50,
//           width: 604,
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey.shade400),
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 widget.selectedValues.isNotEmpty
//                     ? widget.selectedValues.join(', ')
//                     : widget.label,
//                 style: const TextStyle(fontSize: 14),
//                 overflow: TextOverflow.ellipsis,
//               ),
//               const Icon(Icons.arrow_drop_down),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class MultiSelectDropdown extends StatefulWidget {
  final String label;
  final List<String> options;
  final List<String> selectedValues;
  final ValueChanged<List<String>> onChanged;

  const MultiSelectDropdown({
    Key? key,
    required this.label,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
  }) : super(key: key);

  @override
  _MultiSelectDropdownState createState() => _MultiSelectDropdownState();
}

class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  late List<String> _localSelected;

  @override
  void initState() {
    super.initState();
    _localSelected = List<String>.from(widget.selectedValues);
  }

  @override
  void didUpdateWidget(covariant MultiSelectDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedValues != widget.selectedValues) {
      _localSelected = List<String>.from(widget.selectedValues);
    }
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
      _isOpen = true;
    }
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _isOpen = false;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx,
        top: position.dy + size.height,
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 4),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SizedBox(
                height: 250,
                child: Scrollbar(
                  thumbVisibility: true,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: widget.options.map((option) {
                      return StatefulBuilder(
                        builder: (context, setStateCheckbox) {
                          final isChecked = _localSelected.contains(option);
                          return CheckboxListTile(
                            title: Text(option),
                            value: isChecked,
                            onChanged: (bool? checked) {
                              setStateCheckbox(() {}); // Update checkbox
                              setState(() {}); // Update label on dropdown

                              if (checked == true &&
                                  !_localSelected.contains(option)) {
                                _localSelected.add(option);
                              } else if (checked == false &&
                                  _localSelected.contains(option)) {
                                _localSelected.remove(option);
                              }

                              widget.onChanged(_localSelected);
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          height: 50,
          width: 604,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _localSelected.isNotEmpty
                      ? _localSelected.join(', ')
                      : widget.label,
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }
}
