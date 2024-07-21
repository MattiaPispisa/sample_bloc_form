import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:sample_bloc_form/model/client.dart';

part 'my_form_event.dart';

part 'my_form_state.dart';

class MyFormBloc extends Bloc<MyFormEvent, MyFormState> {
  MyFormBloc() : super(MyFormState.initial()) {
    on<MyFormClientChanged>(_onClientChanged);
    on<MyFormFormSubmitted>(_onFormSubmitted);
  }

  FutureOr<void> _onClientChanged(
      MyFormClientChanged event, Emitter<MyFormState> emit) {
    final client = Client.dirty(event.client);
    emit(
      state.copyWith(
        client: client.isValid ? client : Client.pure(event.client),
        isValid: Formz.validate([client]),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  FutureOr<void> _onFormSubmitted(
      MyFormFormSubmitted event, Emitter<MyFormState> emit) async {
    final client = Client.dirty(state.client.value);
    emit(
      state.copyWith(
        client: client,
        isValid: Formz.validate([client]),
        status: FormzSubmissionStatus.initial,
      ),
    );
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      await Future<void>.delayed(const Duration(seconds: 1));
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    }
  }
}
