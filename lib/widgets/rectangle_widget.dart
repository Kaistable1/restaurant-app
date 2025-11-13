import 'package:flutter/material.dart';

@immutable
class RectangleWidget {
  final String restaurant_id; // ← Added "final" here

  const RectangleWidget({
    required this.restaurant_id,
  });
}
