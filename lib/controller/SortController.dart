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
import 'package:sorting_visualizer/widgets/OptimisedAnimatedContainer.dart';

enum SortChoice {
  Insertion,
  Selection,
  Bubble,
  Merge,
  Quick,
  All,
}

const Map<SortSpeed, int> _speedMap = {
  SortSpeed.VerySlow: 1000,
  SortSpeed.Slow: 500,
  SortSpeed.Normal: 250,
  SortSpeed.Fast: 100,
  SortSpeed.VeryFast: 10,
  SortSpeed.Instant: 0,
};

class SortController{
  final List<SortParentClass> _sorters = [];
  final Map<SortChoice, SortParentClass> _sorterMap = {};
  late List<SortUIObserver> _suObs;

  late MergeSort mergeSorter;
  late QuickSort quickSorter;
  late InsertionSort insertionSorter;
  late SelectionSort selectionSorter;
  late BubbleSort bubbleSorter;
  
  late SortChoice sortChoice;
  bool isSorting = false;
  bool isSorted = false;
  late SortSpeed speed;

  SortController._privateConstructor(){
    _suObs = [];
    speed = SortSpeed.Normal;
    sortChoice = SortChoice.Insertion;
    mergeSorter = MergeSort(_speedMap[speed]!);
    quickSorter = QuickSort(_speedMap[speed]!);
    insertionSorter = InsertionSort(_speedMap[speed]!);
    selectionSorter = SelectionSort(_speedMap[speed]!);
    bubbleSorter = BubbleSort(_speedMap[speed]!);
    _sorters.addAll([mergeSorter, quickSorter, insertionSorter, selectionSorter, bubbleSorter]);
    _sorterMap[SortChoice.Insertion] = insertionSorter;
    _sorterMap[SortChoice.Selection] = selectionSorter;
    _sorterMap[SortChoice.Bubble] = bubbleSorter;
    _sorterMap[SortChoice.Quick] = quickSorter;
    _sorterMap[SortChoice.Merge] = mergeSorter;

  }

  static final SortController _instance = SortController._privateConstructor();
  static SortController get instance => _instance;

  void stop() {
    this.isSorting = false;
    notifyUIObserversIsSorting();
  }

  void changeSpeed(SortSpeed newSpeed) {
    speed = newSpeed;
    for(SortParentClass sorter in _sorters) {
      sorter.speed = getSpeedInMs();
    }
  }

  int getSpeedInMs() {
    return _speedMap[speed]!;
  }

  Future<List<int>> sort(List<int> unsortedArray) async {
    List<int> sortedArray = [];
    isSorting = true;
    isSorted = false;
    notifyUIObserversIsSorting();
    sortedArray = await _sorterMap[sortChoice]!.sort(unsortedArray);
    // TODO: Option to do all sorters in one go for time comparison
    isSorting = false;
    isSorted = this.checkIfSorted(sortedArray);
    notifyUIObserversIsSorting();
    return sortedArray;
  }

  void clearObservers() {
    insertionSorter.clearObservers();
    quickSorter.clearObservers();
    mergeSorter.clearObservers();
    bubbleSorter.clearObservers();
    selectionSorter.clearObservers();
  }

  void changeSortChoice(SortChoice choice) {
    this.sortChoice = choice;
    // Remove other type of observers when changing sorter
    if(choice != SortChoice.Insertion) {
      insertionSorter.clearObservers();
    }
    if(choice != SortChoice.Quick) {
      quickSorter.clearObservers();
    }
    if(choice != SortChoice.Merge) {
      mergeSorter.clearObservers();
    }
    if(choice != SortChoice.Bubble) {
      bubbleSorter.clearObservers();
    }
    if(choice != SortChoice.Selection) {
      selectionSorter.clearObservers();
    }
    notifyUIObserversSortChoice();
  }

  void addUIObserver(SortUIObserver ob) {
    this._suObs.add(ob);
  }

  void removeUIObserver(SortUIObserver ob) {
    this._suObs.remove(ob);
  }

  void notifyUIObserversIsSorting() {
    for(SortUIObserver ob in _suObs) {
      ob.updateIsSorting(this.isSorting);
    }
  }

  void notifyUIObserversSortChoice() {
    for(SortUIObserver ob in _suObs) {
      ob.updateSortChoice(this.sortChoice);
    }
  }

  // Add Observer
  void addObserver(SortViewObserver ob) {
    switch(sortChoice) {
      case SortChoice.Insertion:
        insertionSorter.addObserver(ob);
        break;
      case SortChoice.Selection:
        selectionSorter.addObserver(ob);
        break;
      case SortChoice.Bubble:
        bubbleSorter.addObserver(ob);
        break;
      case SortChoice.Merge:
        mergeSorter.addObserver(ob);
        break;
      case SortChoice.Quick:
        quickSorter.addObserver(ob);
        break;
      case SortChoice.All:
        // TODO: Handle this case.
        break;
    }
  }
  // Remove Observer
  void removeObserver(SortViewObserver ob) {
    switch(sortChoice) {
      case SortChoice.Insertion:
        insertionSorter.removeObserver(ob);
        break;
      case SortChoice.Selection:
        selectionSorter.removeObserver(ob);
        break;
      case SortChoice.Bubble:
        bubbleSorter.removeObserver(ob);
        break;
      case SortChoice.Merge:
        mergeSorter.removeObserver(ob);
        break;
      case SortChoice.Quick:
        quickSorter.removeObserver(ob);
        break;
      case SortChoice.All:
      // TODO: Handle this case.
        break;
    }
  }

  bool checkIfSorted(List<int> array) {
    for(int i = 1; i < array.length; i++){
      if(array[i] < array[i-1]) {
        isSorted = false;
        return isSorted;
      }
    }
    isSorted = true;
    return isSorted;
  }

  Color getGridItemColor (int gridIndex) {
    SortController controller = SortController.instance;
    // Array is already sorted
    if(isSorted) {
      return Colors.green.withOpacity(0.8);
    }
    if(isSorting) {
      // Selection Sort
      if(sortChoice == SortChoice.Selection) {
        SelectionSort sorter = controller.selectionSorter;
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
        InsertionSort sorter = controller.insertionSorter;
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
        QuickSort sorter = controller.quickSorter;
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
        MergeSort sorter = controller.mergeSorter;
        if(gridIndex >= sorter.leftIndex && gridIndex <= sorter.rightIndex) {
          return Colors.blue;
        }
      }
      // Bubble Sort
      if(sortChoice == SortChoice.Bubble) {
        BubbleSort sorter = controller.bubbleSorter;
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
