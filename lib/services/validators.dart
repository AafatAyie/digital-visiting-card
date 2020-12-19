abstract class StringValidator {
  bool isValid(String value);
}

class NonEmptyStringValidator implements StringValidator {
  bool isValid(String value) {
    return value.isNotEmpty;
  }
}

class EmailandPasswordValidator {
  final StringValidator emailValidator = NonEmptyStringValidator();
  final StringValidator passwordValidator = NonEmptyStringValidator();
  final String invalidEmailErrorText = "Email can't be Empty";
  final String invalidPasswordErrorText = "Email can't be Empty";
}
