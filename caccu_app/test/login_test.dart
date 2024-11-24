import 'package:caccu_app/presentation/Screen/Account/UserViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:caccu_app/data/service/LocalStorage.dart';
import 'package:caccu_app/data/usecase/userUsecase.dart';
import 'package:caccu_app/presentation/Screen/navigator.dart';

class MockUserUseCase extends Mock implements UserUseCase {}
class MockLocalStorageService extends Mock implements LocalStorageService {}
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late UserViewModel userViewModel;
  late MockUserUseCase mockUserUseCase;
  late MockLocalStorageService mockLocalStorageService;
  late MockNavigatorObserver mockObserver;

  setUp(() {
    mockUserUseCase = MockUserUseCase();
    mockLocalStorageService = MockLocalStorageService();
    userViewModel = UserViewModel();
    mockObserver = MockNavigatorObserver();
  });

  testWidgets('nextScreen chuyển sang màn hình NavScreen khi thông tin hợp lệ', (tester) async {
    const testEmail = 'loi2003zzz@gmail.com';
    const testPassword = 'fhhefgheh';

    when(mockUserUseCase.checkUserCredentials(testEmail, testPassword)).thenAnswer((_) async => true);
    when(mockLocalStorageService.saveUserEmail(testEmail)).thenAnswer((_) async {});

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                userViewModel.nextScreen(context, testEmail, testPassword);
              },
              child: const Text('Login'),
            );
          },
        ),
        navigatorObservers: [mockObserver],
      ),
    );

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    verify(mockObserver.didPush(NavScreen() as Route, any));
    expect(find.byType(NavScreen), findsOneWidget);
  });

  testWidgets('nextScreen hiển thị lỗi nếu thông tin không hợp lệ', (tester) async {
    const testEmail = '';
    const testPassword = 'password123';

    when(mockUserUseCase.checkUserCredentials(testEmail, testPassword)).thenAnswer((_) async => false);

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                userViewModel.nextScreen(context, testEmail, testPassword);
              },
              child: const Text('Login'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    expect(find.text('Lỗi đăng nhập'), findsOneWidget);
    expect(find.text('Email hoặc mật khẩu không đúng, vui lòng thử lại.'), findsOneWidget);
  });
}
