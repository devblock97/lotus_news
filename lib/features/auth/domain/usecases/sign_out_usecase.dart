import 'dart:ffi';

import 'package:fpdart/src/either.dart';
import 'package:tma_news/core/exceptions/failure.dart';
import 'package:tma_news/core/usecases/usecase.dart';
import 'package:tma_news/features/auth/domain/repositories/auth_repository.dart';

class SignOutUseCase extends UseCase<bool, NoParams> {

  final AuthRepository _authRepository;
  SignOutUseCase(this._authRepository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return _authRepository.signOut();
  }


}