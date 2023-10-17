import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sevenprac/resources/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthBlocEvent, AuthBlocState> {
  final _repository = AuthRepository();
  AuthBloc() : super(AuthBlocInitial()) {
    on<AuthBlocEvent>((event, emit) => emit(AuthBlocInitial()));
    on<GetAuthEvent>(_repository.onGetAuthEvent);
  }
}