import 'dart:convert';

import 'package:diacritic/diacritic.dart';

extension StringUtils on String {
  bool isValidEmail() {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  double parseDouble() {
    if (isEmpty) return 0;
    return double.tryParse(replaceAll(',', '').replaceAll('.', '')) ?? 0;
  }

  num parseNum() {
    if (isEmpty) return 0;
    return num.tryParse(replaceAll(',', '').replaceAll('.', '')) ?? 0;
  }

  bool isValidPhoneNumber() {
    String validateString = '';
    if (startsWith('(+84)') && length > 6) {
      validateString = '0${substring(6)}';
    } else {
      validateString = this;
    }

    return RegExp(r'^(?:\+84|0)[0-9]{9,10}$').hasMatch(validateString);
  }

  String get addDotBeforeBreak => replaceAll('\n', ',\n');

  bool isValidName() {
    // Check if the name contains only letters and spaces, no special characters or numbers
    return RegExp(r'^[a-zA-Z\s]+$').hasMatch(this);
  }

  String formatPhoneNumber() {
    if (isEmpty) return this;
    // If starts with 0, replace with +84
    if (startsWith('0')) {
      return '(+84) ${substring(1)}';
    }
    return this;
  }

  bool isValidId() {
    return RegExp(r'^[0-9]{12}$').hasMatch(this);
  }

  bool isValidPassport() {
    return RegExp(r'^[A-Za-z]{2}\d{7}$', caseSensitive: false).hasMatch(this);
  }

  bool isValidBirthCertificate() {
    return RegExp(r'^[0-9]{9}$', caseSensitive: false).hasMatch(this);
  }

  bool isValidBase64() {
    try {
      base64Decode(this);

      return true;
    } catch (e) {
      return false;
    }
  }

  String getReplaceP1andP2String(String mesgId, String mesgData) =>
      replaceAll('@p1', mesgId).replaceAll('@p2', mesgData);

  String toNonAccentLowerCase() {
    return removeDiacritics(toLowerCase());
  }

  String baseUrlPath(String url) {
    return '$url/$this';
  }

  DateTime toDDMMYYYY() {
    return DateTime.parse(this);
  }
}
