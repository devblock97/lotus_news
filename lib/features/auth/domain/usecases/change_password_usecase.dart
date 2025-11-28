import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lotus_news/core/exceptions/failure.dart';
import 'package:lotus_news/core/usecases/usecase.dart';
import 'package:lotus_news/features/auth/data/models/password_update_model.dart';
import 'package:lotus_news/features/auth/domain/repositories/auth_repository.dart';

class ChangePasswordUseCase
    extends UseCase<PasswordUpdateModel, ChangePasswordParam> {
  final AuthRepository _repository;
  ChangePasswordUseCase(this._repository);

  @override
  Future<Either<Failure, PasswordUpdateModel>> call(
    ChangePasswordParam params,
  ) {
    return _repository.changePassword(params.oldPass, params.newPass);
  }
}

class ChangePasswordParam extends Equatable {
  final String oldPass;
  final String newPass;

  const ChangePasswordParam({required this.oldPass, required this.newPass});

  @override
  List<Object?> get props => [oldPass, newPass];
}
