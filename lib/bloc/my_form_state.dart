part of 'my_form_bloc.dart';

final class MyFormState extends Equatable {
  const MyFormState({
    required this.client,
    required this.isValid,
    required this.status,
  });

  factory MyFormState.initial() {
    const client = Client.pure();
    return MyFormState(
      client: client,
      isValid: client.isValid,
      status: FormzSubmissionStatus.initial,
    );
  }

  final Client client;
  final bool isValid;
  final FormzSubmissionStatus status;

  MyFormState copyWith({
    Client? client,
    bool? isValid,
    FormzSubmissionStatus? status,
  }) {
    return MyFormState(
      client: client ?? this.client,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        client,
        status,
        isValid,
      ];
}
