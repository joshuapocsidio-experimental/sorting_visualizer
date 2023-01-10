import 'package:sorting_visualizer/model/SortClass.dart';
import 'package:sorting_visualizer/model/SortObserver.dart';

class InsertionSort extends Sorter {

  late List<SortViewObserver> obs;

  late int aIndex, bIndex, iterationIndex;

  InsertionSort([int speed=0]) : super(speed)  {
    obs = [];
    _init();
  }

  void _init() {
    aIndex = -1;
    bIndex = -1;
    iterationIndex = -1;
  }

  @override
  Future<List<int>> sort(List<int> inPlaceArray, List<int> outPlaceArray) async {
    super.isSorting = true;
    for(int i = 1; i < inPlaceArray.length && super.isSorting; i++){     // Start with 2nd element in the array
      int current = inPlaceArray.elementAt(i);
      for(int j = i-1; j >= 0 && super.isSorting; j--) {       // Iterate backwards and compare until the first element
        // If current integer is less than previous value, swap
        int check = inPlaceArray.elementAt(j);
        iterationIndex = i;
        aIndex = j;
        bIndex = j-1;
        await notifyObservers(inPlaceArray.length);

        if(check < current) {
          break;
        }

        if(check > current) {
          inPlaceArray[j] = current;
          inPlaceArray[j+1] = check;
        }
      }
    }
    await Future.delayed(Duration(milliseconds: super.speed*3~/inPlaceArray.length));
    super.isSorting = false;
    _init();
    return inPlaceArray;
  }
}