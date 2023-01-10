import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sorting_visualizer/model/BubbleSort.dart';
import 'package:sorting_visualizer/model/InsertionSort.dart';
import 'package:sorting_visualizer/model/MergeSort.dart';
import 'package:sorting_visualizer/model/QuickSort.dart';
import 'package:sorting_visualizer/model/SelectionSort.dart';
import 'package:sorting_visualizer/model/SortClass.dart';
import 'package:sorting_visualizer/model/SortObserver.dart';

enum SortChoice {
  Insertion,
  Selection,
  Bubble,
  Merge,
  Quick,
}

const Map<SortSpeed, int> _speedMap = {
  SortSpeed.VerySlow: 1000,
  SortSpeed.Slow: 500,
  SortSpeed.Normal: 250,
  SortSpeed.Fast: 50,
  SortSpeed.VeryFast: 5,
  SortSpeed.Instant: 0,
};

class SortController{
  late Sorter _sorter;
  late List<SortUIObserver> _suObs;

  late SortChoice sortChoice;
  bool isSorted = false;
  late SortSpeed speed;

  late List<int> unsortedArray;
  late List<int> sortedArray;
  late List<int> outPlaceData;
  late List<int> sortedIndices;

  SortController._privateConstructor(){
    _suObs = [];
    speed = SortSpeed.Normal;
    sortChoice = SortChoice.Insertion;
    _sorter = InsertionSort();
    _sorter.speed = _speedMap[speed]!;
    unsortedArray = [];
    sortedArray = [];
    outPlaceData = [];
    sortedIndices = [];
    updateArraySize(50);
    generate();
  }

  static final SortController _instance = SortController._privateConstructor();
  static SortController get instance => _instance;

  void stop() {
    _sorter.isSorting = false;
    notifyUIObservers();
  }

  void reset() {
    sortedArray = unsortedArray.toList();
    outPlaceData = List.filled(unsortedArray.length, 0, growable: true);
    _checkIfSorted(sortedArray);
    sortedIndices = [];
  }

  void generate() {
    for(int i = 0; i < unsortedArray.length; i++){
      unsortedArray[i] = Random().nextInt(unsortedArray.length);
    }
    sortedIndices = [];
    sortedArray = unsortedArray.toList();
    outPlaceData = List.filled(unsortedArray.length, 0, growable: true);
  }

  void updateArraySize(int size){
    if(size < 2) {
      print("Array size requires at least 2 for sorting");
      return;
    }
    if(size > 10000) {
      print("Array size upper limit reached");
    }

    if(size == unsortedArray.length){
      print("No size change required");
      return;
    }

    int diff = size - unsortedArray.length;
    if(size < unsortedArray.length) {
      unsortedArray = unsortedArray.sublist(0, size);
      print("Array size decreased by $diff");
    }

    if(size > unsortedArray.length) {
      for(int i = 0; i < diff; i++) {
        unsortedArray.add(0);
      }
      print("Array size increased by $diff");
    }
  }

  Sorter getSorter() {
    return _sorter;
  }

  void changeSpeed(SortSpeed newSpeed) {
    speed = newSpeed;
    _sorter.speed = _speedMap[speed]!;
  }

  int getSpeedInMs() {
    return _sorter.speed;
  }

  Future<void> sort() async {
    notifyUIObservers();
    await _sorter.sort(sortedArray, outPlaceData);
    notifyUIObservers();
  }

  void clearObservers() {
    _sorter.clearObservers();
  }

  void changeSortChoice(SortChoice choice) {
    this.sortChoice = choice;
    switch(choice) {
      case SortChoice.Insertion:
        _sorter = InsertionSort();
        break;
      case SortChoice.Selection:
        _sorter = SelectionSort();
        break;
      case SortChoice.Bubble:
        _sorter = BubbleSort();
        break;
      case SortChoice.Merge:
        _sorter = MergeSort();
        break;
      case SortChoice.Quick:
        _sorter = QuickSort();
        break;
    }
    changeSpeed(speed);
    reset();
    notifyUIObservers();
  }

  void addUIObserver(SortUIObserver ob) {
    this._suObs.add(ob);
  }

  void removeUIObserver(SortUIObserver ob) {
    this._suObs.remove(ob);
  }

  void notifyUIObservers() {
    for(SortUIObserver ob in _suObs) {
      ob.refreshUI();
    }
  }

  void addObserver(SortViewObserver ob) {
    _sorter.addObserver(ob);
  }

  void removeObserver(SortViewObserver ob) {
    _sorter.removeObserver(ob);
  }

  bool _checkIfSorted(List<int> array) {
    for(int i = 1; i < array.length; i++){
      if(array[i] < array[i-1]) {
        return false;
      }
    }
    return true;
  }


  bool checkIfSorting() {
    return _sorter.isSorting;
  }

  Color getGridItemColor (int gridIndex) {
    // Array is already sorted
    if(_checkIfSorted(sortedArray)) {
      return Colors.green.withOpacity(0.8);
    }
    if(checkIfSorting()) {
      // Selection Sort
      if(sortChoice == SortChoice.Selection) {
        SelectionSort sorter = _sorter as SelectionSort;
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
      if(sortChoice == SortChoice.Insertion) {
        InsertionSort sorter = _sorter as InsertionSort;
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
      if(sortChoice == SortChoice.Quick) {
        QuickSort sorter = _sorter as QuickSort;
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
      if(sortChoice == SortChoice.Merge) {
        MergeSort sorter = _sorter as MergeSort;
        if(gridIndex >= sorter.leftIndex && gridIndex <= sorter.rightIndex) {
          return Colors.blue;
        }
      }
      // Bubble Sort
      if(sortChoice == SortChoice.Bubble) {
        BubbleSort sorter = _sorter as BubbleSort;
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
}
