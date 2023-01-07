import 'dart:async';
import 'dart:math';
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

class SortController {
  final List<SortParentClass> _sorters = [];
  late List<SortUIObserver> _suObs;

  late MergeSort mergeSorter;
  late QuickSort quickSorter;
  late InsertionSort insertionSorter;
  late SelectionSort selectionSorter;
  late BubbleSort bubbleSorter;
  
  late SortChoice sortChoice;
  bool isSorting = false;
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
  }

  static final SortController _instance = SortController._privateConstructor();
  static SortController get instance => _instance;

  void stop() {
    this.isSorting = false;
    notifyUIObservers();
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
    notifyUIObservers();
    if(sortChoice == SortChoice.Bubble) {
      sortedArray = await bubbleSorter.sort(unsortedArray);
    }
    if(sortChoice == SortChoice.Insertion) {
      sortedArray = await insertionSorter.sort(unsortedArray);
    }
    if(sortChoice == SortChoice.Selection) {
      sortedArray = await selectionSorter.sort(unsortedArray);
    }
    if(sortChoice == SortChoice.Quick) {
      sortedArray = await quickSorter.sort(unsortedArray);
    }
    if(sortChoice == SortChoice.Merge) {
      sortedArray = await mergeSorter.sort(unsortedArray);
    }
    // TODO: Option to do all sorters in one go for time comparison
    isSorting = false;
    notifyUIObservers();
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
      ob.updateIsSorting(this.isSorting);
      ob.updateSortChoice(this.sortChoice);
    }
  }

  // Add Observer
  void addObserver(SortObserver ob) {
    switch(sortChoice) {
      case SortChoice.Insertion:
        addInsertionObserver(ob);
        break;
      case SortChoice.Selection:
        addSelectionObserver(ob);
        break;
      case SortChoice.Bubble:
        addBubbleObserver(ob);
        break;
      case SortChoice.Merge:
        addMergeObserver(ob);
        break;
      case SortChoice.Quick:
        addQuickObserver(ob);
        break;
      case SortChoice.All:
        // TODO: Handle this case.
        break;
    }
  }
  void addMergeObserver(MergeSortObserver ob) {
    mergeSorter.addObserver(ob);
  }
  void addQuickObserver(QuickSortObserver ob) {
    quickSorter.addObserver(ob);
  }
  void addBubbleObserver(BubbleSortObserver ob) {
    bubbleSorter.addObserver(ob);
  }
  void addSelectionObserver(SelectionSortObserver ob) {
    selectionSorter.addObserver(ob);
  }
  void addInsertionObserver(InsertionSortObserver ob) {
    insertionSorter.addObserver(ob);
  }
  // Remove Observer
  void removeObserver(SortObserver ob) {
    switch(sortChoice) {
      case SortChoice.Insertion:
        removeInsertionObserver(ob);
        break;
      case SortChoice.Selection:
        removeSelectionObserver(ob);
        break;
      case SortChoice.Bubble:
        removeBubbleObserver(ob);
        break;
      case SortChoice.Merge:
        removeMergeObserver(ob);
        break;
      case SortChoice.Quick:
        removeQuickObserver(ob);
        break;
      case SortChoice.All:
      // TODO: Handle this case.
        break;
    }
  }
  void removeMergeObserver(MergeSortObserver ob) {
    mergeSorter.removeObserver(ob);
  }
  void removeQuickObserver(QuickSortObserver ob) {
    quickSorter.removeObserver(ob);
  }
  void removeBubbleObserver(BubbleSortObserver ob) {
    bubbleSorter.removeObserver(ob);
  }
  void removeSelectionObserver(SelectionSortObserver ob) {
    selectionSorter.removeObserver(ob);
  }
  void removeInsertionObserver(InsertionSortObserver ob) {
    insertionSorter.removeObserver(ob);
  }

  bool isSorted(List<int> array) {
    for(int i = 1; i < array.length; i++){
      if(array[i] < array[i-1]) {
        return false;
      }
    }
    return true;
  }
}
