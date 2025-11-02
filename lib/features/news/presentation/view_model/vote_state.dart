import 'package:equatable/equatable.dart';

abstract class VoteState extends Equatable {
  const VoteState();
}

final class VoteInitializeState extends VoteState {
  @override
  List<Object?> get props => [];
}

final class VoteSuccess extends VoteState {
  final int value;
  const VoteSuccess(this.value);

  @override
  List<Object?> get props => [value];
}

final class VoteError extends VoteState {
  final String? message;
  final int? code;
  const VoteError({this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

final class VoteLoading extends VoteState {
  @override
  List<Object?> get props => [];
}
