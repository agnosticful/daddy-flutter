import 'package:daddy/domain.dart' show NecessityList;

abstract class NecessityRepository {
  Future<NecessityList> getPrimaryNecessityList();
}
