part of 'my_form_bloc.dart';

sealed class MyFormEvent extends Equatable {
  const MyFormEvent();
}

final class MyFormClientChanged extends MyFormEvent {
  const MyFormClientChanged(this.client);

  final String client;

  @override
  List<Object?> get props => [client];
}

final class MyFormFormSubmitted extends MyFormEvent {
  const MyFormFormSubmitted();

  @override
  List<Object?> get props => [];
}
