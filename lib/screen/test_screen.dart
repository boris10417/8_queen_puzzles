import 'package:eight_queen_puzzles/model.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  final int queenNumber;
  final VoidCallback onBack;
  final Plate plate;
  const TestScreen(
      {super.key,
      required this.queenNumber,
      required this.onBack,
      required this.plate});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  //展示分頁們
  late List<Plate> demoPlates = [widget.plate];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: demoPlates.length,
        child: Center(
          child: Column(
            children: [
              TabBar(
                  isScrollable: true,
                  tabs: List.generate(demoPlates.length, (index) {
                    return Tab(
                      child: Row(
                        children: [
                          Text(
                            "Page ${index + 1}",
                            style: const TextStyle(color: Colors.blue),
                          ),
                          IconButton(
                              onPressed: () => onPageDelete(index),
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.grey,
                              ))
                        ],
                      ),
                    );
                  })),
              Expanded(
                child: TabBarView(
                    children: List.generate(demoPlates.length, (index) {
                  return showDemoPlate(index);
                })),
              )
            ],
          ),
        ));
  }

  Widget showDemoPlate(int demoPlateIndex) {
    Plate plate = demoPlates[demoPlateIndex];
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
              (plate.hasWar())
                  ? const Text('Conflict')
                  : const Text('No conflict')
            ],
          ),

          SizedBox(
            width: MediaQuery.sizeOf(context).shortestSide / 2,
            child: AspectRatio(
              aspectRatio: 1,
              child: GridView.count(
                crossAxisCount: widget.queenNumber,
                children: List.generate(plate.points.length, (index) {
                  Color color = (plate.points[index].data == 'Q')
                      ? Colors.red
                      : Colors.blue;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () => onPlateCellPressed(demoPlateIndex, index),
                      child: Container(
                        color: color,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              showBackButton(),
              showAddButton(),
            ],
          )
        ],
      ),
    );
  }

  ///返回按鈕
  Widget showBackButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FilledButton(onPressed: widget.onBack, child: const Text('Back')),
    );
  }

  ///新增按鈕
  Widget showAddButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FilledButton(
          onPressed: () {
            setState(() {
              demoPlates = [...demoPlates, Plate.init(widget.queenNumber)];
            });
          },
          child: const Text('Add new page')),
    );
  }

  ///某分頁被刪除時
  void onPageDelete(int index) {
    if (demoPlates.length == 1) {
      //剩一個時不能刪掉。
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('At least keep one page!')));
      return;
    }
    setState(() {
      demoPlates =
          demoPlates.where((e) => demoPlates.indexOf(e) != index).toList();
    });
  }

  ///當某一個棋盤的元素被切換
  void onPlateCellPressed(int demoPlateIndex, int index) {
    setState(() {
      // plate.points[index].data =
      //     (plate.points[index].data == 'Q') ? '.' : 'Q';
      demoPlates[demoPlateIndex].points[index].data =
          (demoPlates[demoPlateIndex].points[index].data == 'Q') ? '.' : 'Q';
    });
  }
}

/*
 Widget showTest() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //狀態列
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (widget.plate.hasWar())
                  ? const Icon(
                      Icons.warning,
                      color: Colors.red,
                    )
                  : const Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
              (widget.plate.hasWar())
                  ? const Text('Conflict')
                  : const Text('No conflict')
            ],
          ),

          SizedBox(
            width: MediaQuery.sizeOf(context).shortestSide / 2,
            child: AspectRatio(
              aspectRatio: 1,
              child: GridView.count(
                crossAxisCount: widget.queenNumber,
                children: List.generate(widget.plate.points.length, (index) {
                  Color color = (widget.plate.points[index].data == 'Q')
                      ? Colors.red
                      : Colors.blue;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () => widget.onCellPressed(index),
                      child: Container(
                        color: color,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          showBackButton()
        ],
      ),
    );
  }
 */
