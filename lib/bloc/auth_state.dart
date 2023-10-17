part of 'auth_bloc.dart';


@immutable
abstract class AuthBlocState {}

class AuthBlocInitial extends AuthBlocState {}

// Состояние когда только включилась
class AuthInitial extends AuthBlocState {}

class UnAuthState extends AuthBlocState {}

// Состояние в загрузке
class LoadingAuthState extends AuthBlocState {}

// Состояние в загружено
class LoadedAuthState extends AuthBlocState {}


// Состояние ошибка при получении чего либо
class FailureLoginState extends AuthBlocState {}