import 'package:flutter/material.dart';
import 'package:sorting_visualizer/controller/SortController.dart';
import 'package:sorting_visualizer/model/DrawerButtonEventObserver.dart';
import 'package:sorting_visualizer/widgets/DrawerButtonDivider.dart';

import 'DrawerButton.dart';

class DrawerButtonListView extends StatefulWidget {
  final bool enable;
  final List<Function> onTapFunctions;
  final List<String> titles;
  final int startingIndex;

  DrawerButtonListView({required this.titles, required this.enable, required this.startingIndex, required this.onTapFunctions});
  @override
  _DrawerButtonListViewState createState() => _DrawerButtonListViewState();
}

class _DrawerButtonListViewState extends State<DrawerButtonListView> implements DrawerButtonEventObserver {
  List<Widget> _list = [];
  List<DrawerButton> _buttons = [];
  late int _selIndex;

  @override
  void initState() {
    _selIndex = widget.startingIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _list = [];
    _buttons = [];
    int size = widget.titles.length;
    for(int i = 0; i < size; i++) {
      bool isSelected = false;
      if(_selIndex == i) {
        isSelected = true;
      }
      _buttons.add(DrawerButton(
        index: i,
        isSelected: isSelected,
        enable: widget.enable,
        title: widget.titles[i],
        function: () {
          setState(() {
            widget.onTapFunctions[i]();
          });
        }
      ));
    }

    for(int i = 0; i < size; i++) {
      _list.add(_buttons[i]);
      _list.add(DrawerButtonDivider());
      _buttons[i].addObserver(this);
    }

    return IntrinsicWidth(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _list,
      ),
    );
  }

  @override
  void updateSelected(int index) {
    setState(() {
      _selIndex = index;
    });
  }
}
