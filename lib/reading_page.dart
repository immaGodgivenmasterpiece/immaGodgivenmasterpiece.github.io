// lib/reading_page.dart 수정 부분
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'reading_state.dart';

class ReadingPage extends StatelessWidget {
  final String tileId;
  ReadingPage({required this.tileId});

  @override
  Widget build(BuildContext context) {
    final readingState = Provider.of<ReadingState>(context);
    final isRead = readingState.readStatus[tileId] ?? false;
    return Scaffold(
      appBar: AppBar(title: Text('교독문 $tileId')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text('여기에 교독문 내용을 표시합니다.'),
            ),
          ),
          if (isRead) // 읽은 타일에 "읽음 취소" 버튼을 표시
            ElevatedButton(
              onPressed: () {
                readingState.markAsUnread(tileId); // 읽음 상태를 취소하는 함수 호출
                Navigator.pop(context);
              },
              child: Text('읽음 취소'),
            ),
          if (!isRead) // 읽지 않은 타일에는 "읽음 표시" 버튼을 계속 표시
            ElevatedButton(
              onPressed: () {
                readingState.markAsRead(tileId);
                Navigator.pop(context);
              },
              child: Text('읽음 표시'),
            ),
          SizedBox(height: 8), // 버튼 사이의 공간 추가
        ],
      ),
    );
  }
}
