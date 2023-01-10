import 'package:sorting_visualizer/model/SortClass.dart';
import 'package:sorting_visualizer/model/SortObserver.dart';

class BubbleSort extends Sorter {

  late List<SortViewObserver> obs;
  late int aIndex, bIndex;
  late List<int> sortedIndices;

  BubbleSort([int speed=0]) : super(speed) {
    obs = [];
    _init();
  }

  void _init() {
    aIndex = -1;
    bIndex = -1;
    sortedIndices = [];
  }

  @override
  Future<List<int>> sort(List<int> inPlaceArray, List<int> outPlaceArray) async {
    int numSwaps;
    int sortedIndex = inPlaceArray.length;
    super.isSorting = true;

    do {
      numSwaps = 0;
      for(int i = 0; i < sortedIndex - 1 && super.isSorting; i++) {
        aIndex = i;
        bIndex = i+1;
        await notifyObservers(inPlaceArray.length);
        if(inPlaceArray[i] > inPlaceArray[i+1]) {
          int temp = inPlaceArray[i+1];
          inPlaceArray[i+1] = inPlaceArray[i];
          inPlaceArray[i] = temp;
          numSwaps++;
          await notifyObservers(inPlaceArray.length);
        }
      }
      sortedIndex--;
      sortedIndices.add(sortedIndex);
      await notifyObservers(inPlaceArray.length);
    } while(numSwaps != 0);
    _init();
    super.isSorting = false;
    return inPlaceArray;
  }
}