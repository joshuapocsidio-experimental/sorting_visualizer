import 'dart:math';

import 'package:sorting_visualizer/controller/SortController.dart';
import 'package:sorting_visualizer/model/SortClass.dart';
import 'package:sorting_visualizer/model/SortObserver.dart';

enum PivotSelection {
  StartIndex,
  EndIndex,
  MedianOf3,
  Random
}

class QuickSort extends SortParentClass {
  late PivotSelection pivotSelection;

  late List<SortViewObserver> _obs;
  late int pivotIndex, left, right;

  QuickSort(int speed) : super(speed)  {
    _obs = [];
    _init();
    pivotSelection = PivotSelection.EndIndex;
  }

  void addObserver(SortViewObserver ob) {
    this._obs.add(ob);
  }
  void removeObserver(SortViewObserver ob) {
    this._obs.remove(ob);
  }
  void clearObservers() {
    _obs = [];
  }
  void notifyObservers(int left, int right, int pivot) {
    for(SortViewObserver ob in _obs){
      ob.refresh();
    }
  }

  void _init() {
    pivotIndex = -1;
    left = -1;
    right = -1;
  }

  @override
  Future<List<int>> sort(List<int> unsortedArray) async {
    await _quickRecurse(unsortedArray, 0, unsortedArray.length-1);
    _init();
    return unsortedArray;
  }

  Future<void> _quickRecurse(List<int> array, int startIndex, int endIndex) async {
    if(array.isEmpty || !SortController.instance.isSorting) {
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
    while(leftIndex <= rightIndex) {
      while(leftIndex <= rightIndex && array[leftIndex] <= pivot) {
        leftIndex++;
        await Future.delayed(Duration(milliseconds: super.speed), () {
          left = leftIndex;
          right = rightIndex;
          notifyObservers(leftIndex, rightIndex, pivotIndex);
        });
      }
      while(leftIndex <= rightIndex && array[rightIndex] >= pivot) {
        rightIndex--;
        await Future.delayed(Duration(milliseconds: super.speed), () {
          left = leftIndex;
          right = rightIndex;
          notifyObservers(leftIndex, rightIndex, pivotIndex);
        });
      }
      if(leftIndex < rightIndex) {
        _swap(array, leftIndex, rightIndex);
        leftIndex++;
        rightIndex--;
        await Future.delayed(Duration(milliseconds: super.speed), () {
          left = leftIndex;
          right = rightIndex;
          notifyObservers(leftIndex, rightIndex, pivotIndex);
        });
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
    await Future.delayed(Duration(milliseconds: super.speed), () {
      left = leftIndex;
      right = rightIndex;
      notifyObservers(leftIndex, rightIndex, pivotIndex);
    });

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
    if(pivotSelection == PivotSelection.StartIndex){
    }
    else {
    }
  }

  void _swap(List<int> array, int firstIndex, int secondIndex) {
    int temp = array[firstIndex];
    array[firstIndex] = array[secondIndex];
    array[secondIndex] = temp;
  }

}