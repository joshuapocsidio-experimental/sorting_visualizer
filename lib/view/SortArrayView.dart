import 'package:flutter/material.dart';
import 'package:sorting_visualizer/controller/SortController.dart';
import 'package:sorting_visualizer/model/SortObserver.dart';

class SortArrayView extends StatefulWidget {
  final List<int> sortedArray;
  final List<int> unsortedArray;
  final List<int> outPlaceArray;
  final bool isSorting;
  final bool isSorted;
  final List<int> sortedIndices;

  SortArrayView({required this.outPlaceArray, required this.sortedIndices, required this.isSorting, required this.isSorted, required this.sortedArray, required this.unsortedArray});

  @override
  _SortArrayViewState createState() => _SortArrayViewState();
}

class _SortArrayViewState extends State<SortArrayView> implements SortObserver, SortUIObserver {
  int current = 0, check = 0;
  int pivotIndex = -1;
  int outPlaceLeftIndex = -1, outPlaceRightIndex = -1;
  final ScrollController sortedArrayController = ScrollController();
  final ScrollController unsortedArrayController = ScrollController();

  Color _getGridElementColour (int gridIndex, int currentIndex, int checkIndex) {
    // Array is already sorted
    if(widget.isSorted) {
      return Colors.green.withOpacity(0.8);
    }
    if(SortController.instance.isSorting) {
      // Selection Sort
      if(SortController.instance.sortChoice == SortChoice.Selection) {
        if(widget.sortedIndices.contains(gridIndex)) {
          return Colors.green.withOpacity(0.7);
        }
      }
      // Insertion Sort
      if(SortController.instance.sortChoice == SortChoice.Insertion) {
        if(gridIndex == currentIndex) {
          return Colors.blue;
        }
        if(gridIndex == checkIndex) {
          return Colors.red;
        }
        if(gridIndex == checkIndex - 1) {
          return Colors.yellow;
        }
      }
      // Quick Sort
      if(SortController.instance.sortChoice == SortChoice.Quick) {
        if(gridIndex == currentIndex) {
          return Colors.red;
        }
        if(gridIndex == pivotIndex) {
          return Colors.purple;
        }
      }
      // Merge Sort
      if(SortController.instance.sortChoice == SortChoice.Merge) {
        if(gridIndex >= outPlaceLeftIndex && gridIndex <= outPlaceRightIndex) {
          return Colors.blue;
        }
      }
      // Bubble Sort
      if(SortController.instance.sortChoice == SortChoice.Bubble) {
        if(gridIndex == currentIndex) {
          return Colors.blue;
        }
        if(gridIndex == checkIndex) {
          return Colors.red;
        }
      }
    }
    return Colors.white;
  }

  @override
  void dispose() {
//    SortController.instance.removeObserver(this); // Removes currently selected sort choice when page is initialised
    SortController.instance.removeUIObserver(this);
    SortController.instance.clearObservers();
    super.dispose();
  }

  @override
  void initState() {
    SortController.instance.addObserver(this); // Adds currently selected sort choice when page is initialised
    SortController.instance.addUIObserver(this);
    super.initState();
  }

  List<bool> isExpansionOpen = [true, true, true];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: ExpansionPanelList(
          expansionCallback: (index, isOpen) {
            setState(() {
              isExpansionOpen[index] = !isOpen;
            });
          },
          children: [
            ExpansionPanel(
              isExpanded: isExpansionOpen[0],
              canTapOnHeader: true,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return Center(child: Text("Original Array", style: TextStyle(fontSize: 25)));
              },
              body: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 50),
                child: GridView.builder(
                  controller: unsortedArrayController,
                  shrinkWrap: true,
                  itemCount: widget.unsortedArray.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    maxCrossAxisExtent: 50,
                  ),
                  itemBuilder: (context, index){
                    return Container(
                      constraints: BoxConstraints(
                        maxHeight: 250,
                        maxWidth: 250,
                        minHeight: 100,
                        minWidth: 100,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blueGrey,
                        ),
                      ),
                      child: SizedBox(
                        width: 10,
                        height: 10,
                        child: Center(
                          child: Text("${widget.unsortedArray[index]}"),
                        ),
                      ),
                    );
                  }
                ),
              ),
            ),
            ExpansionPanel(
              isExpanded: isExpansionOpen[1],
              canTapOnHeader: true,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return Center(child: Text("Output Array", style: TextStyle(fontSize: 25)));
              },
              body: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 50),
                child: GridView.builder(
                    controller: sortedArrayController,
                    shrinkWrap: true,
                    itemCount: widget.sortedArray.length,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      maxCrossAxisExtent: 50,
                    ),
                    itemBuilder: (context, index){
                      return AnimatedContainer(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blueGrey,
                          ),
                          color: _getGridElementColour(index, current, check),
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
            ),
            ExpansionPanel(
              isExpanded: isExpansionOpen[2],
              canTapOnHeader: true,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return Center(child: Text("Out of Place Array", style: TextStyle(fontSize: 25)));
              },
              body: SortController.instance.sortChoice == SortChoice.Merge ? Padding(
                padding : const EdgeInsets.only(left: 20, right: 20, bottom: 50),
                child: GridView.builder(
                    controller: sortedArrayController,
                    shrinkWrap: true,
                    itemCount: widget.sortedArray.length,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      maxCrossAxisExtent: 50,
                    ),
                    itemBuilder: (context, index){
                      return AnimatedContainer(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blueGrey,
                          ),
                          color: _getGridElementColour(index, current, check),
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
              ) : Container(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text("Only applicable for: Merge Sort & Quick Sort"),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateCommon(int i, int j) {
    setState(() {
      current = i;
      check = j;
    });
  }

  @override
  void updateSelectionIndex(int i, int j) {
    _updateCommon(i, j);
  }

  @override
  void updateMergeInPlace(List<int> array) {
    setState(() {
      widget.sortedArray.replaceRange(0, array.length ,array);
    });
  }

  @override
  void updateMergeOutPlace(List<int> array, int leftIndex, int rightIndex) {
    setState(() {
      outPlaceRightIndex = rightIndex;
      outPlaceLeftIndex = leftIndex;
      widget.outPlaceArray.replaceRange(0, array.length, array);
    });
  }

  @override
  void updateSorted(int sortedIndex) {
    setState(() {
      widget.sortedIndices.add(sortedIndex);
    });
  }

  @override
  void updateBubbleIndex(int i, int j) {
    _updateCommon(i, j);
  }

  @override
  void updateInsertionIndex(int i, int j) {
    _updateCommon(i, j);
  }

  @override
  void updateQuickIndex(int left, int right, int pivot) {
    setState(() {
      current = left;
      check = right;
      pivotIndex = pivot;
    });
  }

  @override
  void updateIsSorting(bool isSorting) {
    // TODO: implement updateIsSorting
  }

  @override
  void updateSortChoice(SortChoice sortChoice) {
    setState(() {
      SortController.instance.addObserver(this);
    });
  }


}
