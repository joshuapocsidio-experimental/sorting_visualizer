import 'package:sorting_visualizer/controller/SortController.dart';


class SortUIObserver {
  void updateIsSorting(bool isSorting){}
  void updateSortChoice(SortChoice sortChoice) {}
}

class MergeSortObserver {
  void updateMergeOutPlace(List<int> array, int leftIndex, int rightIndex){}
  void updateMergeInPlace(List<int> array){}
}

class SelectionSortObserver {
  void updateSelectionIndex(int i, int j){}
  void updateSorted(int sortedIndex){}
}

class InsertionSortObserver {
  void updateInsertionIndex(int i, int j){}
}

class QuickSortObserver {
  void updateQuickIndex(int left, int right, int pivot){}
}

class BubbleSortObserver {
  void updateBubbleIndex(int i, int j){}
  void updateSorted(int sortedIndex){}
}

abstract class SortObserver implements MergeSortObserver, SelectionSortObserver, InsertionSortObserver, QuickSortObserver, BubbleSortObserver {

}