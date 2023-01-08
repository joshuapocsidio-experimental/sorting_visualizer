import 'package:sorting_visualizer/controller/SortController.dart';
import 'package:sorting_visualizer/model/SortClass.dart';
import 'package:sorting_visualizer/model/SortObserver.dart';

class InsertionSort extends SortParentClass {

  late List<SortViewObserver> _obs;

  late int aIndex, bIndex, iterationIndex;

  InsertionSort(int speed) : super(speed)  {
    _obs = [];
    _init();
  }

  void addObserver(SortViewObserver ob) async {
    this._obs.add(ob);
  }
  void removeObserver(SortViewObserver ob) {
    this._obs.remove(ob);
  }
  void clearObservers() async {
    _obs = [];
  }
  void notifyObservers() {
    for(SortViewObserver ob in _obs){
      ob.refresh();
    }
  }

  void _init() {
    aIndex = -1;
    bIndex = -1;
    iterationIndex = -1;
  }

  @override
  Future<List<int>> sort(List<int> unsortedArray) async {
    for(int i = 1; i < unsortedArray.length && SortController.instance.isSorting; i++){     // Start with 2nd element in the array
      int current = unsortedArray.elementAt(i);
      for(int j = i-1; j >= 0 && SortController.instance.isSorting; j--) {       // Iterate backwards and compare until the first element
        // If current integer is less than previous value, swap
        int check = unsortedArray.elementAt(j);
        await Future.delayed(Duration(milliseconds: super.speed), () {
          iterationIndex = i;
          aIndex = j;
          bIndex = j-1;
          notifyObservers();
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
    _init();
    return unsortedArray;
  }
}