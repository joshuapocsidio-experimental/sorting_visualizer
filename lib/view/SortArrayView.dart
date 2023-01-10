import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sorting_visualizer/controller/SortController.dart';
import 'package:sorting_visualizer/model/SortObserver.dart';
class SortArrayView extends StatefulWidget {
  @override
  _SortArrayViewState createState() => _SortArrayViewState();
}

class _SortArrayViewState extends State<SortArrayView> implements SortUIObserver, SortViewObserver {
  final ScrollController sortedArrayController = ScrollController();
  final ScrollController unsortedArrayController = ScrollController();
  List<bool> isExpansionOpen = [true, true, SortController.instance.sortChoice == SortChoice.Merge ? true : false];

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
                                        child: Text("${SortController.instance.unsortedArray[index]}"),
                                      ),
                                    ),
                                  );
                                  },
                            childCount: SortController.instance.unsortedArray.length,
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
                                  color: SortController.instance.getGridItemColor(index),
                                ),
                                duration: Duration(milliseconds: 250),
                                child: SizedBox(
                                  width: 10,
                                  height: 10,
                                  child: Center(
                                    child: Text("${SortController.instance.sortedArray[index]}"),
                                  ),
                                ),
                              );
                            },
                            childCount: SortController.instance.sortedArray.length,
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
                Expanded(
                  child: SortController.instance.sortChoice == SortChoice.Merge ? Padding(
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
                                  color: SortController.instance.getGridItemColor(index),
                                ),
                                duration: Duration(milliseconds: index * 50),
                                child: SizedBox(
                                  width: 10,
                                  height: 10,
                                  child: Center(
                                    child: Text("${SortController.instance.outPlaceData[index]}"),
                                  ),
                                ),
                              );
                            },
                            childCount: SortController.instance.outPlaceData.length,
                          ),
                        ),
                      ],
                    ),
                  ) : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text("Only applicable for: Merge Sort"),
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
      ],
    );
  }

  @override
  void refreshUI() {
    setState(() {
    });
  }

  @override
  void refresh() {
    setState(() {
    });
  }


}
