//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:sorting_visualizer/controller/SortController.dart';
//import 'package:sorting_visualizer/model/SortObserver.dart';
//
//class OptimisedAnimatedContainer extends StatefulWidget {
//  final int index;
//  final int value;
//  const OptimisedAnimatedContainer({required this.index});
//  @override
//  _OptimisedAnimatedContainerState createState() => _OptimisedAnimatedContainerState();
//}
//
//class _OptimisedAnimatedContainerState extends State<OptimisedAnimatedContainer> implements SortStateObserver {
//  late Color color;
//  late int content;
//
//  @override
//  void initState() {
//    SortController.instance.addObjectObserver(this);
//    color = Colors.white;
//    content = 0;
//    super.initState();
//  }
//
//  @override
//  void deactivate() {
//    SortController.instance.removeObjectObserver(this);
//    super.deactivate();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return AnimatedContainer(
//      decoration: BoxDecoration(
//        border: Border.all(
//          color: Colors.blueGrey,
//        ),
//        color: color,
//      ),
//      duration: Duration(milliseconds: widget.index * 50),
//      child: SizedBox(
//        width: 10,
//        height: 10,
//        child: Center(
//          child: Text("$content"),
//        ),
//      ),
//    );
//  }
//
//  @override
//  void refresh(int value) {
//    setState(() {
//      content = value;
//      color = SortController.instance.getGridItemColor(widget.index);
//    });
//  }
//}
