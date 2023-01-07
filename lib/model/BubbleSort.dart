import 'package:sorting_visualizer/controller/SortController.dart';
import 'package:sorting_visualizer/model/SortClass.dart';
import 'package:sorting_visualizer/model/SortObserver.dart';

class BubbleSort extends SortParentClass {

  late List<BubbleSortObserver> _obs;

  BubbleSort(int speed) : super(speed) {
    _obs = [];
  }

  void addObserver(BubbleSortObserver ob) {
    this._obs.add(ob);
  }
  void removeObserver(BubbleSortObserver ob) {
    this._obs.remove(ob);
  }
  void clearObservers() {
    _obs = [];
  }
  void notifyObservers(int i, int j) {
    for(BubbleSortObserver ob in _obs){
      ob.updateBubbleIndex(i, j);
    }
  }
  void notifySortedObservers(int sortedIndex) {
    for(BubbleSortObserver ob in _obs){
      ob.updateSorted(sortedIndex);
    }
  }
  @override
  Future<List<int>> sort(List<int> unsortedArray) async {
    int numSwaps;
    int sortedIndex = -1;

    do {
      numSwaps = 0;
      for(int i = 0; i < unsortedArray.length - 1 && SortController.instance.isSorting; i++) {
        if(unsortedArray[i] > unsortedArray[i+1]) {
          int temp = unsortedArray[i+1];
          unsortedArray[i+1] = unsortedArray[i];
          unsortedArray[i] = temp;
          numSwaps++;
          sortedIndex = i + 1;
          await Future.delayed(Duration(milliseconds: super.speed), () {
            notifyObservers(i, i+1);
          });
        }
      }
      await Future.delayed(Duration(milliseconds: super.speed * 3), () {
        print("sorted : $sortedIndex");
        notifySortedObservers(sortedIndex);
      });
    } while(numSwaps != 0);

    return unsortedArray;
  }
}