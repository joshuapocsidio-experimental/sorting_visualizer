import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sorting_visualizer/controller/SortController.dart';
import 'package:sorting_visualizer/model/BubbleSort.dart';
import 'package:sorting_visualizer/model/InsertionSort.dart';
import 'package:sorting_visualizer/model/MergeSort.dart';
import 'package:sorting_visualizer/model/QuickSort.dart';
import 'package:sorting_visualizer/model/SelectionSort.dart';
import 'package:sorting_visualizer/model/SortObserver.dart';

class SortStackView extends StatefulWidget {
  final List<int> unsortedData;
  final List<int> sortedData;
  final List<int> outPlaceData;

  SortStackView({required this.outPlaceData, required this.unsortedData, required this.sortedData});
  @override
  _SortStackViewState createState() => _SortStackViewState();
}

class _SortStackViewState extends State<SortStackView> implements SortViewObserver, SortUIObserver{
  List<bool> isExpansionOpen = [true, true, SortController.instance.sortChoice == SortChoice.Merge ? true : false];

  Color _getGridElementColour (int gridIndex) {
    SortController controller = SortController.instance;
    // Array is already sorted
    if(controller.isSorted) {
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

  List<BarChartGroupData> getUnsortedData() {
    List<BarChartGroupData> data = [];
    for(int i = 0; i < widget.unsortedData.length; i++) {
      data.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              y: widget.unsortedData[i].toDouble(),
              colors: [
                Colors.grey,
              ]
            )
          ]
        ),
      );
    }
    return data;
  }
  List<FlSpot> getUnsortedLineData() {
    List<FlSpot> data = [];
    for(int i = 0; i < widget.unsortedData.length; i++) {
      data.add(FlSpot(i.toDouble(), widget.unsortedData[i].toDouble()));
    }
    return data;
  }

  List<FlSpot> getOutPlaceLineData() {
    List<FlSpot> data = [];
    for(int i = 0; i < widget.outPlaceData.length; i++) {
      data.add(FlSpot(i.toDouble(), widget.outPlaceData[i].toDouble()));
    }
    return data;
  }

  List<Color> getColors() {
    List<Color> colors = [];
    for(int i = 0; i < widget.sortedData.length; i++) {
      colors.add(_getGridElementColour(i));
    }
    return colors;
  }

  List<FlSpot> getSortedLineData() {
    List<FlSpot> data = [];
    for(int i = 0; i < widget.sortedData.length; i++) {
      data.add(FlSpot(i.toDouble(), widget.sortedData[i].toDouble()));
    }
    return data;
  }

  List<BarChartGroupData> getSortedData() {
    List<BarChartGroupData> data = [];
    for(int i = 0; i < widget.sortedData.length; i++) {
      data.add(
        BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                y: widget.sortedData[i].toDouble(),
                colors: [
                  _getGridElementColour(i),
                ],
              )
            ]
        ),
      );
    }
    return data;
  }
  @override
  void deactivate() {
    SortController.instance.removeUIObserver(this); // Removes currently selected sort choice when page is initialised
    SortController.instance.clearObservers();
    super.deactivate();
  }

  @override
  void initState() {
    SortController.instance.addObserver(this);
    SortController.instance.addUIObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
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
                  return Center(child: Text("Original Data", style: TextStyle(fontSize: 24)));
                },
                body: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 50),
                  child: SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        axisTitleData: FlAxisTitleData(
                          show: false,
                        ),
                        titlesData: FlTitlesData(
                          show: false,
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            dotData: FlDotData(
                              show: false
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              colors: [Colors.white],
                            ),
                            colors: [Colors.blueGrey],
                            spots: getUnsortedLineData()
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              ExpansionPanel(
                isExpanded: isExpansionOpen[1],
                canTapOnHeader: true,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return Center(child: Text("Output Data", style: TextStyle(fontSize: 24)));
                },
                body: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 50),
                  child: SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        axisTitleData: FlAxisTitleData(
                          show: false,
                        ),
                        titlesData: FlTitlesData(
                          show: false,
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            preventCurveOverShooting: false,
                            dotData: FlDotData(
                                show: false
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              colors: getColors(),
                            ),
                            colors: [Colors.blueGrey],
                            spots: getSortedLineData()
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              ExpansionPanel(
                isExpanded: isExpansionOpen[2],
                canTapOnHeader: true,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return Center(child: Text("Out of Place Array Data", style: TextStyle(fontSize: 24)));
                },
                body: SortController.instance.sortChoice == SortChoice.Merge ? Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 50),
                  child: SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        axisTitleData: FlAxisTitleData(
                          show: false,
                        ),
                        titlesData: FlTitlesData(
                          show: false,
                        ),
                        lineBarsData: [
                          LineChartBarData(
                              dotData: FlDotData(
                                  show: false
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                colors: getColors(),
                              ),
                              colors: [Colors.blueGrey],
                              spots: getOutPlaceLineData()
                          ),
                        ],
                      ),
                    ),
                  ),
                ) : Container(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text("Only applicable for: Merge Sort"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void refresh() {
    setState(() {
    });
  }

  @override
  void updateInPlace(List<int> array) {
    setState(() {
      widget.sortedData.replaceRange(0, array.length ,array);
    });
  }

  @override
  void updateOutPlace(List<int> array) {
    setState(() {
      widget.outPlaceData.replaceRange(0, array.length, array);
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
