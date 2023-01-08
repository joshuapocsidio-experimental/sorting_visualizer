import 'package:sorting_visualizer/controller/SortController.dart';
import 'package:sorting_visualizer/model/SortClass.dart';
import 'package:sorting_visualizer/model/SortObserver.dart';

class SelectionSort extends SortParentClass {

  late List<SortViewObserver> _obs;
  late int comparisonIndex, iterationIndex;
  late List<int> sortedIndices;

  SelectionSort(int speed) : super(speed)  {
    _obs = [];
    sortedIndices = [];
    _init();
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
  void notifyObservers(int i, int j) {
    for(SortViewObserver ob in _obs){
      ob.refresh();
    }
  }
  void notifySortedObservers(int sortedIndex) {
    for(SortViewObserver ob in _obs){
      ob.refresh();
    }
  }

  void _init() {
    comparisonIndex = -1;
    iterationIndex = -1;
  }

  @override
  Future<List<int>> sort(List<int> unsortedArray) async {
    for(int i = 0; i < unsortedArray.length && SortController.instance.isSorting; i++) {
      int minimum = unsortedArray[i];
      int minIndex = i;
      for(int j = i+1; j < unsortedArray.length && SortController.instance.isSorting; j++) {
        int check = unsortedArray[j];

        await Future.delayed(Duration(milliseconds: super.speed), () {
          notifyObservers(i, j);
          iterationIndex = i;
          comparisonIndex = j;
        });

        if(check < minimum) {
          minimum = check;
          minIndex = j;
        }
      }
      // At the end of the iteration, if a new minimum is found, swap
      if(minimum != unsortedArray[i]) {
        unsortedArray[minIndex] = unsortedArray[i];
        unsortedArray[i] = minimum;
      }

      await Future.delayed(Duration(milliseconds: super.speed * 3), () {
        if(sortedIndices.contains(i) == false) {
          sortedIndices.add(i);
        }
        notifySortedObservers(i);
      });
    }
    isSorting = false;
    _init();
    return unsortedArray;
  }
}