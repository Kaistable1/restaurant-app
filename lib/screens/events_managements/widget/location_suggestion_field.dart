import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:savrly/constants/app_colors.dart';

class LocationTextField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Function(double latitude, double longitude)? onLocationSelected;

  const LocationTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.validator,
    this.onLocationSelected,
  });

  @override
  _LocationTextFieldState createState() => _LocationTextFieldState();
}

class _LocationTextFieldState extends State<LocationTextField> {
  final String _googleApiKey = 'AIzaSyDJjiynZugIjtXiZI4AIMU9srY1AkSmtto';
  final String _proxyUrl = 'https://googleplacesproxy-6nrfvx3mia-uc.a.run.app';
  List<dynamic> _suggestions = [];
  Timer? _debounceTimer;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    // Add listener to manage cursor position when text changes
    widget.controller.addListener(_updateCursorPosition);
  }

  // Update cursor to the end of text when text changes to allow normal editing
  void _updateCursorPosition() {
    if (widget.controller.text.isNotEmpty) {
      widget.controller.selection = TextSelection.fromPosition(
        TextPosition(offset: widget.controller.text.length),
      );
    }
  }

  Future<void> _fetchSuggestions(String input) async {
    if (input.isEmpty || input.length < 3) {
      setState(() {
        _suggestions = [];
        _hideSuggestions();
      });
      return;
    }

    try {
      // Use the Cloud Function as the proxy
      final url =
          '$_proxyUrl/maps/api/place/autocomplete/json?input=${Uri.encodeComponent(input)}&key=$_googleApiKey';
      if (kDebugMode) {
        print('Fetching suggestions for: $input');
        print('Proxy URL: $url');
      }
      final response = await http.get(Uri.parse(url));

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'OK' && data['predictions'] != null) {
          setState(() {
            _suggestions = data['predictions'];
            _showSuggestions();
          });
        } else {
          if (kDebugMode) {
            print('API error: ${data['status']} - ${data['error_message']}');
          }
          setState(() {
            _suggestions = [];
            _hideSuggestions();
          });
        }
      } else {
        if (kDebugMode) {
          print('HTTP error: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching suggestions: $e');
      }
    }
  }

  void _showSuggestions() {
    _hideSuggestions();
    if (_suggestions.isEmpty || !mounted) return;

    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height,
        width: size.width,
        child: Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = _suggestions[index];
                return ListTile(
                  title: Text(suggestion['description'] ?? ''),
                  onTap: () {
                    widget.controller.text = suggestion['description'] ?? '';
                    _updateCursorPosition(); // Move cursor to end after setting text
                    _hideSuggestions();
                    _fetchPlaceDetails(suggestion['place_id']);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );

    if (mounted) {
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  void _hideSuggestions() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Future<void> _fetchPlaceDetails(String placeId) async {
    try {
      // Use the Cloud Function for place details as well
      final url =
          '$_proxyUrl/maps/api/place/details/json?place_id=$placeId&fields=geometry,name&key=$_googleApiKey';
      if (kDebugMode) {
        print('Fetching place details for Place ID: $placeId');
      }
      final response = await http.get(Uri.parse(url));

      if (kDebugMode) {
        print('Place details response status: ${response.statusCode}');
        print('Place details response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'OK' && data['result'] != null) {
          final location = data['result']['geometry']['location'];
          final latitude = location['lat'];
          final longitude = location['lng'];

          if (widget.onLocationSelected != null) {
            widget.onLocationSelected!(latitude, longitude);
          }
        } else {
          if (kDebugMode) {
            print(
                'Place details error: ${data['status']} - ${data['error_message']}');
          }
        }
      } else {
        if (kDebugMode) {
          print('HTTP error: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching place details: $e');
      }
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _hideSuggestions();
    widget.controller
        .removeListener(_updateCursorPosition); // Clean up listener
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: lightColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: lightColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: lightColor),
            ),
          ),
          validator: widget.validator,
          onChanged: (value) {
            if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
            _debounceTimer = Timer(const Duration(milliseconds: 500), () {
              _fetchSuggestions(value);
            });
          },
          // Prevent auto-selection by setting initial selection to cursor at end
          onTap: () {
            if (widget.controller.text.isNotEmpty) {
              widget.controller.selection = TextSelection.fromPosition(
                TextPosition(offset: widget.controller.text.length),
              );
            }
          },
        ),
      ],
    );
  }
}
