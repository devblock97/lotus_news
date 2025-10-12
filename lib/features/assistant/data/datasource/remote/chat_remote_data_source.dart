import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:lotus_news/core/constants/app_constants.dart';
import 'package:lotus_news/core/network/client.dart';
import 'package:lotus_news/features/assistant/data/model/assistant_request.dart';
import 'package:lotus_news/features/assistant/data/model/assistant_response.dart';

abstract class ChatRemoteDataSource {
  Stream<AssistantResponse> send(AssistantRequest param) =>
      throw UnimplementedError('Stub');

  Stream<String> receive(AssistantResponse data) =>
      throw UnimplementedError('Stub');
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Client _client;
  ChatRemoteDataSourceImpl(this._client);

  @override
  Stream<String> receive(AssistantResponse data) {
    throw UnimplementedError();
  }

  @override
  Stream<AssistantResponse> send(AssistantRequest param) async* {
    try {
      final response = await _client.post(
        AppConstants.assistant,
        data: jsonEncode(param.toJson()),
        options: Options(
          headers: {'Content-Type': 'application/json'},
          responseType: ResponseType.stream,
        ),
      );

      final bodyData = response.data as ResponseBody;
      final streamData = bodyData.stream.transform(
        StreamTransformer.fromBind(utf8.decoder.bind),
      );
      await for (final chunk in streamData) {
        for (final line in LineSplitter.split(chunk)) {
          if (line.trim().isEmpty) continue;
          final jsonLine = jsonDecode(line);
          yield AssistantResponse(
            response: jsonLine['response'],
            done: jsonLine['done'],
          );
        }
      }
    } on DioException {
      rethrow;
    }
  }
}
