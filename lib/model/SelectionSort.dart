import 'package:sorting_visualizer/model/SortClass.dart';
import 'package:sorting_visualizer/model/SortObserver.dart';

class SelectionSort extends Sorter {

  late List<SortViewObserver> obs;
  late int comparisonIndex, iterationIndex;
  late List<int> sortedIndices;

  SelectionSort([int speed=0]) : super(speed)  {
    obs = [];
    sortedIndices = [];
    _init();
  }

  void _init() {
    comparisonIndex = -1;
    iterationIndex = -1;
    sortedIndices = [];
  }

  @override
  Future<List<int>> sort(List<int> inPlaceArray, List<int> outPlaceArray) async {
    super.isSorting = true;
    for(int i = 0; i < inPlaceArray.length && super.isSorting; i++) {
      int minimum = inPlaceArray[i];
      int minIndex = i;
      for(int j = i+1; j < inPlaceArray.length && super.isSorting; j++) {
        int check = inPlaceArray[j];

        await notifyObservers(inPlaceArray.length);
        iterationIndex = i;
        comparisonIndex = j;

        if(check < minimum) {
          minimum = check;
          minIndex = j;
        }
      }
      // At the end of the iteration, if a new minimum is found, swap
      if(minimum != inPlaceArray[i]) {
        inPlaceArray[minIndex] = inPlaceArray[i];
        inPlaceArray[i] = minimum;
      }
      sortedIndices.add(i);
      await notifyObservers(inPlaceArray.length);
    }
    super.isSorting = false;
    _init();
    return inPlaceArray;
  }
}