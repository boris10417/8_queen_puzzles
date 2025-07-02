import 'package:eight_queen_puzzles/model.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  final int queenNumber;
  final VoidCallback onBack;
  final void Function(int index) onCellPressed;
  final Plate plate;
  const TestScreen(
      {super.key,
      required this.queenNumber,
      required this.onBack,
      required this.onCellPressed,
      required this.plate});

  @override
  Widget build(BuildContext context) {
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
                crossAxisCount: queenNumber,
                children: List.generate(plate.points.length, (index) {
                  Color color = (plate.points[index].data == 'Q')
                      ? Colors.red
                      : Colors.blue;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () => onCellPressed(index),
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

  ///返回按鈕
  Widget showBackButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FilledButton(onPressed: onBack, child: const Text('Back')),
    );
  }
}
