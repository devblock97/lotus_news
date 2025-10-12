class AssistantRequest {
  final String model;
  final String prompt;
  final bool stream;

  AssistantRequest({
    this.model = 'gemma3:latest',
    required this.prompt,
    this.stream = false,
  });

  Map<String, dynamic> toJson() => {
    'model': model,
    'prompt': prompt,
    'stream': stream,
  };
}
