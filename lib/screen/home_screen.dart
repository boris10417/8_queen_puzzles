/*
  呈現8皇后謎題的解法
 */

import 'dart:core';

import 'package:eight_queen_puzzles/screen/result_screen.dart';
import 'package:eight_queen_puzzles/screen/test_screen.dart';
import 'package:flutter/material.dart';

import '../model.dart';
import '../solution_one.dart';

enum LayoutState {
  setting,
  result,
  //用來測試的
  test
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
              Text('(n = $queenNumber has ${results.length} answers)'),
          ],
        ),
      ),
      body: switch (layoutState) {
        LayoutState.setting => showSetting(),
        LayoutState.result => ResultScreen(
            queenNumber: queenNumber,
            onBack: () => setState(reset),
            results: results,
          ),
        LayoutState.test => TestScreen(
            queenNumber: queenNumber,
            onBack: () => setState(reset),
            onCellPressed: (index) {
              setState(() {
                plate.points[index].data =
                    (plate.points[index].data == 'Q') ? '.' : 'Q';
              });
            },
            plate: plate,
          ),
      },
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
            child: const Text('Start'),
          ),
          const SizedBox(
            height: 20,
          ),
          FilledButton(
            onPressed: beginToTest,
            child: const Text('Test panel'),
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
        const Text('N queens/rows'),
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

  ///增加皇后數
  void addQueenNumber() {
    if (queenNumber + 1 > 9) {
      return;
    }
    setState(() {
      queenNumber++;
    });
  }

  ///減少皇后數
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
    if (plate.isValid(queenNumber) == false) {
      //皇后數平方應該等於棋盤格子數
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('The square of N should equal to plate\'s cells')));
      return;
    }

    calculateQueenNumber();

    setState(() {
      layoutState = LayoutState.result;
    });
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
