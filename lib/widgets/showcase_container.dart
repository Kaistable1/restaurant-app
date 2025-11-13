import 'package:flutter/material.dart';
// ← Removed the unused import: '../../screens/nav_bar/main_screen.dart';

@immutable
class ShowCaseContainer {
  final double width;
  final String text;
  final ShowCaseContainer? showCaseContainer;
  final ShowCaseContainer? last;
  final ShowCaseContainer? onNext;

  const ShowCaseContainer({
    required this.width,
    required this.text,
    this.showCaseContainer,
    this.last,
    this.onNext,
  });
}
