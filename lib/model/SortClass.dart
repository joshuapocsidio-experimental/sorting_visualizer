import 'dart:async';
import 'package:sorting_visualizer/model/SortObserver.dart';

enum SortType {
  SelectionSort,
  InsertionSort,
  MergeSort,
  BubbleSort,
  QuickSort
}
enum SortSpeed {
  VerySlow,
  Slow,
  Normal,
  Fast,
  VeryFast,
  Instant,
}

abstract class SortAlgorithm {
  Future<List<int>> sort(List<int> inPlaceArray, List<int> outPlaceArray);
}

abstract class Sorter implements SortAlgorithm{
  late List<SortViewObserver> obs;
  bool isSorting = false;
  late int speed;

  void stop() {
    this.isSorting = false;
  }

  void addObserver(SortViewObserver ob) {
    this.obs.add(ob);
  }
  void removeObserver(SortViewObserver ob) {
    this.obs.remove(ob);
  }
  void clearObservers() {
    obs = [];
  }
  Future<void> notifyObservers(int dataSize) async {
    for(SortViewObserver ob in obs){
      ob.refresh();
    }
    await Future.delayed(Duration(milliseconds: speed));
  }
  Sorter(int initSpeed) {
    speed = initSpeed;
    obs = [];
  }


}

