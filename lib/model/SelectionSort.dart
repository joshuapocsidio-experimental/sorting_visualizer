import 'package:sorting_visualizer/controller/SortController.dart';
import 'package:sorting_visualizer/model/SortClass.dart';
import 'package:sorting_visualizer/model/SortObserver.dart';

class SelectionSort extends SortParentClass {

  late List<SelectionSortObserver> _obs;

  SelectionSort(int speed) : super(speed)  {
    _obs = [];
  }

  void addObserver(SelectionSortObserver ob) {
    this._obs.add(ob);
  }
  void removeObserver(SelectionSortObserver ob) {
    this._obs.remove(ob);
  }
  void clearObservers() {
    _obs = [];
  }
  void notifyObservers(int i, int j) {
    for(SelectionSortObserver ob in _obs){
      ob.updateSelectionIndex(i, j);
    }
  }
  void notifySortedObservers(int sortedIndex) {
    for(SelectionSortObserver ob in _obs){
      ob.updateSorted(sortedIndex);
    }
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
        notifySortedObservers(i);
      });
    }
    isSorting = false;
    return unsortedArray;
  }
}