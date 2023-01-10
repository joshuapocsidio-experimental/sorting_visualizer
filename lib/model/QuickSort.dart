import 'dart:math';

import 'package:sorting_visualizer/model/SortClass.dart';
import 'package:sorting_visualizer/model/SortObserver.dart';

enum PivotSelection {
  StartIndex,
  EndIndex,
  MedianOf3,
  Random
}

class QuickSort extends Sorter {
  late PivotSelection pivotSelection;

  late List<SortViewObserver> obs;
  late int pivotIndex, left, right;

  QuickSort([int speed=0]) : super(speed)  {
    obs = [];
    _init();
    pivotSelection = PivotSelection.EndIndex;
  }

  void _init() {
    pivotIndex = -1;
    left = -1;
    right = -1;
  }

  @override
  Future<List<int>> sort(List<int> inPlaceArray, List<int> outPlaceArray) async {
    super.isSorting = true;
    await _quickRecurse(inPlaceArray, 0, inPlaceArray.length-1);
    _init();
    super.isSorting = false;
    return inPlaceArray;
  }

  Future<void> _quickRecurse(List<int> array, int startIndex, int endIndex) async {
    if(array.isEmpty || !super.isSorting) {
      return;
    }
    if(startIndex >= array.length || endIndex <= 0) {
      return;
    }
    int pivot;
    int leftIndex = -1;
    int rightIndex = -1;
    int swapIndex = -1;
    // Pivot Selection
    switch(pivotSelection) {
      case PivotSelection.StartIndex:
        leftIndex = startIndex + 1;
        rightIndex = endIndex;
        pivotIndex = startIndex;
        break;
      case PivotSelection.EndIndex:
        leftIndex = startIndex;
        rightIndex = endIndex - 1;
        pivotIndex = endIndex;
        break;
      case PivotSelection.MedianOf3:
        int midIndex;
        if(endIndex == startIndex) {
          midIndex = startIndex;
        }
        else{
          midIndex = 1+(endIndex + startIndex)~/2;
        }
        leftIndex = startIndex;
        rightIndex = endIndex - 1;
        pivotIndex = endIndex;
        if(array[endIndex] < array[startIndex]) {
          _swap(array, endIndex, startIndex);
        }
        if(array[midIndex] < array[startIndex]) {
          _swap(array, midIndex, startIndex);
        }
        if(array[endIndex] < array[midIndex]) {
          _swap(array, endIndex, midIndex);
        }
        _swap(array, endIndex, midIndex);
        break;
      case PivotSelection.Random:
        leftIndex = startIndex;
        rightIndex = endIndex - 1;
        pivotIndex = endIndex;
        if(startIndex >= endIndex) {
          break;
        }
        int randomIndex = Random().nextInt(endIndex - startIndex) + startIndex;
        _swap(array, randomIndex, pivotIndex);
        break;
    }
    pivot = array[pivotIndex];

    if(leftIndex > rightIndex) {
      return;
    }
    while(leftIndex <= rightIndex && super.isSorting) {
      while(leftIndex <= rightIndex && array[leftIndex] <= pivot && super.isSorting) {
        leftIndex++;
        left = leftIndex;
        right = rightIndex;
        await notifyObservers(array.length);
      }
      while(leftIndex <= rightIndex && array[rightIndex] >= pivot && super.isSorting) {
        rightIndex--;
        left = leftIndex;
        right = rightIndex;
        await notifyObservers(array.length);
      }
      if(leftIndex < rightIndex) {
        _swap(array, leftIndex, rightIndex);
        leftIndex++;
        rightIndex--;
        left = leftIndex;
        right = rightIndex;
        await notifyObservers(array.length);
      }
    }
    // Swap back
    switch(pivotSelection) {
      case PivotSelection.StartIndex:
        swapIndex = rightIndex;
        break;
      case PivotSelection.EndIndex:
        swapIndex = leftIndex;
        break;
      case PivotSelection.MedianOf3:
        swapIndex = leftIndex;
        break;
      case PivotSelection.Random:
        swapIndex = leftIndex;
        break;
    }
    _swap(array, swapIndex, pivotIndex);
    left = leftIndex;
    right = rightIndex;
    await notifyObservers(array.length);

    int pi;
    switch(pivotSelection) {
      case PivotSelection.StartIndex:
        pi = rightIndex;
        await _quickRecurse(array, pi+1, endIndex);
        await _quickRecurse(array, startIndex, pi-1);
        break;
      case PivotSelection.EndIndex:
        pi = leftIndex;
        await _quickRecurse(array, startIndex, pi-1);
        await _quickRecurse(array, pi+1, endIndex);
        break;
      case PivotSelection.MedianOf3:
        pi = leftIndex;
        await _quickRecurse(array, startIndex, pi-1);
        await _quickRecurse(array, pi+1, endIndex);
        break;
      case PivotSelection.Random:
        pi = leftIndex;
        await _quickRecurse(array, startIndex, pi-1);
        await _quickRecurse(array, pi+1, endIndex);
        break;
    }
  }

  void _swap(List<int> array, int firstIndex, int secondIndex) {
    print("Swap");
    int temp = array[firstIndex];
    array[firstIndex] = array[secondIndex];
    array[secondIndex] = temp;
  }

}