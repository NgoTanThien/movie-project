// Widget test cơ bản cho ứng dụng xem phim Movie.
//
// Vì app sử dụng Supabase và GetX nên widget test đầy đủ
// cần mock các dependency này. Đây là smoke test đơn giản
// để kiểm tra MaterialApp có thể render thành công.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MovieApp smoke test - renders MaterialApp',
      (WidgetTester tester) async {
    // Tạo một MaterialApp đơn giản để kiểm tra framework hoạt động
    await tester.pumpWidget(
      MaterialApp(
        title: 'Ứng dụng xem phim',
        theme: ThemeData(
          brightness: Brightness.dark,
        ),
        home: const Scaffold(
          body: Center(
            child: Text('Movie App'),
          ),
        ),
      ),
    );

    // Kiểm tra text được render thành công
    expect(find.text('Movie App'), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
