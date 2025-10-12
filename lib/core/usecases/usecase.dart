import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lotus_news/core/exceptions/failure.dart';

abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

abstract class StreamUseCase<T, Params> {
  Stream<Either<Failure, T>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
