import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int queenNumber;
  final VoidCallback onBack;
  final List<List<String>> results;
  const ResultScreen(
      {super.key,
      required this.queenNumber,
      required this.onBack,
      required this.results});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (results.isEmpty)
            Text(
                "$queenNumber * $queenNumber plates have no enough place for $queenNumber queens.")
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
                              'Result ${index + 1}',
                              style: const TextStyle(color: Colors.blue),
                            ),
                          );
                        })),
                    Expanded(
                      child: TabBarView(
                        children: List.generate(results.length, (index) {
                          //['.Q..','...Q'] => ['.','Q','.','.'   ,'.','.','.','Q']
                          List<String> result = results[index].join().split('');

                          double width =
                              MediaQuery.sizeOf(context).shortestSide / 2;
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
