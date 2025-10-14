import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lotus_news/core/exceptions/failure.dart';
import 'package:lotus_news/core/usecases/usecase.dart';
import 'package:lotus_news/features/news/data/model/news_model.dart';
import 'package:lotus_news/features/news/domain/repositories/news_repository.dart';
import 'package:lotus_news/features/news/domain/usecases/get_news_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_news_use_case_test.mocks.dart';

@GenerateMocks([NewsRepository])
void main() {
  late GetNewsUseCase useCase;
  late MockNewsRepository mockNewsRepository;

  setUpAll(() {
    provideDummy<Either<Failure, List<NewsModel>>>(
      Left(Failure(message: 'dummy')),
    );
  });

  setUp(() {
    mockNewsRepository = MockNewsRepository();
    useCase = GetNewsUseCase(mockNewsRepository);
  });

  final tNews = [
    NewsModel(
      id: '1',
      body: 'This is news body 1',
      createdAt: DateTime.now().toIso8601String(),
      score: 10,
      title: 'This is news title 1',
    ),
    NewsModel(
      id: '2',
      body: 'This is news body 2',
      createdAt: DateTime.now().toIso8601String(),
      score: 11,
      title: 'This is news title 2',
    ),
  ];

  test('should get news list from repository', () async {
    // arrange
    when(mockNewsRepository.getNews()).thenAnswer((_) async => Right(tNews));

    // act
    final result = await useCase.call(NoParams());

    // assert
    expect(result, Right(tNews));
    verify(mockNewsRepository.getNews());
    verifyNoMoreInteractions(mockNewsRepository);
  });
}
