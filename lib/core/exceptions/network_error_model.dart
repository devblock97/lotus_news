import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class NetworkErrorModel extends Equatable {
  @JsonKey(name: 'status_code')
  final int? statusCode;

  @JsonKey(name: 'status_message')
  final String? statusMessage;

  const NetworkErrorModel({this.statusCode, this.statusMessage});

  factory NetworkErrorModel.fromJson(Map<String, dynamic> json) {
    return NetworkErrorModel(
      statusCode: json['status_code'],
      statusMessage: json['status_message'],
    );
  }

  Map<String, dynamic> toJson() => {
    'status_code': statusCode,
    'status_message': statusMessage,
  };

  @override
  List<Object?> get props => [statusCode, statusMessage];
}
