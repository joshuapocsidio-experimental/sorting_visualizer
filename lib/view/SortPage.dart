import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sorting_visualizer/controller/SortController.dart';
import 'package:sorting_visualizer/model/SortObserver.dart';
import 'package:sorting_visualizer/view/ParameterPanel.dart';
import 'package:sorting_visualizer/view/SortArrayView.dart';
import 'package:sorting_visualizer/view/SortStackView.dart';
import 'package:sorting_visualizer/widgets/SorterCustomButton.dart';

class SortPage extends StatefulWidget {
  @override
  _SortPageState createState() => _SortPageState();
}

enum VisualType {
 ArrayView,
 GraphView,
}

class _SortPageState extends State<SortPage> implements SortUIObserver {
  late VisualType visualType;
  final Stopwatch sw = Stopwatch();
  late Timer t;
  Map<SortChoice, String?> sortMap = {
    SortChoice.Insertion: "Insertion Sort",
    SortChoice.Selection: "Selection Sort",
    SortChoice.Merge: "Merge Sort",
    SortChoice.Bubble: "Bubble Sort",
    SortChoice.Quick: "Quick Sort",
  };

  late Duration _elapsed;

  Future<void> sort() async {
    reset();
    await Future.delayed(Duration(milliseconds: 100));
    // Initialise Timer for updating GUI and initialise stopwatch for time monitoring
    sw.reset();
    sw.start();
    t = Timer.periodic(Duration(), (_) {
      setState(() {
        _elapsed = sw.elapsed;
      });
    });
    // Update Unsorted array with the latest array
    await SortController.instance.sort();
    // Stop timer
    sw.stop();
    t.cancel();
  }

  void stop() {
    setState(() {
      t.cancel();
      sw.stop();
      SortController.instance.stop();
    });
  }

  void reset() {
    setState(() {
      SortController.instance.reset();
      t.cancel();
      sw.stop();
    });
  }

  void generateArray() {
    setState(() {
      SortController.instance.generate();
    });
    reset();
  }

  void updateArraySize(int size){
    setState(() {
      SortController.instance.updateArraySize(size);
    });
  }

  @override
  void deactivate() {
    SortController.instance.removeUIObserver(this);
    super.deactivate();
  }

  @override
  void initState() {
    super.initState();
    _elapsed = Duration();
    t = Timer(_elapsed, (){});
    visualType = VisualType.GraphView;
    SortController.instance.addUIObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 100, top: 100, bottom: 25),
                        child: Row(
                          children: [
                            Container(
                              child: Text(
                                sortMap[SortController.instance.sortChoice]!,
                                style: TextStyle(
                                  fontSize: 50,
                                ),
                              ),
                            ),
                            Tooltip(
                              message: 'This visualiser is not optimised for visualising sorting algorithms in array format. Reduced performance is expected when sorting in array visualisation.',
                              textStyle: TextStyle(
                                fontSize: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  width: 0.5,
                                  color: Colors.blue,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                )
                              ),
                              child: Icon(Icons.info_outline, size: 20, color: Colors.blueGrey,),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 100),
                        child: Tooltip(
                          message: 'hh/mm/ss/ms',
                          textStyle: TextStyle(
                            fontSize: 12,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                width: 0.5,
                                color: Colors.blue,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              )
                          ),
                          child: Text(
                              _elapsed.toString(),
                              style: TextStyle(
                                fontSize: 20,
                              )
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 2,
                        indent: 50,
                        endIndent: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 100),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text("Graph"),
                                Radio(
                                  value: VisualType.GraphView,
                                  groupValue: visualType,
                                  onChanged: (VisualType? type){
                                    setState(() {
                                      visualType = type!;
                                    });
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text("Array"),
                                Radio(
                                  value: VisualType.ArrayView,
                                  groupValue: visualType,
                                  onChanged: (VisualType? type){
                                    setState(() {
                                      visualType = type!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 80),
                        child: ButtonBar(
                          buttonPadding: EdgeInsets.all(10),
                          alignment: MainAxisAlignment.start,
                          children: [
                            SorterCustomButton(
                                enable: !SortController.instance.checkIfSorting(),
                                buttonColor: Colors.blue,
                                label: "Sort",
                                callback: () {
                                  setState(() {
                                    sort();
                                  });
                                }
                            ),
                            SorterCustomButton(
                                enable: SortController.instance.checkIfSorting(),
                                buttonColor: Colors.redAccent,
                                label: "Stop",
                                callback: () {
                                  stop();
                                }
                            ),
                            SorterCustomButton(
                                enable: !SortController.instance.checkIfSorting(),
                                buttonColor: Colors.orangeAccent,
                                label: "Reset",
                                callback: () {
                                  reset();
                                }
                            ),
                            SorterCustomButton(
                                enable: !SortController.instance.checkIfSorting(),
                                buttonColor: Colors.blue,
                                label: "Auto Generate",
                                callback: () {
                                  generateArray();
                                }
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: visualType == VisualType.ArrayView ?
                  SortArrayView() :
                  SortStackView(),
                )
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: ParameterPanel(
            initialArraySize: SortController.instance.unsortedArray.length,
            updateArraySize: updateArraySize,
          ),
        ),
      ],
    );
  }

  @override
  void refreshUI() {
    setState(() {

    });
  }
//
//  @override
//  void updateSortChoice(SortChoice sortChoice ) {
//    setState(() {
//      print("reset");
//      reset();
//    });z
//  }
}
