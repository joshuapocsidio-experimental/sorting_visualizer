import 'package:flutter/material.dart';
import 'package:sorting_visualizer/model/DrawerButtonEventObserver.dart';

class DrawerButton extends StatefulWidget{
  final bool isSelected;
  final String title;
  final Function function;
  final bool enable;
  final int index;

  DrawerButton({required this.index, required this.isSelected, required this.enable, required this.title, required this.function});


  final List<DrawerButtonEventObserver> _obs = [];

  void addObserver(DrawerButtonEventObserver ob) {
    _obs.add(ob);
  }

  void removeObserver(DrawerButtonEventObserver ob) {
    _obs.remove(ob);
  }

  void notifyObservers() {
    for(DrawerButtonEventObserver ob in _obs) {
      ob.updateSelected(index);
    }
  }

  @override
  _DrawerButtonState createState() => _DrawerButtonState();
}

class _DrawerButtonState extends State<DrawerButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        hoverColor: Colors.grey.withAlpha(90),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Container(
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.normal,
                color: widget.enable ? Colors.black : Colors.grey,
              ),
            ),
          ),
        ),
        onHover: (isHovering) {
          if(isHovering && widget.enable) {
          }
        },
        onTap: widget.enable == false ? null : () {
          setState(() {
            widget.function();
            widget.notifyObservers();
          });
        }
    );
  }
}
