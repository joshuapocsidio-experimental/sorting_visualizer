import 'package:sorting_visualizer/model/SortClass.dart';

class MergeSort extends Sorter{

  late int leftIndex, rightIndex;

  MergeSort([int speed=0]) : super(speed)  {
    obs = [];
    _init();
  }

  void _init(){
    leftIndex = -1;
    rightIndex = -1;
  }

  @override
  Future<List<int>> sort(List<int> inPlaceArray, List<int> outPlaceArray) async {
    super.isSorting = true;
    List<int> piArray = inPlaceArray.toList(growable: true);
    List<int> sortedArray = await _mergeRecurse(piArray, inPlaceArray, outPlaceArray, 0, inPlaceArray.length);
    await notifyObservers(inPlaceArray.length);
    await notifyObservers(outPlaceArray.length);
    _init();
    super.isSorting = false;
    return sortedArray;
  }

  Future<List<int>> _mergeRecurse(List<int> array, List<int> inPlaceArray, List<int> outPlaceArray, int origLeftIndex, int origRightIndex) async {
    int mid = array.length ~/2;
    // End once single elements reached
    if(array.length <= 1 || !super.isSorting) {
      return array;
    }
    // Split  Left
    List<int> leftArray = await _mergeRecurse(array.sublist(0, mid), inPlaceArray, outPlaceArray, origLeftIndex, origLeftIndex + mid );
    // Split Right
    List<int> rightArray = await _mergeRecurse(array.sublist(mid, array.length), inPlaceArray, outPlaceArray, origLeftIndex + mid, origRightIndex);
    // Merge
    List<int> mergedArray = await _merge(leftArray, rightArray, outPlaceArray, origLeftIndex, origRightIndex);

    inPlaceArray.replaceRange(origLeftIndex, origLeftIndex + mergedArray.length, mergedArray);
    await notifyObservers(inPlaceArray.length);
    return mergedArray;
  }

  Future<List<int>> _merge(List<int> leftArray, List<int> rightArray, List<int> outPlaceArray, int origLeftIndex, int origRightIndex) async{
    leftIndex = origLeftIndex;
    rightIndex = origRightIndex-1;
    if(!super.isSorting) {
      leftArray.addAll(rightArray);
      return leftArray;
    }
    outPlaceArray.replaceRange(0, outPlaceArray.length, List.filled(outPlaceArray.length, 0, growable: true));
    List<int> outArray = [];
    int left = 0, right = 0;
    while(left < leftArray.length && right < rightArray.length) {
      if(leftArray[left] < rightArray[right]) {
        outArray.add(leftArray[left]);
        outPlaceArray[origLeftIndex + left + right] = leftArray[left];
        left++;
      }
      else {
        outArray.add(rightArray[right]);
        outPlaceArray[origLeftIndex + left + right] = rightArray[right];
        right++;
      }
      await notifyObservers(outPlaceArray.length);
    }
    while(left < leftArray.length) {
      outArray.add(leftArray[left]);
      outPlaceArray[origLeftIndex + left + right] = leftArray[left];
      await notifyObservers(outPlaceArray.length);
      left++;
    }
    while(right < rightArray.length) {
      outArray.add(rightArray[right]);
      outPlaceArray[origLeftIndex + left + right] = rightArray[right];
      await notifyObservers(outPlaceArray.length);
      right++;
    }
    return outArray;
  }
}