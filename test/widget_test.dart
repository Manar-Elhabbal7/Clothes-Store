import 'package:flutter_test/flutter_test.dart';
import 'package:clothes_store/main.dart';

void main() {
  testWidgets('App should load login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ClothesStore());
    expect(find.text('Login'), findsAtLeastNWidgets(1));
  });
}
