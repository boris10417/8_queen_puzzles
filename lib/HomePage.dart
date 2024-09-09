/*
  呈現8皇后謎題的解法
 */

import 'dart:core';

import 'package:flutter/material.dart';

import 'model.dart';
import 'solution_one.dart';

enum LayoutState {
  setting,
  result,
  //用來測試的
  test
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ///棋盤邊長,皇后數
  ///
  ///限制在1~9之間
  int queenNumber = 1;

  ///答案
  List<List<String>> results = [];

  Plate plate = Plate.init(0);

  ///介面狀態
  LayoutState layoutState = LayoutState.setting;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('8 queen puzzles '),
            if (layoutState == LayoutState.result)
              Text('(n = $queenNumber 有${results.length}個結果)'),
          ],
        ),
      ),
      body: switch (layoutState) {
        LayoutState.setting => showSetting(),
        LayoutState.result => showResult(),
        LayoutState.test => showTest(),
      },
    );
  }

  //顯示測試面板
  Widget showTest() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //狀態列
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (plate.hasWar())
                  ? const Icon(
                      Icons.warning,
                      color: Colors.red,
                    )
                  : const Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
              (plate.hasWar()) ? const Text('有衝突') : const Text('無衝突')
            ],
          ),

          SizedBox(
            width:  MediaQuery.sizeOf(context).shortestSide / 2,
            child: AspectRatio(
              aspectRatio: 1,
              child: GridView.count(
                crossAxisCount: queenNumber,
                children: List.generate(plate.points.length, (index) {
                  Color color = (plate.points[index].data == 'Q')
                      ? Colors.red
                      : Colors.blue;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          plate.points[index].data =
                              (plate.points[index].data == 'Q') ? '.' : 'Q';
                        });
                      },
                      child: Container(
                        color: color,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          showReset()
        ],
      ),
    );
  }

  ///顯示結果面板
  Widget showResult() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (results.isEmpty)
            Text("$queenNumber * $queenNumber 的棋盤不存在$queenNumber個皇后的解!")
          else
            Expanded(
              child: DefaultTabController(
                length: results.length,
                child: Column(
                  children: [
                    TabBar(
                        isScrollable: true,
                        tabs: List.generate(results.length, (index) {
                          return Tab(
                            child: Text(
                              '結果${index + 1}',
                              style: const TextStyle(color: Colors.blue),
                            ),
                          );
                        })),
                    Expanded(
                      child: TabBarView(
                        children: List.generate(results.length, (index) {
                          //['.Q..','...Q'] => ['.','Q','.','.'   ,'.','.','.','Q']
                          List<String> result = results[index].join().split('');

                          double width = MediaQuery.sizeOf(context).shortestSide / 2;
                          return Center(
                            child: SizedBox(
                              width: width,
                              height: width,
                              child: GridView.count(
                                crossAxisCount: queenNumber,
                                children: List.generate(result.length, (index) {
                                  String data = result[index];
                                  Color color =
                                      (data == 'Q') ? Colors.red : Colors.blue;
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      color: color,
                                    ),
                                  );
                                }),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          showReset()
        ],
      ),
    );
  }

  ///顯示設定面板
  Widget showSetting() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          showQueenNumberPanel(),
          const SizedBox(
            height: 20,
          ),
          FilledButton(
            onPressed: beginToCalculate,
            child: const Text('開始計算'),
          ),
          const SizedBox(
            height: 20,
          ),
          FilledButton(
            onPressed: beginToTest,
            child: const Text('測試面板'),
          ),
        ],
      ),
    );
  }

  ///皇后數控制面板
  Widget showQueenNumberPanel() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('皇后數'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: reduceQueenNumber,
                icon: const Icon(Icons.remove_circle)),
            Text(queenNumber.toString()),
            IconButton(
                onPressed: addQueenNumber, icon: const Icon(Icons.add_circle)),
          ],
        ),
      ],
    );
  }

  ///重置按鈕
  Widget showReset() {
    return FilledButton(
        onPressed: () => setState(reset), child: const Text('重置'));
  }

  ///是否能合法運算
  bool isValid() {
    return queenNumber * queenNumber == plate.points.length;
  }

  void addQueenNumber() {
    if (queenNumber + 1 > 9) {
      return;
    }
    setState(() {
      queenNumber++;
    });
  }

  void reduceQueenNumber() {
    if (queenNumber - 1 < 1) {
      return;
    }
    setState(() {
      queenNumber--;
    });
  }

  ///開始計算
  void beginToCalculate() {
    plate = Plate.init(queenNumber);
    if (isValid() == false) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('皇后數平方應該等於棋盤格子數!')));
      return;
    }
    setState(() {
      layoutState = LayoutState.result;
    });
    calculateQueenNumber();
  }

  ///開始測試
  void beginToTest() {
    setState(() {
      // result = List.filled(queenNumber * queenNumber, '.');

      plate = Plate.init(queenNumber);
      layoutState = LayoutState.test;
    });
  }

  ///重置
  void reset() {
    setState(() {
      plate = Plate.init(0);
      layoutState = LayoutState.setting;
    });
  }

  ///計算皇后數字
  void calculateQueenNumber() {
    SolutionOne solution = SolutionOne();
    results = solution.solveNQueens(queenNumber);
  }
}
