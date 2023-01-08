import 'dart:async';
import 'dart:math';

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
  List<int> sortedIndices = [];
  late VisualType visualType;
  final Stopwatch sw = Stopwatch();
  late Timer t;
  List<int> sorted = [];
  bool isSorting = false;
  bool isSorted = false;
  Map<SortChoice, String?> sortMap = {
    SortChoice.Insertion: "Insertion Sort",
    SortChoice.Selection: "Selection Sort",
    SortChoice.Merge: "Merge Sort",
    SortChoice.Bubble: "Bubble Sort",
    SortChoice.Quick: "Quick Sort",
  };

  List<int> _unsortedArray = [];
  List<int> _sortedArray = [];
  List<int> outPlaceData = [];
  late Duration _elapsed;

  Future<void> sort() async {
    reset();
    isSorting = true;
    // Initialise Timer for updating GUI and initialise stopwatch for time monitoring
    sw.reset();
    sw.start();
    t = Timer.periodic(Duration(milliseconds: 10), (_) {
      setState(() {
        _elapsed = sw.elapsed;
      });
    });

    // Update Unsorted array with the latest array
    setState(() {
      isSorting = true;
      _sortedArray = _unsortedArray.toList();
    });

    await SortController.instance.sort(_sortedArray);
    // Stop timer
    sw.stop();
    t.cancel();
    isSorted = SortController.instance.checkIfSorted(_sortedArray);
    // Update GUI
    setState(()  {
      isSorting = false;
      print(_elapsed);
    });
  }

  void stop() {
    setState(() {
      t.cancel();
      sw.stop();
      SortController.instance.stop();
      isSorted = SortController.instance.checkIfSorted(_sortedArray);
    });
  }

  void reset() {
    setState(() {
      _sortedArray = _unsortedArray.toList();
      outPlaceData = List.filled(_unsortedArray.length, 0, growable: true);
      t.cancel();
      sw.stop();
      isSorted = false;
      sortedIndices = [];
    });
  }

  void generateArray() {
    setState(() {
      for(int i = 0; i < _unsortedArray.length; i++){
        _unsortedArray[i] = Random().nextInt(_unsortedArray.length);
      }
      sortedIndices = [];
      _sortedArray = _unsortedArray.toList();
      outPlaceData = List.filled(_unsortedArray.length, 0, growable: true);
    });
    reset();
  }

  void updateArraySize(int size){
    if(size < 2) {
      print("Array size requires at least 2 for sorting");
      return;
    }
    if(size > 10000) {
      print("Array size upper limit reached");
    }

    if(size == _unsortedArray.length){
      print("No size change required");
      return;
    }

    int diff = size - _unsortedArray.length;
    setState(() {
      if(size < _unsortedArray.length) {
        _unsortedArray = _unsortedArray.sublist(0, size);
        print("Array size decreased by $diff");
      }

      if(size > _unsortedArray.length) {
        for(int i = 0; i < diff; i++) {
          _unsortedArray.add(0);
        }
        print("Array size increased by $diff");
      }
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
    _unsortedArray = List.filled(20, 0, growable: true);
    _elapsed = Duration();
    t = Timer(_elapsed, (){});
    generateArray();
    _sortedArray = _unsortedArray.toList();
    outPlaceData = List.filled(_unsortedArray.length, 0, growable: true);
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
                                enable: !SortController.instance.isSorting,
                                buttonColor: Colors.blue,
                                label: "Sort",
                                callback: () async {
                                  await sort();
                                }
                            ),
                            SorterCustomButton(
                                enable: SortController.instance.isSorting,
                                buttonColor: Colors.redAccent,
                                label: "Stop",
                                callback: () {
                                  stop();
                                }
                            ),
                            SorterCustomButton(
                                enable: !SortController.instance.isSorting,
                                buttonColor: Colors.orangeAccent,
                                label: "Reset",
                                callback: () {
                                  reset();
                                }
                            ),
                            SorterCustomButton(
                                enable: !SortController.instance.isSorting,
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
                  SortArrayView(
                    outPlaceArray: outPlaceData,
                    isSorted: isSorted,
                    isSorting: isSorting,
                    sortedArray: _sortedArray,
                    unsortedArray: _unsortedArray,
                  ) :
                  SortStackView(
                    isSorted: isSorted,
                    sortedData: _sortedArray,
                    unsortedData: _unsortedArray,
                    outPlaceData: outPlaceData,
                  ),
                )
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: ParameterPanel(
            initialArraySize: _unsortedArray.length,
            updateArraySize: updateArraySize,
          ),
        ),
      ],
    );
  }

  @override
  void updateIsSorting(bool isSorting) {
    // TODO: implement updateIsSorting
  }

  @override
  void updateSortChoice(SortChoice sortChoice ) {
    setState(() {
      print("reset");
      reset();
    });
  }
}
