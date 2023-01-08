import 'package:sorting_visualizer/controller/SortController.dart';
import 'package:sorting_visualizer/model/SortClass.dart';
import 'package:sorting_visualizer/model/SortObserver.dart';

class BubbleSort extends SortParentClass {

  late List<SortViewObserver> _obs;
  late int aIndex, bIndex;
  late List<int> sortedIndices;

  BubbleSort(int speed) : super(speed) {
    _obs = [];
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
  void notifyObservers() {
    for(SortViewObserver ob in _obs){
      ob.refresh();
    }
  }

  void _init() {
    aIndex = -1;
    bIndex = -1;
    sortedIndices = [];
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
            aIndex = i;
            bIndex = i+1;
            notifyObservers();
          });
        }
      }
      await Future.delayed(Duration(milliseconds: super.speed * 3), () {
        if(sortedIndices.contains(sortedIndex) == false) {
          sortedIndices.add(sortedIndex);
        }
        notifyObservers();
      });
    } while(numSwaps != 0);
    _init();
    return unsortedArray;
  }
}