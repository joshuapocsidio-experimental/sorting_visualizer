import 'package:sorting_visualizer/controller/SortController.dart';


class SortUIObserver {
  void updateIsSorting(bool isSorting){}
  void updateSortChoice(SortChoice sortChoice) {}
}

class SortViewObserver {
  void refresh(){}
  void updateInPlace(List<int> array){}
  void updateOutPlace(List<int> array){}
}