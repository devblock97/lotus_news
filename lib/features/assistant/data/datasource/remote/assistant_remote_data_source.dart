import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:tma_news/core/constants/app_constants.dart';
import 'package:tma_news/core/network/client.dart';
import 'package:tma_news/features/assistant/data/model/assistant_request.dart';
import 'package:tma_news/features/assistant/data/model/assistant_response.dart';

abstract class AssistantRemoteDataSource {
  Future<AssistantResponse> summarize(AssistantRequest param) => throw UnimplementedError('Stub');

  Stream<String> summarizeStream(AssistantRequest param) => throw UnimplementedError('Stub');

}

class AssistantRemoteDataSourceImpl implements AssistantRemoteDataSource {

  final Client _client;
  const AssistantRemoteDataSourceImpl(this._client);

  @override
  Future<AssistantResponse> summarize(AssistantRequest param) async {
    try {
      final response = await _client.post(
        AppConstants.summarize,
        data: jsonEncode(param.toJson()),

      );
      return AssistantResponse.fromJson(response.data);
    } on DioException catch (e) {
      rethrow;
    }
  }

  @override
  Stream<String> summarizeStream(AssistantRequest param) async* {
    try {
      final response = await _client.post(
        AppConstants.summarize,
        data: jsonEncode(param.toJson()),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
          responseType: ResponseType.stream,
        ),
      );

      final bodyData = response.data! as ResponseBody;
      final stream = bodyData.stream.transform(StreamTransformer.fromBind(utf8.decoder.bind));
      await for (final chunk in stream) {
        for (final line in LineSplitter.split(chunk)) {
          if (line.trim().isEmpty) continue;
          final jsonLine = json.decode(line);
          yield jsonLine['response'];
        }
      }
    } on DioException catch(e) {
      rethrow;
    }
  }
}