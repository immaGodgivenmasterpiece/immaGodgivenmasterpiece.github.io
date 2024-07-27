import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../reading_state.dart';
import '../reading_page.dart';

class TileGrid extends StatefulWidget {
  @override
  _TileGridState createState() => _TileGridState();
}

class _TileGridState extends State<TileGrid> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final readingState = Provider.of<ReadingState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('교독문'),
        actions: [
          ElevatedButton(
            onPressed: () {
              _jumpToNextUnread(readingState);
            },
            child: Text('오늘의 교독문'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: GridView.builder(
        controller: _scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          childAspectRatio: 1.0,
        ),
        itemCount: 137,
        itemBuilder: (context, index) {
          final tileId = 'tile_$index';
          final isRead = readingState.readStatus[tileId] ?? false;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReadingPage(tileId: tileId),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.all(4),
              color: isRead ? Colors.green : Colors.red,
              child: Center(child: Text('${index + 1}')),
            ),
          );
        },
      ),
    );
  }

  void _jumpToNextUnread(ReadingState readingState) {
    // 이미 정렬된 상태의 _readStatus에서 마지막으로 읽은 타일의 인덱스를 찾습니다.
    int lastReadIndex = readingState.getNextUnreadTileIndex() - 1;
    // 마지막으로 읽은 타일이 없거나 모든 타일이 읽혔다면, 함수를 종료합니다.
    if (lastReadIndex == -2)
      return; // getNextUnreadTileIndex가 0을 반환했다면, 모든 타일이 읽힌 것입니다.
    // 마지막으로 읽은 타일 다음 타일로 스크롤해야 하므로 인덱스를 1 증가시킵니다.
    int nextUnreadIndex = lastReadIndex + 1;
    // 스크롤할 위치를 계산합니다.
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final itemWidth = screenWidth / 5; // 5는 crossAxisCount입니다.
    final itemHeight = itemWidth; // 정사각형 타일을 가정합니다.
    final rowIndex = nextUnreadIndex ~/ 5;
    final targetPosition = rowIndex * itemHeight;
    _scrollController.jumpTo(targetPosition);
  }
}
