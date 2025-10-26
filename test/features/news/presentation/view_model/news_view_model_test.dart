import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lotus_news/core/exceptions/failure.dart';
import 'package:lotus_news/core/usecases/usecase.dart';
import 'package:lotus_news/features/news/data/model/news_model.dart';
import 'package:lotus_news/features/news/domain/usecases/get_news_by_id_usecase.dart';
import 'package:lotus_news/features/news/domain/usecases/get_news_usecase.dart';
import 'package:lotus_news/features/news/presentation/view_model/news_state.dart';
import 'package:lotus_news/features/news/presentation/view_model/news_view_model.dart';
import 'package:mocktail/mocktail.dart';

class MockGetNewsUseCase extends Mock implements GetNewsUseCase {}

class MockGetNewsByIdUseCase extends Mock implements GetNewsByIdUseCase {}

class FakeNoParams extends Fake implements NoParams {}

class FakeNewsParam extends Fake implements NewsParam {}

void main() {
  late NewsViewModel viewModel;
  late MockGetNewsUseCase mockGetNewsUseCase;
  late MockGetNewsByIdUseCase mockGetNewsByIdUseCase;

  setUpAll(() {
    registerFallbackValue(FakeNoParams());
    registerFallbackValue(FakeNewsParam());
  });

  setUp(() {
    mockGetNewsUseCase = MockGetNewsUseCase();
    mockGetNewsByIdUseCase = MockGetNewsByIdUseCase();

    viewModel = NewsViewModel(mockGetNewsUseCase, mockGetNewsByIdUseCase);
  });

  tearDown(() {
    viewModel.dispose();
  });

  group('NewsViewModel - getNews', () {
    final tNewsList = [
      NewsModel(
        id: '1',
        body: 'News body 1',
        createdAt: DateTime.now().toIso8601String(),
        score: 0,
        title: 'News title 1',
      ),
      NewsModel(
        id: '2',
        body: 'News body 2',
        createdAt: DateTime.now().toIso8601String(),
        score: 0,
        title: 'News title 2',
      ),
    ];

    test('initial state should be NewsInitial', () {
      // assert
      expect(viewModel.state, isA<NewsInitialize>());
    });

    test(
      'should emit NewsLoading then NewsSuccess when data is fetched successfully',
      () async {
        // arrange
        when(
          () => mockGetNewsUseCase.call(any()),
        ).thenAnswer((_) async => Right(tNewsList));

        // create a list to track state changes
        final states = <NewsState>[];
        viewModel.addListener(() {
          states.add(viewModel.state);
        });

        // act
        await viewModel.getNews();

        // assert
        expect(states.length, 2);
        expect(states[0], isA<NewsLoading>());
        expect(states[1], isA<NewsSuccess>());

        final successState = states[1] as NewsSuccess;
        expect(successState.data, tNewsList);
        expect(successState.data.length, 2);

        verify(() => mockGetNewsUseCase.call(NoParams())).called(1);
        verifyNoMoreInteractions(mockGetNewsUseCase);
      },
    );

    test(
      'should emit NewsLoading then NewsError when fetching fails',
      () async {
        // arrange
        const tErrorMessage = 'Server error';
        when(
          () => mockGetNewsUseCase.call(any()),
        ).thenAnswer((_) async => const Left(Failure(message: tErrorMessage)));

        final states = <NewsState>[];
        viewModel.addListener(() {
          states.add(viewModel.state);
        });

        // act
        await viewModel.getNews();

        // assert
        expect(states.length, 2);
        expect(states[0], isA<NewsLoading>());
        expect(states[1], isA<NewsError>());

        final errorState = states[1] as NewsError;
        expect(errorState.message, tErrorMessage);

        verify(() => mockGetNewsUseCase.call(NoParams())).called(1);
      },
    );

    test('should emit NewsError with network failure message', () async {
      // arrange
      const tErrorMessage = 'No internet connection';
      when(
        () => mockGetNewsUseCase.call(any()),
      ).thenAnswer((_) async => const Left(Failure(message: tErrorMessage)));

      final states = <NewsState>[];
      viewModel.addListener(() {
        states.add(viewModel.state);
      });

      // act
      await viewModel.getNews();

      // assert
      final errorState = viewModel.state as NewsError;
      expect(errorState.message, tErrorMessage);
    });

    test(
      'should emit NewsSuccess with empty list when no data available',
      () async {
        // arrange
        when(
          () => mockGetNewsUseCase.call(any()),
        ).thenAnswer((_) async => const Right([]));
        final states = <NewsState>[];
        viewModel.addListener(() {
          states.add(viewModel.state);
        });

        // act
        await viewModel.getNews();

        // assert
        expect(viewModel.state, isA<NewsSuccess>());
        final successState = viewModel.state as NewsSuccess;
        expect(successState.data, isEmpty);
      },
    );

    test('should handle exception and emit NewsError', () async {
      // arrange
      when(
        () => mockGetNewsUseCase.call(any()),
      ).thenThrow(Exception('Unexpected error'));

      final states = <NewsState>[];
      viewModel.addListener(() {
        states.add(viewModel.state);
      });

      // act
      await viewModel.getNews();

      // assert
      expect(viewModel.state, isA<NewsError>());
      final errorState = viewModel.state as NewsError;
      expect(errorState.message, contains('Unexpected error'));
    });
  });
}
