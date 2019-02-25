import 'package:daddy/domain.dart' show Necessity;

abstract class NecessityList {
  List<Necessity> get necessities;

  NecessityList delete(Necessity necessity);
}
