import 'dart:async';
import 'package:flutter/foundation.dart';
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


abstract class SortParentClass {
  String name = "base";
  bool isSorting = false;
  late int speed;

  Future<List<int>> sort(List<int> unsortedArray);

  void stop() {
    this.isSorting = false;
  }

  SortParentClass(int initSpeed) {
    speed = initSpeed;
  }

  Future<bool> isSorted(List<int> array) async {
    for(int i = 1; i < array.length; i++){
      if(array[i] < array[i-1]) {
        return false;
      }
    }
    return true;
  }

}

