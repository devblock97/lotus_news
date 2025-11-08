import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotus_news/core/components/no_data_view.dart';
import 'package:lotus_news/features/news/presentation/view/news_screen.dart';
import 'package:lotus_news/features/news/presentation/view_model/news_state.dart';
import 'package:lotus_news/features/news/presentation/view_model/news_view_model.dart';
import 'package:lotus_news/features/news/presentation/view_model/vote_view_model.dart';
import 'package:lotus_news/features/news/presentation/widgets/card_skeleton.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockNewsViewModel extends Mock implements NewsViewModel {}

class MockVoteViewModel extends Mock implements VoteViewModel {}

void main() {
  late MockNewsViewModel mockNewsViewModel;
  late MockVoteViewModel mockVoteViewModel;

  setUp(() {
    mockNewsViewModel = MockNewsViewModel();
    mockVoteViewModel = MockVoteViewModel();
    when(() => mockNewsViewModel.addListener(any())).thenReturn(null);
    when(() => mockNewsViewModel.removeListener(any())).thenReturn(null);
    when(() => mockVoteViewModel.addListener(any())).thenReturn(null);
    when(() => mockVoteViewModel.removeListener(any())).thenReturn(null);
  });

  // Helper function to wrap widget with Provider
  Widget makeTestableWidget(Widget child) {
    return MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<NewsViewModel>.value(value: mockNewsViewModel),
          ChangeNotifierProvider<VoteViewModel>.value(value: mockVoteViewModel),
        ],
        child: child,
      ),
    );
  }

  group('NewsScreen Widget Tests', () {
    // final tNewsList = [
    //   NewsModel(
    //     id: '1',
    //     body: 'Test News 1',
    //     createdAt: 'Description 1',
    //     score: 0,
    //     title: 'Test Title 1',
    //   ),
    //   NewsModel(
    //     id: '2',
    //     body: 'Test News 2',
    //     createdAt: 'Description 2',
    //     score: 0,
    //     title: 'Test Title 2',
    //   ),
    // ];

    testWidgets('should show NewsCardSkeleton when state is NewsLoading', (
      tester,
    ) async {
      // Arrange
      when(() => mockNewsViewModel.state).thenReturn(NewsLoading());
      when(() => mockNewsViewModel.getNews()).thenAnswer((_) async {});

      // Act
      await tester.pumpWidget(makeTestableWidget(const NewsScreen()));
      await tester.pump();

      // Assert
      expect(find.byKey(const Key('news_card_skeleton')), findsOneWidget);
      expect(find.byType(NewsCardSkeleton), findsOneWidget);
    });

    testWidgets('should show error view when state is NewsError', (
      tester,
    ) async {
      // Arrange
      const errorMessage = 'Failed to load news';
      when(
        () => mockNewsViewModel.state,
      ).thenReturn(const NewsError(errorMessage));
      when(() => mockNewsViewModel.getNews()).thenAnswer((_) async {});

      // Act
      await tester.pumpWidget(makeTestableWidget(const NewsScreen()));
      await tester.pump();

      // Assert
      expect(find.text(errorMessage), findsOneWidget);
      expect(find.byType(NewsCardSkeleton), findsNothing);
    });

    testWidgets('should show empty view when news list is empty', (
      tester,
    ) async {
      // Arrange
      when(
        () => mockNewsViewModel.state,
      ).thenReturn(const NewsSuccess(data: []));
      when(() => mockNewsViewModel.getNews()).thenAnswer((_) async {});

      // Act
      await tester.pumpWidget(makeTestableWidget(const NewsScreen()));
      await tester.pump();

      // Assert
      expect(find.byType(NoDataView), findsOneWidget);
    });

    // testWidgets('should show news list when state is NewsSuccess with data', (
    //   tester,
    // ) async {
    //   // Arrange
    //   when(() => mockNewsViewModel.getNews()).thenAnswer((_) async {});
    //   when(
    //     () => mockNewsViewModel.state,
    //   ).thenReturn(NewsSuccess(data: tNewsList));
    //
    //   // Act
    //   await tester.pumpWidget(makeTestableWidget(const NewsScreen()));
    //   await tester.pump();
    //   // await tester.pump();
    //
    //   // Assert
    //   expect(find.byKey(const Key('news_list')), findsOneWidget);
    //   // expect(find.byType(NewsCard), findsNWidgets(2));
    // });

    // testWidgets('should display correct news titles', (tester) async {
    //   // Arrange
    //   when(() => mockNewsViewModel.state).thenReturn(NewsSuccess(data: tNewsList));
    //   when(() => mockNewsViewModel.getNews()).thenAnswer((_) async {});
    //   debugPrint('check point 1: ${mockNewsViewModel.state}');
    //
    //   // Act
    //   await tester.pumpWidget(makeTestableWidget(const NewsScreen()));
    //   await tester.pump();
    //   debugPrint('check point 2');
    //
    //   // Assert
    //   expect(find.byKey(const Key('news_list')), findsOneWidget);
    //
    //   expect(find.byType(NewsCard), findsNWidgets(2));
    //   expect(find.text('Test Title 1'), findsOneWidget);
    //   expect(find.text('Test Title 2'), findsOneWidget);
    // });

    // testWidgets('should call getNews on initState', (tester) async {
    //   // Arrange
    //   when(() => mockNewsViewModel.state).thenReturn(NewsInitialize());
    //   when(() => mockNewsViewModel.getNews()).thenAnswer((_) async {});
    //
    //   // Act
    //   await tester.pumpWidget(makeTestableWidget(const NewsScreen()));
    //   await tester.pumpAndSettle();
    //
    //   // Assert
    //   verify(() => mockNewsViewModel.getNews()).called(1);
    // });

    testWidgets('should show CircularProgressIndicator for default state', (
      tester,
    ) async {
      // Arrange
      when(() => mockNewsViewModel.state).thenReturn(NewsInitialize());
      when(() => mockNewsViewModel.getNews()).thenAnswer((_) async {});

      // Act
      await tester.pumpWidget(makeTestableWidget(const NewsScreen()));
      await tester.pump();

      // Assert
      expect(find.byKey(const Key('default_loading')), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    // testWidgets('should navigate to DetailScreen when news card tapped', (tester) async {
    //   // Arrange
    //   when(() => mockNewsViewModel.state).thenReturn(NewsSuccess(data: tNewsList));
    //   when(() => mockVoteViewModel.state).thenReturn(VoteInitializeState());
    //   when(() => mockNewsViewModel.getNews()).thenAnswer((_) async {});
    //
    //   // Act
    //   await tester.pumpWidget(makeTestableWidget(const NewsScreen()));
    //   await tester.pump();
    //   await tester.tap(find.byType(NewsCard).first);
    //   await tester.pumpAndSettle();
    //
    //   // Assert
    //   expect(find.byType(DetailScreen), findsOneWidget);
    // });
    //
    // testWidgets('should handle state transition from loading to success', (tester) async {
    //   // Arrange - Start with loading
    //   when(() => mockNewsViewModel.state).thenReturn(NewsLoading());
    //   when(() => mockNewsViewModel.getNews()).thenAnswer((_) async {});
    //   when(() => mockVoteViewModel.state).thenReturn(VoteInitializeState());
    //
    //   await tester.pumpWidget(makeTestableWidget(const NewsScreen()));
    //   await tester.pump();
    //
    //   expect(find.byType(NewsCardSkeleton), findsOneWidget);
    //
    //   // Act
    //   when(() => mockNewsViewModel.state).thenReturn(NewsSuccess(data: tNewsList));
    //   await tester.pump();
    //
    //   // Assert
    //   expect(find.byType(NewsCardSkeleton), findsNothing);
    //   expect(find.byType(NewsCard), findsNWidgets(2));
    // });
  });
}
