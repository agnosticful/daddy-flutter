import 'package:daddy/domain.dart' show Necessity;

abstract class NecessityList {
  List<Necessity> get necessities;

  int indexOf(Necessity necessity);

  NecessityList insert(int position, Necessity necessity);

  NecessityList delete(Necessity necessity);
}
