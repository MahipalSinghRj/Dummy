import 'package:flutter/services.dart';

String? validateAadharNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Aadhar number is required';
  }

  // Check for a valid Aadhar number pattern (12 digits)
  RegExp aadharPattern = RegExp(r'^[2-9]{1}[0-9]{11}$');
  if (!aadharPattern.hasMatch(value!)) {
    return 'Enter a valid Aadhar number';
  }
  // If all checks pass, return null (no error)
  return null;
}

String? validatePincode(String? value) {
  if (value == null || value.isEmpty) {
    return 'PIN code is required';
  }

  // Check for a valid Indian PIN code pattern (6 digits)
  RegExp pincodePattern = RegExp(r'^[1-9][0-9]{5}$');
  if (!pincodePattern.hasMatch(value)) {
    return 'Enter a valid Indian PIN code';
  }

  // If all checks pass, return null (no error)
  return null;
}

String? validateGSTNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'GST number is required';
  }

  // Check for a valid Indian GST number pattern
  RegExp gstPattern = RegExp(r'\d{2}[A-Z]{5}\d{4}[A-Z]{1}[A-Z\d]{1}[Z]{1}[A-Z\d]{1}');

  if (!gstPattern.hasMatch(value!)) {
    return 'Enter a valid Indian GST number';
  }

  // If all checks pass, return null (no error)
  return null;
}

String? validatePANCard(String? value) {
  if (value == null || value.isEmpty) {
    return 'PAN card number is required';
  }

  // Check for a valid Indian PAN card number pattern
  RegExp panPattern = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');

  if (!panPattern.hasMatch(value!)) {
    return 'Enter a valid Indian PAN card number';
  }

  // If all checks pass, return null (no error)
  return null;
}

String? validateMobileNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Mobile number is required';
  }

  // Check for a valid Indian mobile number pattern (10 digits starting with 6, 7, 8, or 9)
  RegExp mobilePattern = RegExp(r'^[6-9]\d{9}$');

  if (!mobilePattern.hasMatch(value)) {
    return 'Enter a valid Indian mobile number';
  }

  // If all checks pass, return null (no error)
  return null;
}

String? validateCordinates(String? value) {
  if (value == null || value.isEmpty) {
    return 'Co-ordinates is required';
  }

  // If all checks pass, return null (no error)
  return null;
}

String? validateForEmptyOrNull(String? value) {
  if (value == null || value.isEmpty) {
    return 'This Filed is required';
  }

  // If all checks pass, return null (no error)
  return null;
}

String? validateProprietorName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Proprietor name is required';
  }
  return null;
}

String? validateEmail(String? value) {
  // Check if the email is empty
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }

  // Use a regular expression for basic email format validation
  // This regex is a simplified version and may not cover all edge cases
  RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
  if (!emailRegex.hasMatch(value)) {
    return 'Enter a valid email address';
  }

  // Return null if the email is valid
  return null;
}

class UppercaseInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
