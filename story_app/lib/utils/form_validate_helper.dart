import 'package:email_validator/email_validator.dart';

class FormValidateHelper {
  static String? validateDoNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Data tidak boleh kosong';
    }
    return null;
  }

  static String? _validateEmail(String value) {
    if (!EmailValidator.validate(value)) {
      return 'Format email harus benar';
    }
    return null;
  }

  static String? validateEmailAndDoNotEmpty(String? value) {
    String? temp;
    temp = validateDoNotEmpty(value);
    if (temp != null) return temp;
    temp = _validateEmail(value!);
    if (temp != null) return temp;
    return temp;
  }

  static String? _validatePassword(String value) {
    if (value.length < 8) {
      return 'Password tidak boleh kurang dari 8 karakter';
    }
    return null;
  }

  static String? validatePasswordAndDoNotEmpty(String? value) {
    String? temp;
    temp = validateDoNotEmpty(value);
    if (temp != null) return temp;
    temp = _validatePassword(value!);
    if (temp != null) return temp;
    return temp;
  }
}