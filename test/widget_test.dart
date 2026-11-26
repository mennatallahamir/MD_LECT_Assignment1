import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:assignment1/main.dart';

void main() {
  testWidgets('Test entering birthdate and calculating age', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Assignment 1'), findsOneWidget);
    expect(find.text('Submit'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), 'Ahmed');
    await tester.enterText(find.byType(TextField).at(1), '2004-11-24');
    await tester.enterText(find.byType(TextField).at(2), '3');

    await tester.tap(find.text('Submit'));
    await tester.pump();

    final now = DateTime.now();
    final birthDate = DateTime(2004, 11, 24);
    int expectedAge = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      expectedAge--;
    }

    expect(find.text('Age: $expectedAge'), findsOneWidget);
    expect(find.text('Year of birth: 2004'), findsOneWidget);
    expect(find.text('Month of birth: 11'), findsOneWidget);
    expect(find.text('Day of birth: 24'), findsOneWidget);
    expect(
      find.text('Hi Ahmed, you are in level 3, and your month of birth is 11'),
      findsOneWidget,
    );
    expect(find.byType(IconButton), findsWidgets);
  });
}
