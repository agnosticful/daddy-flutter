import 'package:daddy/domain.dart' show Place;

abstract class Necessity {
  String get id;
  String get name;
  String get note;
  bool get isUrgent;
  int get quantity;
  List<Place> get linkedPlaces;
  bool get isDone;

  operator ==(Object other) => other is Necessity && other.hashCode == hashCode;

  get hashCode => id.hashCode;
}
