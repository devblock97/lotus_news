import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lotus_news/core/exceptions/failure.dart';
import 'package:lotus_news/core/usecases/usecase.dart';
import 'package:lotus_news/features/news/data/model/news_model.dart';
import 'package:lotus_news/features/news/domain/repositories/news_repository.dart';
import 'package:lotus_news/features/news/domain/usecases/get_news_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

void main() {
  late GetNewsUseCase useCase;
  late MockNewsRepository mockNewsRepository;

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

  test('should get lists of news from repository', () async {
    // arrange
    when(
      () => mockNewsRepository.getNews(),
    ).thenAnswer((_) async => Right(tNews));

    // act
    final result = await useCase.call(NoParams());

    // assert
    expect(result, Right(tNews));
    verify(() => mockNewsRepository.getNews()).called(1);
    verifyNoMoreInteractions(mockNewsRepository);
  });

  test('should return Failure when repository fails', () async {
    // arrange
    const tFailure = Failure(message: 'Server error');
    when(
      () => mockNewsRepository.getNews(),
    ).thenAnswer((_) async => const Left(tFailure));

    // act
    final result = await useCase(NoParams());

    // assert
    expect(result, const Left(tFailure));
    verify(() => mockNewsRepository.getNews()).called(1);
    verifyNoMoreInteractions(mockNewsRepository);
  });

  test('should return NetworkFailure when no internet connection', () async {
    // arrange
    const tFailure = Failure(message: 'No internet connection');
    when(
      () => mockNewsRepository.getNews(),
    ).thenAnswer((_) async => const Left(tFailure));

    // act
    final result = await useCase(NoParams());

    // assert
    expect(result, const Left(tFailure));
    verify(() => mockNewsRepository.getNews()).called(1);
  });

  test('should return empty list when no news available', () async {
    // arrange
    final List<NewsModel> emptyNews = [];
    when(
      () => mockNewsRepository.getNews(),
    ).thenAnswer((_) async => const Right([]));

    // act
    final result = await useCase(NoParams());

    // assert
    expect(result, const Right(<NewsModel>[]));
    result.fold(
      (failure) => fail('Should return success'),
      (newsList) => expect(newsList, emptyNews),
    );
  });
}
