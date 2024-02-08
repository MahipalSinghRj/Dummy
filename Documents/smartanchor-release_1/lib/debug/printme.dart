import 'dart:developer';

import 'package:flutter/foundation.dart';

void printMe(text) {
  if (kDebugMode) print('\x1B[32m$text\x1B[0m');
}

void printResponse(String object) {
  if (kDebugMode) log(object);
}

void printWarning(text) {
  if (kDebugMode) print('\x1B[33m$text\x1B[0m');
}

void printErrors(text) {
  if (kDebugMode) print('\x1B[32m$text\x1B[0m');
}

void printAchievement(text) {
  if (kDebugMode) print('\x1B[35m$text\x1B[0m');
}

// Black:   \x1B[30m
// Red:     \x1B[31m
// Green:   \x1B[32m
// Yellow:  \x1B[33m
// Blue:    \x1B[34m
// Magenta: \x1B[35m
// Cyan:    \x1B[36m
// White:   \x1B[37m
// Reset:   \x1B[0m

void redPrint(dynamic value) {
  print('\x1B[31m$value\x1B[0m');
}

void violetPrint(dynamic value) {
  print('\x1B[95m$value\x1B[0m');
}

void purplePrint(dynamic value) {
  print('\x1B[95m$value\x1B[0m');
}

void greenPrint(dynamic value) {
  print('\x1B[32m$value\x1B[0m');
}

void yellowPrint(dynamic value) {
  print('\x1B[33m$value\x1B[0m');
}

void bluePrint(dynamic value) {
  print('\x1B[34m$value\x1B[0m');
}

void magentaPrint(dynamic value) {
  print('\x1B[35m$value\x1B[0m');
}

void cyanPrint(dynamic value) {
  print('\x1B[36m$value\x1B[0m');
}

void brightRedPrint(dynamic value) {
  print('\x1B[91m$value\x1B[0m');
}

void brightGreenPrint(dynamic value) {
  print('\x1B[92m$value\x1B[0m');
}

void brightYellowPrint(dynamic value) {
  print('\x1B[93m$value\x1B[0m');
}

void brightBluePrint(dynamic value) {
  print('\x1B[94m$value\x1B[0m');
}

void brightMagentaPrint(dynamic value) {
  print('\x1B[95m$value\x1B[0m');
}

void brightCyanPrint(dynamic value) {
  print('\x1B[96m$value\x1B[0m');
}
