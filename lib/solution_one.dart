/*
  解法1號

  條件:設n為棋盤邊長/皇后需求數

  假設1:每列都至少有一個且只有一個皇后。

*/

/* 流程區
主流程:
  
  1.當 i < n，結束跳到4.

  2.擺放第i列的皇后，取得所有的分支棋盤們。

  3.i++，回到1.

  4.轉換答案並回傳結果。

  ----------------------------------------

  取得所有的分支棋盤們 的流程:

  1.取得第i列未佔領的點們

  2.根據第i列未佔領的點們，計算新的棋盤們

  ----------------------------------------

  取得第i列未佔領的點們 的流程:

  1.取得棋盤的未佔領的點
  
  2.從棋盤的未佔領的點，取出列相同者

  ----------------------------------------

  取得棋盤的未佔領的點 的流程

  1.依序取得所有空白的位置

  2.依序取得當前所有皇后的位置們
  
  3.依序比對每一個空白的位置是否與任一皇后有衝突。

  4.若皆無衝突，代表是未佔領的點，蒐集起來

  ----------------------------------------

  取得所有空白的位置 的流程

  1.回傳data是'.'的

  ----------------------------------------

  取得所有皇后的位置 的流程

  1.回傳data是'Q'的

  ----------------------------------------

  比對每一個空白的位置是否與任一皇后有衝突 的流程

  1.有衝突 = 是否同一列 || 是否同一行 || 是否同一斜

  ----------------------------------------

  根據第i列未佔領的點們，計算新的棋盤們 的流程
  
  1.依序放入新皇后，產生新棋盤
  
  2.蒐集新棋盤們

  ----------------------------------------

  放入新皇后，產生新棋盤 的流程

  1.找到新皇后的位置，放入皇后
 
  2.產生新棋盤
 */

import 'model.dart';

class SolutionOne {
  ///存放所有棋盤
  List<Plate> plates = [];

  List<List<String>> solveNQueens(int n) {
    //第i列的計數器
    //range: 0 ~ n-1
    int i = 0;

    //放入空棋盤
    plates = [Plate.init(n)];

    while (i < n) {
      //擺放第i列的皇后，取得新的棋盤們
      List<Plate> newPlates = setRowIQueen(i);

      //存好新的棋盤們
      plates = List.from(newPlates);
      i++;
    }

    //若最後的結果是empty，回傳[]
    if (plates.isEmpty) {
      return [];
    }

    //合併版:['.Q..']
    List<List<String>> answers2 = plates.map((e) {
      return e.generateAnswer2(n);
    }).toList();

    return answers2;
  }

  ///擺放第i列的皇后，取得所有的分支棋盤們。
  ///
  ///1.取得可能的分支棋盤們
  ///
  ///2.蒐集此輪所有的分支棋盤們
  List<Plate> setRowIQueen(int i) {
    List<Plate> newPlates = [];
    for (var plate in plates) {
      //取得可能的分支棋盤們
      List<Plate> branchPlates = getBranchPlates(i, plate);
      //蒐集此輪所有的分支棋盤們
      newPlates.addAll(branchPlates);
    }
    return newPlates;
  }

  ///取得可能的分支棋盤們
  ///
  ///1.取得第i列未佔領的點們:
  ///
  /// 若無未佔領的點，代表皇后數達不到需求量，回傳空陣列。(此結果來源於假設1存在)
  ///
  ///2.根據第i列未佔領的點們，計算新的棋盤們
  List<Plate> getBranchPlates(int i, Plate plate) {
    
    //取得第i列未佔領的點們
    List<PlatePoint> remainsInSpecifiedRow = plate.getRemainsInSpecifiedRow(i);

    if (remainsInSpecifiedRow.isEmpty) {
      //若無未佔領的點，代表皇后數達不到需求量，回傳空陣列
      //此結果來源於假設1存在，
      return [];
    }

    //根據第i列未佔領的點們，計算新的棋盤們
    List<Plate> newPlates =
        calculateNewPlatesByNewQueen(remainsInSpecifiedRow, plate);
    return newPlates;
  }

  ///根據第i列未佔領的點們，計算新的棋盤們
  ///
  ///1.依序放入新皇后，產生新棋盤
  ///
  ///2.蒐集新棋盤們
  List<Plate> calculateNewPlatesByNewQueen(
      List<PlatePoint> remainsInSpecifiedRow, Plate plate) {
    List<Plate> newPlates = [];
    for (var element in remainsInSpecifiedRow) {
      //依序放入新皇后，產生新棋盤
      var newPlate = plate.createPlateByNewQueen(element.copyWith(data: 'Q'));
      //蒐集新棋盤們
      newPlates.add(newPlate);
    }
    return newPlates;
  }
}
