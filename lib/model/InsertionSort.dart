import 'package:sorting_visualizer/controller/SortController.dart';
import 'package:sorting_visualizer/model/SortClass.dart';
import 'package:sorting_visualizer/model/SortObserver.dart';

class InsertionSort extends SortParentClass {

  late List<InsertionSortObserver> _obs;

  InsertionSort(int speed) : super(speed)  {
    _obs = [];
  }

  void addObserver(InsertionSortObserver ob) {
    this._obs.add(ob);
  }
  void removeObserver(InsertionSortObserver ob) {
    this._obs.remove(ob);
  }
  void clearObservers() {
    _obs = [];
  }
  void notifyObservers(int i, int j) {
    for(InsertionSortObserver ob in _obs){
      ob.updateInsertionIndex(i, j);
    }
  }

  @override
  Future<List<int>> sort(List<int> unsortedArray) async {
    for(int i = 1; i < unsortedArray.length && SortController.instance.isSorting; i++){     // Start with 2nd element in the array
      int current = unsortedArray.elementAt(i);
      for(int j = i-1; j >= 0 && SortController.instance.isSorting; j--) {       // Iterate backwards and compare until the first element
        // If current integer is less than previous value, swap
        int check = unsortedArray.elementAt(j);
        await Future.delayed(Duration(milliseconds: super.speed), () {
          notifyObservers(i, j);
        });

        if(check < current) {
          break;
        }

        if(check > current) {
          unsortedArray[j] = current;
          unsortedArray[j+1] = check;
        }
      }
    }
    await Future.delayed(Duration(milliseconds: super.speed * 3));
    isSorting = false;
    return unsortedArray;
  }
}