import 'package:formz/formz.dart';

enum ClientValidationError { invalid }

final class Client extends FormzInput<String, ClientValidationError> {
  const Client.pure([super.value = '']) : super.pure();

  const Client.dirty([super.value = '']) : super.dirty();

  @override
  ClientValidationError? validator(String? value) {
    return value == null || value.isEmpty
        ? ClientValidationError.invalid
        : null;
  }
}
