import 'package:email_validator/email_validator.dart';

String password_validator(String value) {
  String result = '';
  if (value.length < 8) {
    result += 'В вашому паролі не вистачає ${8-value.length} букв\n';
  }
  if (!value.contains(RegExp(r'[A-Za-zА-Яа-я]')) ) {
    result += 'Пароль має містити принаймні одну літеру\n';
  }
  if (!value.contains(RegExp(r'[0-9]')) ) {
    result += 'Пароль має містити принаймні одну цифру\n';
  }
  return result;
}

String email_validator(String value) {
  if (EmailValidator.validate(value)) {
    return '';
  }
  else {
    return 'Перевірте правильність написання вашого Email';
  }
}