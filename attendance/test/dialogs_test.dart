import 'package:attendance/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          body: FlatButton(
            child: const Text('show'),
            onPressed: () {
              Dialogs.messageDialog(context, 'title', 'message');
            },
          ),
        ),
      );
}

// @todo #64 fix tests and unskip them
//  we should test the behaviour specified in the description
//  of every test.
void main() {
  testWidgets('test message dialog shows correct data',
      (WidgetTester tester) async {
    await tester.pumpWidget(MyWidget());
    await tester.press(find.text('show'));
    final Finder titleFinder = find.text('title');
    final Finder messageFinder = find.text('message');
    expect(titleFinder, findsOneWidget);
    expect(messageFinder, findsOneWidget);
  }, skip: true);

  testWidgets('test message dialog shows no ok is shown',
      (WidgetTester tester) async {
    await tester.pumpWidget(MyWidget());
    await tester.press(find.text('show'));
    final Finder titleFinder = find.text('title');
    final Finder messageFinder = find.text('message');
    expect(titleFinder, findsOneWidget);
    expect(messageFinder, findsOneWidget);
  }, skip: true);

  testWidgets('test message dialog shows ok button',
      (WidgetTester tester) async {
    await tester.pumpWidget(MyWidget());
    await tester.press(find.text('show'));
    final Finder titleFinder = find.text('title');
    final Finder messageFinder = find.text('message');
    expect(titleFinder, findsOneWidget);
    expect(messageFinder, findsOneWidget);
  }, skip: true);

  testWidgets('test message dialog press ok return ok result',
      (WidgetTester tester) async {
    await tester.pumpWidget(MyWidget());
    await tester.press(find.text('show'));
    final Finder titleFinder = find.text('title');
    final Finder messageFinder = find.text('message');
    expect(titleFinder, findsOneWidget);
    expect(messageFinder, findsOneWidget);
  }, skip: true);

  testWidgets('test message dialog press close returns close result',
      (WidgetTester tester) async {
    await tester.pumpWidget(MyWidget());
    await tester.press(find.text('show'));
    final Finder titleFinder = find.text('title');
    final Finder messageFinder = find.text('message');
    expect(titleFinder, findsOneWidget);
    expect(messageFinder, findsOneWidget);
  }, skip: true);
}
