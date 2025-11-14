import 'package:fpdart/fpdart.dart';
import 'package:lotus_news/core/exceptions/failure.dart';
import 'package:lotus_news/core/usecases/usecase.dart';
import 'package:lotus_news/features/auth/data/models/auth_model.dart';
import 'package:lotus_news/features/auth/domain/repositories/auth_repository.dart';

class SignInUseCase extends UseCase<AuthModel, SignInParam> {
  final AuthRepository _repository;
  SignInUseCase(this._repository);

  @override
  Future<Either<Failure, AuthModel>> call(SignInParam params) async {
    return _repository.signIn(params.email, params.password);
  }
}

class SignInParam {
  final String email;
  final String password;

  const SignInParam({required this.email, required this.password});
}
