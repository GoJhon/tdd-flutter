part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}

final class AuthenticationInitial extends AuthenticationState {
  const AuthenticationInitial();
}

final class CreatingUser extends AuthenticationState {
  const CreatingUser();
}

final class GettingUsers extends AuthenticationState {
  const GettingUsers();
}

final class UserCreated extends AuthenticationState {
  const UserCreated();
}

class UserLoaded extends AuthenticationState {
  const UserLoaded(this.users);

  final List<User> users;

  @override
  List<Object> get props => users.map((user) => user.id).toList();
}

class AuthenticationError extends AuthenticationState {
  const AuthenticationError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
