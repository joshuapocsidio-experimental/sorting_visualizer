import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sorting_visualizer/controller/SortController.dart';
import 'package:sorting_visualizer/model/SortClass.dart';
import 'package:sorting_visualizer/model/SortObserver.dart';

class SortStackView extends StatefulWidget {
  final List<int> unsortedData;
  final List<int> sortedData;
  final List<int> outPlaceData;
  final bool isSorting;
  final bool isSorted;
  final List<int> sortedIndices;
  
  SortStackView({required this.outPlaceData, required this.sortedIndices, required this.isSorting, required this.isSorted, required this.unsortedData, required this.sortedData});
  @override
  _SortStackViewState createState() => _SortStackViewState();
}

class _SortStackViewState extends State<SortStackView> implements SortObserver, SortUIObserver{
  int current = 0, check = 0;
  int outPlaceLeftIndex = -1, outPlaceRightIndex = -1;
  int pivotIndex = -1;

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
        if(gridIndex == currentIndex) {
          return Colors.purple;
        }
        if(gridIndex == checkIndex) {
          return Colors.red;
        }
      }
      // Insertion Sort
      if(SortController.instance.sortChoice == SortChoice.Insertion) {
        if(gridIndex == currentIndex) {
          return Colors.purple;
        }
        if(gridIndex == checkIndex) {
          return Colors.blue;
        }
        if(gridIndex == checkIndex - 1) {
          return Colors.red;
        }
      }
      // Quick Sort
      if(SortController.instance.sortChoice == SortChoice.Quick) {
        if(gridIndex == currentIndex) {
          return Colors.blue;
        }
        if(gridIndex == checkIndex) {
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
        if(widget.sortedIndices.contains(gridIndex)) {
          return Colors.green.withOpacity(0.7);
        }
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
      colors.add(_getGridElementColour(i, current, check));
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
                  _getGridElementColour(i, current, check),
                ],
              )
            ]
        ),
      );
    }
    return data;
  }
  @override
  void dispose() {
//    SortController.instance.removeObserver(this);
    SortController.instance.removeUIObserver(this);
    SortController.instance.clearObservers();
    super.dispose();
  }

  @override
  void initState() {
    SortController.instance.addObserver(this);
    SortController.instance.addUIObserver(this);
    super.initState();
  }
  List<bool> isExpansionOpen = [true, true, true];

  @override
  Widget build(BuildContext context) {
    if(widget.isSorted) {
      outPlaceLeftIndex = -1;
      outPlaceRightIndex = -1;
    }
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
                return Center(child: Text("Original Data", style: TextStyle(fontSize: 25)));
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
                return Center(child: Text("Output Data", style: TextStyle(fontSize: 25)));
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
                return Center(child: Text("Out of Place Array Data", style: TextStyle(fontSize: 25)));
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
      widget.sortedData.replaceRange(0, array.length ,array);
    });
  }

  @override
  void updateMergeOutPlace(List<int> array, int leftIndex, int rightIndex) {
    setState(() {
      outPlaceRightIndex = rightIndex;
      outPlaceLeftIndex = leftIndex;
      widget.outPlaceData.replaceRange(0, array.length, array);
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
