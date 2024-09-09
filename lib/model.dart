import 'dart:core';

///棋盤位置，左上原點(0,0)
///
///(row,col)
class PlatePosition {
  int row;
  int col;
  PlatePosition({required this.row, required this.col});

  ///位置相同
  bool equal(PlatePosition other) {
    return row == other.row && col == other.col;
  }

  ///同一行
  bool inSameColumn(PlatePosition other) {
    return col == other.col;
  }

  ///同一列
  bool inSameRow(PlatePosition other) {
    return row == other.row;
  }

  ///同一斜
  bool inSameSlope(PlatePosition other) {
    int rowDifference = (row - other.row).abs();
    int colDifference = (col - other.col).abs();
    return rowDifference == colDifference;
  }

  ///有衝突
  bool hasConflict(PlatePoint other) {
    return inSameColumn(other) || inSameRow(other) || inSameSlope(other);
  }
}

class PlatePoint extends PlatePosition {
  ///棋盤點:Q or .
  String data;

  PlatePoint({required super.row, required super.col, required this.data});

  PlatePoint copyWith({int? row, int? col, String? data}) {
    return PlatePoint(
        row: row ?? this.row, col: col ?? this.col, data: data ?? this.data);
  }
}

///棋盤
class Plate {
  List<PlatePoint> points = [];

  Plate(this.points);

  factory Plate.init(int n) {
    return Plate(List.generate(n * n, (index) {
      return PlatePoint(row: index ~/ n, col: index % n, data: '.');
    }));
  }

  ///放入新皇后，產生新棋盤
  ///
  ///1.找到新皇后的位置，放入皇后
  ///
  ///2.產生新棋盤
  Plate createPlateByNewQueen(PlatePoint platePoint) {
    var result = [
      for (var element in points)
        // 找到新皇后的位置，放入皇后
        if (element.equal(platePoint)) platePoint 
        // 產生新棋盤
        else element
    ];
    return Plate(result);
  }

  ///取得當前所有皇后的位置們
  List<PlatePoint> getQueensPostions() {
    return points.where((e) {
      return e.data == 'Q';
    }).toList();
  }

  ///取得所有空白的位置
  List<PlatePoint> getEmptyPositions() {
    return points.where((e) {
      return e.data == '.';
    }).toList();
  }

  ///取得棋盤的未佔領的點
  ///
  ///1.依序取得所有空白的位置
  ///
  ///2.依序當前所有皇后的位置們
  ///
  ///3.依序比對每一個空白的位置是否與任一皇后有衝突。
  List<PlatePoint> getRemains() {
    List<PlatePoint> answer = [];
    //依序取得所有空白的位置
    for (var emptyPosition in getEmptyPositions()) {
      bool hasConlict = false;
      //依序當前所有皇后的位置們
      for (var queenPosition in getQueensPostions()) {
        //依序比對每一個空白的位置是否與任一皇后有衝突。
        if (emptyPosition.hasConflict(queenPosition)) {
          hasConlict = true;
          break;
        }
      }

      if (hasConlict == false) {
        //若皆無衝突，代表是未佔領的點
        answer.add(emptyPosition);
      }
    }

    return answer;
  }

  ///取得第i列未佔領的點們
  ///
  ///1.取得棋盤的未佔領的點
  ///
  ///2.取出列相同者
  List<PlatePoint> getRemainsInSpecifiedRow(int i) {
    return getRemains().where((e) {
      return e.row == i;
    }).toList();
  }

  ///取得棋盤的已佔領的點(包含皇后的位置)
  List<PlatePoint> getOccupied() {
    //轉成集合用差集得出已占領的點
    return points.toSet().difference(getRemains().toSet()).toList();
  }

  ///任兩皇后有衝突，代表有戰爭。
  bool hasWar() {
    for (var queenPosition in getQueensPostions()) {
      for (var queenPosition2
          in getQueensPostions().where((e) => e != queenPosition)) {
        if (queenPosition.hasConflict(queenPosition2)) {
          return true;
        }
      }
    }
    return false;
  }

 

  //轉換成答案陣列(合併版)
  List<String> generateAnswer2(int n) {
    List<String> results = points.map((e) {
      return e.data;
    }).toList();
    //  0 ~ n-1
    // (start,end) == (0,n)

    List<String> results2 = [];
    for (var i = 0; i < results.length; i += n) {
      results2.add(results.sublist(i, i + n).join());
    }
    return results2;
  }
}
