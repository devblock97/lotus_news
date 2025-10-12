class AssistantResponse {
  final String response;
  final bool? done;

  const AssistantResponse({required this.response, this.done});

  factory AssistantResponse.fromJson(Map<String, dynamic> json) {
    return AssistantResponse(response: json['response'], done: json['done']);
  }

  Map<String, dynamic> toJson() => {'response': response, 'done': done};
}
