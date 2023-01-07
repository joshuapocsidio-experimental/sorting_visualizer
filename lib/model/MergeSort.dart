import 'package:sorting_visualizer/controller/SortController.dart';
import 'package:sorting_visualizer/model/SortClass.dart';
import 'package:sorting_visualizer/model/SortObserver.dart';

class MergeSort extends SortParentClass {

  late List<MergeSortObserver> _obs;

  MergeSort(int speed) : super(speed)  {
    _obs = [];
  }

  void addObserver(MergeSortObserver ob) {
    this._obs.add(ob);
  }
  void removeObserver(MergeSortObserver ob) {
    this._obs.remove(ob);
  }
  void clearObservers() {
    _obs = [];
  }

  void notifyOutPlaceObservers(List<int> array, int left, int right) {
    for(MergeSortObserver ob in _obs){
      ob.updateMergeOutPlace(array, left, right);
    }
  }
  void notifyInPlaceObservers(List<int> array) {
    for(MergeSortObserver ob in _obs){
      ob.updateMergeInPlace(array);
    }
  }

  @override
  Future<List<int>> sort(List<int> unsortedArray) async {
    List<int> temp = unsortedArray.toList(growable: true);
    List<int> newArray = unsortedArray.toList(growable: true);
    List<int> sortedArray = await _mergeRecurse(newArray, temp, 0, unsortedArray.length-1);
    await Future.delayed(Duration(milliseconds: super.speed), () {
      temp = List.filled(unsortedArray.length, 0);
      notifyOutPlaceObservers(temp, 0, unsortedArray.length);
    });
    return sortedArray;
  }

  Future<List<int>> _mergeRecurse(List<int> array, List<int> temp, int origLeftIndex, int origRightIndex) async {
    int mid = array.length ~/2;
    // End once single elements reached
    if(array.length <= 1 || !SortController.instance.isSorting) {
      return array;
    }
    // Split  Left
    List<int> leftArray = await _mergeRecurse(array.sublist(0, mid), temp, origLeftIndex, origLeftIndex + mid );
    // Split Right
    List<int> rightArray = await _mergeRecurse(array.sublist(mid, array.length), temp, origLeftIndex + mid, origRightIndex);
    // Merge
    List<int> mergedArray = await _merge(leftArray, rightArray, temp, origLeftIndex, origRightIndex);
    if(origLeftIndex < origRightIndex) {
      for(int mInt in mergedArray) {
        List<int> sList = temp.sublist(origLeftIndex, origRightIndex);
        if(sList.contains(mInt)) {
          temp.replaceRange(origLeftIndex, origLeftIndex + mergedArray.length, mergedArray);
        }
      }
    }
    await Future.delayed(Duration(milliseconds: super.speed), () {
      notifyInPlaceObservers(temp);
    });
    return mergedArray;
  }

  Future<List<int>> _merge(List<int> leftArray, List<int> rightArray, List<int> temp, int origLeftIndex, int origRightIndex) async{
    if(!SortController.instance.isSorting) {
      leftArray.addAll(rightArray);
      return leftArray;
    }
    temp = List.filled(temp.length, 0, growable: true);
    List<int> outArray = [];
    int left = 0, right = 0;
    while(left < leftArray.length && right < rightArray.length) {
      if(leftArray[left] < rightArray[right]) {
        outArray.add(leftArray[left]);
        temp[origLeftIndex + left + right] = leftArray[left];
        left++;
      }
      else {
        outArray.add(rightArray[right]);
        temp[origLeftIndex + left + right] = rightArray[right];
        right++;
      }
      await Future.delayed(Duration(milliseconds: super.speed), () {
        notifyOutPlaceObservers(temp, origLeftIndex, origRightIndex);
      });
    }
    while(left < leftArray.length) {
      outArray.add(leftArray[left]);
      temp[origLeftIndex + left + right] = leftArray[left];
      await Future.delayed(Duration(milliseconds: super.speed), () {
        notifyOutPlaceObservers(temp, origLeftIndex, origRightIndex);
      });
      left++;
    }
    while(right < rightArray.length) {
      outArray.add(rightArray[right]);
      temp[origLeftIndex + left + right] = rightArray[right];
      await Future.delayed(Duration(milliseconds: super.speed), () {
        notifyOutPlaceObservers(temp, origLeftIndex, origRightIndex);
      });
      right++;
    }
    return outArray;
  }

}