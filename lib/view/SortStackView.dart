import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sorting_visualizer/controller/SortController.dart';
import 'package:sorting_visualizer/model/SortObserver.dart';

class SortStackView extends StatefulWidget {
  @override
  _SortStackViewState createState() => _SortStackViewState();
}

class _SortStackViewState extends State<SortStackView> implements SortViewObserver, SortUIObserver{
  List<bool> isExpansionOpen = [true, true, SortController.instance.sortChoice == SortChoice.Merge ? true : false];

  List<BarChartGroupData> getUnsortedData() {
    List<BarChartGroupData> data = [];
    for(int i = 0; i < SortController.instance.unsortedArray.length; i++) {
      data.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              y: SortController.instance.unsortedArray[i].toDouble(),
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
    for(int i = 0; i < SortController.instance.unsortedArray.length; i++) {
      data.add(FlSpot(i.toDouble(), SortController.instance.unsortedArray[i].toDouble()));
    }
    return data;
  }

  List<FlSpot> getOutPlaceLineData() {
    List<FlSpot> data = [];
    for(int i = 0; i < SortController.instance.outPlaceData.length; i++) {
      data.add(FlSpot(i.toDouble(), SortController.instance.outPlaceData[i].toDouble()));
    }
    return data;
  }

  List<Color> getColors() {
    List<Color> colors = [];
    for(int i = 0; i < SortController.instance.sortedArray.length; i++) {
      colors.add(SortController.instance.getGridItemColor(i));
    }
    return colors;
  }

  List<FlSpot> getSortedLineData() {
    List<FlSpot> data = [];
    for(int i = 0; i < SortController.instance.sortedArray.length; i++) {
      data.add(FlSpot(i.toDouble(), SortController.instance.sortedArray[i].toDouble()));
    }
    return data;
  }

  List<BarChartGroupData> getSortedData() {
    List<BarChartGroupData> data = [];
    for(int i = 0; i < SortController.instance.sortedArray.length; i++) {
      data.add(
        BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                y: SortController.instance.sortedArray[i].toDouble(),
                colors: [
                  SortController.instance.getGridItemColor(i),
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
  void refreshUI() {
    setState(() {

    });
  }
//
//  @override
//  void updateSortChoice(SortChoice sortChoice) {
//    setState(() {
//      SortController.instance.addObserver(this);
//    });
//  }
}
