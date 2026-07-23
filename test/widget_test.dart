import 'package:flutter_test/flutter_test.dart';
import 'package:clothes_store/main.dart';
import 'package:clothes_store/core/cache/cache_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App should load login screen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await CacheHelper.init();
    await tester.pumpWidget(const ClothesStore(isLoggedIn: false));
    await tester.pumpAndSettle(const Duration(seconds: 4));
    expect(find.text('Login'), findsAtLeastNWidgets(1));
  });
}
