import 'package:rxdart_bloc_implement/domain/entities/user.dart';

import 'package:rxdart/rxdart.dart';

class LoginUseCase {
  Stream<User> call({
    required String email,
    required String password,
  }) =>
      Stream.value(User(name: "Quan"));
}
