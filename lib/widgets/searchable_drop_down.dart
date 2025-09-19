// ========== SEARCHABLE_DROPDOWN_WIDGET.DART - CREATE THIS NEW FILE ==========
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/text_styles.dart';

class SearchableDropdown<T> extends StatefulWidget {
  final String labelText;
  final String? hintText;
  final List<T> items;
  final T? selectedValue;
  final String Function(T)? itemTextBuilder;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;
  final bool isLoading;
  final bool isEnabled;
  final VoidCallback? onClear;
  final IconData? suffixIcon;
  final Color? suffixIconColor;

  const SearchableDropdown({
    Key? key,
    required this.labelText,
    this.hintText,
    required this.items,
    this.selectedValue,
    this.itemTextBuilder,
    this.onChanged,
    this.validator,
    this.isLoading = false,
    this.isEnabled = true,
    this.onClear,
    this.suffixIcon,
    this.suffixIconColor,
  }) : super(key: key);

  @override
  State<SearchableDropdown<T>> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<SearchableDropdown<T>> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isDropdownOpen = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Set initial search text to selected value
    if (widget.selectedValue != null && widget.itemTextBuilder != null) {
      _searchController.text = widget.itemTextBuilder!(widget.selectedValue!);
    }

    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(SearchableDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update search text if selected value changes
    if (widget.selectedValue != oldWidget.selectedValue &&
        widget.itemTextBuilder != null &&
        widget.selectedValue != null) {
      _searchController.text = widget.itemTextBuilder!(widget.selectedValue!);
      _searchQuery = _searchController.text;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _hideDropdown();
    super.dispose();
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus && widget.isEnabled && !widget.isLoading) {
      _showDropdown();
    } else if (!_focusNode.hasFocus) {
      _hideDropdown();
    }
  }

  void _showDropdown() {
    _hideDropdown(); // Hide any existing overlay
    _overlayEntry = _createOverlayEntry();
    if (_overlayEntry != null) {
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  void _hideDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isDropdownOpen = false;
    });
  }

  OverlayEntry? _createOverlayEntry() {
    if (!mounted) return null;

    RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return null;

    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    List<T> filteredItems = _filterItems(_searchQuery);

    return OverlayEntry(
      builder: (context) => CompositedTransformFollower(
        link: _layerLink,
        showWhenUnlinked: false,
        offset: Offset(0.0, size.height + 5.0),
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          clipBehavior: Clip.antiAlias,
          color: Colors.white,
          child: Container(
            width: size.width,
            constraints: const BoxConstraints(maxHeight: 250),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Search Bar
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[200]!, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          autofocus: true,
                          style: simpleText.copyWith(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Search ${widget.labelText.toLowerCase()}...',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 0,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                        ),
                      ),
                      if (_searchQuery.isNotEmpty)
                        GestureDetector(
                          onTap: _clearSearch,
                          child: Icon(
                            Icons.clear,
                            size: 20,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
                // Items List
                if (filteredItems.isEmpty)
                  Container(
                    height: 100,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          color: Colors.grey[400],
                          size: 40,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No ${widget.labelText.toLowerCase()} found',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: filteredItems.length,
                      separatorBuilder: (context, index) =>
                          Divider(height: 1, color: Colors.grey[200]),
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        final isSelected = widget.selectedValue == item;

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              widget.onChanged?.call(item);
                              _hideDropdown();
                              _focusNode.unfocus();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? primaryColor.withOpacity(0.1)
                                    : Colors.transparent,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.itemTextBuilder != null
                                          ? widget.itemTextBuilder!(item)
                                          : item.toString(),
                                      style: simpleText.copyWith(
                                        fontSize: 14,
                                        color: isSelected
                                            ? primaryColor
                                            : Colors.black87,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check_circle,
                                      color: primaryColor,
                                      size: 20,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<T> _filterItems(String query) {
    if (query.isEmpty) {
      return widget.items;
    }

    return widget.items.where((item) {
      final displayText = widget.itemTextBuilder != null
          ? widget.itemTextBuilder!(item)
          : item.toString();
      return displayText.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final String displayText = widget.selectedValue != null &&
        widget.itemTextBuilder != null
        ? widget.itemTextBuilder!(widget.selectedValue!)
        : widget.selectedValue?.toString() ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            widget.labelText,
            style: simpleText.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ),

        // Main Dropdown Field
        CompositedTransformTarget(
          link: _layerLink,
          child: AbsorbPointer(
            absorbing: widget.isLoading || !widget.isEnabled,
            child: TextField(
              controller: TextEditingController(text: displayText),
              focusNode: _focusNode,
              readOnly: true,
              enabled: widget.isEnabled && !widget.isLoading,
              style: simpleText.copyWith(fontSize: 14),
              decoration: InputDecoration(
                hintText: widget.hintText ??
                    'Select ${widget.labelText.toLowerCase()}',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.isLoading)
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            primaryColor,
                          ),
                        ),
                      )
                    else if (displayText.isNotEmpty && widget.onClear != null)
                      GestureDetector(
                        onTap: () {
                          widget.onClear!();
                          widget.onChanged?.call(null as T?);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(
                            Icons.clear,
                            size: 20,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                    Icon(
                      _isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: widget.isEnabled
                          ? primaryColor
                          : Colors.grey[400],
                    ),
                    if (widget.suffixIcon != null)
                      Icon(
                        widget.suffixIcon!,
                        color: widget.suffixIconColor ?? primaryColor,
                      ),
                  ],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: widget.isEnabled
                        ? Colors.grey[300]!
                        : Colors.grey[200]!,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: primaryColor,
                    width: 2,
                  ),
                ),
                filled: !widget.isEnabled,
                fillColor: widget.isEnabled ? null : Colors.grey[50],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onTap: widget.isEnabled && !widget.isLoading
                  ? () => _focusNode.requestFocus()
                  : null,
            ),
          ),
        ),

        // Error Message
        if (widget.validator != null)
          ValueListenableBuilder(
            valueListenable: ValueNotifier(widget.selectedValue),
            builder: (context, value, child) {
              final error = widget.validator!(widget.selectedValue);
              return error != null
                  ? Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  error,
                  style: TextStyle(
                    color: Colors.red[600],
                    fontSize: 12,
                  ),
                ),
              )
                  : const SizedBox.shrink();
            },
          ),
      ],
    );
  }
}
// ========== END SEARCHABLE_DROPDOWN_WIDGET.DART ==========