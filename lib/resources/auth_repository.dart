import 'package:sevenprac/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert' as convert;


class AuthRepository {
  Future<void> onGetAuthEvent(GetAuthEvent event, Emitter<AuthBlocState> emit) async {
    Response response;
    emit(LoadingAuthState());
    try {
      response = await http.post(
        Uri.parse("http://localhost:3000/rest/visitor/register"),
        body: convert.jsonEncode({
          'username': event.username,
        }),
      );
      emit(LoadedAuthState());
      print(response.body);
    } catch (_) {
      emit(FailureLoginState());
    }
  }
}