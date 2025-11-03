// providers/section_providers.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sectionNameControllerProvider =
    Provider.autoDispose<TextEditingController>((ref) {
      return TextEditingController();
    });
final addTaskControllerProvider = Provider.autoDispose<TextEditingController>((
  ref,
) {
  return TextEditingController();
});
final addDescriptionControllerProvider =
    Provider.autoDispose<TextEditingController>((ref) {
      return TextEditingController();
    });
