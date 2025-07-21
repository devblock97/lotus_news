import 'package:equatable/equatable.dart';

class NewsEntity extends Equatable {
  final int id;
  final String account;

  const NewsEntity({required this.id, required this.account});

  @override
  List<Object?> get props => [];
}