import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:multi_stopwatch/views/widgets/time_display.dart";

void main() {
  group("TimeDisplay", () {
    testWidgets("0秒の場合、00:00と0.00hが表示される", (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: TimeDisplay(elapsedSeconds: 0),
            ),
          ),
        ),
      );

      expect(find.text("00:00"), findsOneWidget);
      expect(find.text("0.00h"), findsOneWidget);
    });

    testWidgets("1時間30分（5400秒）の場合、01:30と1.50hが表示される", (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: TimeDisplay(elapsedSeconds: 5400),
            ),
          ),
        ),
      );

      expect(find.text("01:30"), findsOneWidget);
      expect(find.text("1.50h"), findsOneWidget);
    });

    testWidgets("2時間45分（9900秒）の場合、02:45と2.75hが表示される", (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: TimeDisplay(elapsedSeconds: 9900),
            ),
          ),
        ),
      );

      expect(find.text("02:45"), findsOneWidget);
      expect(find.text("2.75h"), findsOneWidget);
    });

    testWidgets("15分（900秒）の場合、00:15と0.25hが表示される", (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: TimeDisplay(elapsedSeconds: 900),
            ),
          ),
        ),
      );

      expect(find.text("00:15"), findsOneWidget);
      expect(find.text("0.25h"), findsOneWidget);
    });

    testWidgets("10時間（36000秒）の場合、10:00と10.00hが表示される", (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: TimeDisplay(elapsedSeconds: 36000),
            ),
          ),
        ),
      );

      expect(find.text("10:00"), findsOneWidget);
      expect(find.text("10.00h"), findsOneWidget);
    });

    testWidgets("TimeDisplayは正しいスタイルで表示される", (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: TimeDisplay(elapsedSeconds: 3600),
            ),
          ),
        ),
      );

      // HH:MM形式のテキストを探す
      final hhmmText = tester.widget<Text>(find.text("01:00"));
      expect(hhmmText.style?.fontSize, 32);
      expect(hhmmText.style?.fontWeight, FontWeight.bold);

      // 0.25単位のテキストを探す
      final quarterText = tester.widget<Text>(find.text("1.00h"));
      expect(quarterText.style?.fontSize, 16);
      expect(quarterText.style?.color, Colors.grey);
    });
  });
}
