import 'package:sorting_visualizer/controller/SortController.dart';
import 'package:sorting_visualizer/model/SortClass.dart';
import 'package:sorting_visualizer/model/SortObserver.dart';

class QuickSort extends SortParentClass {

  late List<QuickSortObserver> _obs;

  QuickSort(int speed) : super(speed)  {
    _obs = [];
  }

  void addObserver(QuickSortObserver ob) {
    this._obs.add(ob);
  }
  void removeObserver(QuickSortObserver ob) {
    this._obs.remove(ob);
  }
  void clearObservers() {
    _obs = [];
  }
  void notifyObservers(int left, int right, int pivot) {
    for(QuickSortObserver ob in _obs){
      ob.updateQuickIndex(left, right, pivot);
    }
  }

  @override
  Future<List<int>> sort(List<int> unsortedArray) async {
    await _quickRecurse(unsortedArray, 0, unsortedArray.length-1);
    return unsortedArray;
  }

  Future<void> _quickRecurse(List<int> array, int startIndex, int endIndex) async {
    if(array.isEmpty || !SortController.instance.isSorting) {
      return;
    }
    if(startIndex >= array.length || endIndex <= 0) {
      return;
    }
    int pivot = array[endIndex];
    int leftIndex = startIndex;
    int rightIndex = endIndex - 1;

    if(leftIndex > rightIndex) {
      return;
    }
    while(leftIndex <= rightIndex) {
      while(leftIndex <= rightIndex && array[leftIndex] <= pivot) {
        leftIndex++;
        await Future.delayed(Duration(milliseconds: super.speed), () {
          notifyObservers(leftIndex, rightIndex, endIndex);
        });
      }
      while(leftIndex <= rightIndex && array[rightIndex] >= pivot) {
        rightIndex--;
        await Future.delayed(Duration(milliseconds: super.speed), () {
          notifyObservers(leftIndex, rightIndex, endIndex);
        });
      }
      if(leftIndex < rightIndex) {
        _swap(array, leftIndex, rightIndex);
        leftIndex++;
        rightIndex--;
        await Future.delayed(Duration(milliseconds: super.speed), () {
          notifyObservers(leftIndex, rightIndex, endIndex);
        });
      }
    }
    _swap(array, leftIndex, endIndex);
    await Future.delayed(Duration(milliseconds: super.speed), () {
      notifyObservers(leftIndex, rightIndex, endIndex);
    });

    int pi = leftIndex;
    await _quickRecurse(array, startIndex, pi-1);
    await _quickRecurse(array, pi+1, endIndex);
  }

  void _swap(List<int> array, int firstIndex, int secondIndex) {
    int temp = array[firstIndex];
    array[firstIndex] = array[secondIndex];
    array[secondIndex] = temp;
  }

}