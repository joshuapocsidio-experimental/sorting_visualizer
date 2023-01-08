import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sorting_visualizer/controller/SortController.dart';
import 'package:sorting_visualizer/model/BubbleSort.dart';
import 'package:sorting_visualizer/model/InsertionSort.dart';
import 'package:sorting_visualizer/model/MergeSort.dart';
import 'package:sorting_visualizer/model/QuickSort.dart';
import 'package:sorting_visualizer/model/SelectionSort.dart';
import 'package:sorting_visualizer/model/SortObserver.dart';
class SortArrayView extends StatefulWidget {
  final List<int> sortedArray;
  final List<int> unsortedArray;
  final List<int> outPlaceArray;
  final bool isSorting;
  final bool isSorted;

  SortArrayView({required this.outPlaceArray, required this.isSorting, required this.isSorted, required this.sortedArray, required this.unsortedArray});

  @override
  _SortArrayViewState createState() => _SortArrayViewState();
}

class _SortArrayViewState extends State<SortArrayView> implements SortUIObserver, SortViewObserver {
  final ScrollController sortedArrayController = ScrollController();
  final ScrollController unsortedArrayController = ScrollController();
  List<bool> isExpansionOpen = [true, true, SortController.instance.sortChoice == SortChoice.Merge ? true : false];

  Color _getGridElementColour (int gridIndex) {
    SortController controller = SortController.instance;
    // Array is already sorted
    if(widget.isSorted) {
      return Colors.green.withOpacity(0.8);
    }
    if(SortController.instance.isSorting) {
      // Selection Sort
      if(SortController.instance.sortChoice == SortChoice.Selection) {
        SelectionSort sorter = controller.selectionSorter;
        if(sorter.sortedIndices.contains(gridIndex)) {
          return Colors.green.withOpacity(0.7);
        }
        if(gridIndex == sorter.iterationIndex) {
          return Colors.purple;
        }
        if(gridIndex == sorter.comparisonIndex) {
          return Colors.red;
        }
      }
      // Insertion Sort
      if(SortController.instance.sortChoice == SortChoice.Insertion) {
        InsertionSort sorter = controller.insertionSorter;
        if(gridIndex == sorter.iterationIndex) {
          return Colors.purple;
        }
        if(gridIndex == sorter.aIndex) {
          return Colors.blue;
        }
        if(gridIndex == sorter.bIndex) {
          return Colors.red;
        }
      }
      // Quick Sort
      if(SortController.instance.sortChoice == SortChoice.Quick) {
        QuickSort sorter = controller.quickSorter;
        if(gridIndex == sorter.left) {
          return Colors.blue;
        }
        if(gridIndex == sorter.right) {
          return Colors.red;
        }
        if(gridIndex == sorter.pivotIndex) {
          return Colors.purple;
        }
      }
      // Merge Sort
      if(SortController.instance.sortChoice == SortChoice.Merge) {
        MergeSort sorter = controller.mergeSorter;
        if(gridIndex >= sorter.leftIndex && gridIndex <= sorter.rightIndex) {
          return Colors.blue;
        }
      }
      // Bubble Sort
      if(SortController.instance.sortChoice == SortChoice.Bubble) {
        BubbleSort sorter = controller.bubbleSorter;
        if(sorter.sortedIndices.contains(gridIndex)) {
          return Colors.green.withOpacity(0.7);
        }
        if(gridIndex == sorter.aIndex) {
          return Colors.blue;
        }
        if(gridIndex == sorter.bIndex) {
          return Colors.red;
        }
      }
    }
    return Colors.white;
  }

  @override
  void deactivate() {
    SortController.instance.removeUIObserver(this); // Removes currently selected sort choice when page is initialised
    SortController.instance.clearObservers();
    super.deactivate();
  }

  @override
  void initState() {
    SortController.instance.addObserver(this); // Adds currently selected sort choice when page is initialised
    SortController.instance.addUIObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Original Array",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
                Divider(
                  thickness: 2,
                  indent: 50,
                  endIndent: 50,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CustomScrollView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      slivers: [
                        SliverGrid(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            crossAxisCount: 20
                          ),
                          delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.blueGrey,
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: SizedBox(
                                      width: 10,
                                      height: 10,
                                      child: Center(
                                        child: Text("${widget.unsortedArray[index]}"),
                                      ),
                                    ),
                                  );
                                  },
                            childCount: widget.unsortedArray.length,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 2,
                  indent: 50,
                  endIndent: 50,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Output Array",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
                Divider(
                  thickness: 2,
                  indent: 50,
                  endIndent: 50,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CustomScrollView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      slivers: [
                        SliverGrid(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              crossAxisCount: 20
                          ),
                          delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                              return AnimatedContainer(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.blueGrey,
                                  ),
                                  color: _getGridElementColour(index),
                                ),
                                duration: Duration(milliseconds: index * 50),
                                child: SizedBox(
                                  width: 10,
                                  height: 10,
                                  child: Center(
                                    child: Text("${widget.sortedArray[index]}"),
                                  ),
                                ),
                              );
                            },
                            childCount: widget.sortedArray.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 2,
                  indent: 50,
                  endIndent: 50,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Out of Place Array",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
                Divider(
                  thickness: 2,
                  indent: 50,
                  endIndent: 50,
                ),
                SortController.instance.sortChoice == SortChoice.Merge ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SingleChildScrollView(
                    child: GridView.builder(
                        scrollDirection: Axis.vertical,
                        physics: ScrollPhysics(),
                        controller: sortedArrayController,
                        shrinkWrap: true,
                        itemCount: widget.sortedArray.length,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          maxCrossAxisExtent: 20,
                        ),
                        itemBuilder: (context, index){
                          return AnimatedContainer(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blueGrey,
                              ),
                              color: _getGridElementColour(index),
                            ),
                            duration: widget.isSorting == true ? Duration(milliseconds: 200) : Duration(milliseconds: index * 50),
                            child: SizedBox(
                              width: 10,
                              height: 10,
                              child: Center(
                                child: Text("${widget.sortedArray[index]}"),
                              ),
                            ),
                          );
                        }
                    ),
                  ),
                ) : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text("Only applicable for: Merge Sort"),
                ),
                Divider(
                  thickness: 2,
                  indent: 50,
                  endIndent: 50,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void updateInPlace(List<int> array) {
    setState(() {
      widget.sortedArray.replaceRange(0, array.length ,array);
    });
  }

  @override
  void updateOutPlace(List<int> array) {
    setState(() {
      widget.outPlaceArray.replaceRange(0, array.length, array);
    });
  }

  @override
  void updateIsSorting(bool isSorting) {
    // TODO: implement updateIsSorting
  }

  @override
  void updateSortChoice(SortChoice sortChoice) {
    setState(() {
//      SortController.instance.addObserver(this);
    });
  }

  @override
  void refresh() {
    setState(() {
    });
  }


}
