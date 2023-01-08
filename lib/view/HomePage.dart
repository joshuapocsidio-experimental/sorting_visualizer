import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sorting_visualizer/controller/SortController.dart';
import 'package:sorting_visualizer/model/SortClass.dart';
import 'package:sorting_visualizer/model/SortObserver.dart';
import 'package:sorting_visualizer/view/SortPage.dart';
import 'package:sorting_visualizer/widgets/DrawerButton.dart';
import 'package:sorting_visualizer/widgets/DrawerButtonListView.dart';
import 'package:progress_indicators/progress_indicators.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin implements SortUIObserver  {
  late Animation<double> animation;
  late AnimationController animationController;
  late Color animatedIconColor;
  int selectedSortIndex = 0;

  @override
  void dispose() {
    SortController.instance.removeUIObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    SortController.instance.addUIObserver(this);
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(animationController);
    animatedIconColor = Colors.redAccent;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey.withOpacity(0.3),
        child: Row(
          children: [
            Card(
              elevation: 10,
              child: IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: Container(
                          child: SortController.instance.isSorting ? GlowingProgressIndicator(
                            duration: Duration(milliseconds: 750),
                            child: Icon(
                              Icons.graphic_eq_sharp,
                              color: Colors.blue,
                              size: 250,
                            ),
                          ) : Icon(
                            Icons.graphic_eq_sharp,
                            size: 250,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Sorting Visualiser",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Divider(
                      indent: 5,
                      endIndent: 5,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    DrawerButtonListView(
                      enable: !SortController.instance.isSorting,
                      startingIndex: 0,
                      onTapFunctions: [
                        () {
                          SortController.instance.changeSortChoice(SortChoice.Insertion);
                        },
                        () {
                          SortController.instance.changeSortChoice(SortChoice.Selection);
                        },
                        () {
                          SortController.instance.changeSortChoice(SortChoice.Merge);
                        },
                        () {
                          SortController.instance.changeSortChoice(SortChoice.Quick);
                        },
                        () {
                          SortController.instance.changeSortChoice(SortChoice.Bubble);
                        },
                      ],
                      titles: [
                        "Insertion Sort",
                        "Selection Sort",
                        "Merge Sort",
                        "Quick Sort",
                        "Bubble Sort",
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                flex: 4,
                child: SortPage(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void updateIsSorting(isSorting) {
    setState(() {
      if(isSorting) {
        animationController.forward();
        animatedIconColor = Colors.greenAccent;
      }
      else {
        animationController.reverse();
        animatedIconColor = Colors.redAccent;
      }
    });
  }

  @override
  void updateSortChoice(SortChoice sortChoice) {
    setState(() {

    });
  }
}
