import 'package:daddy/domain.dart' show Necessity, NecessityList, Place;
import 'package:daddy/service.dart' show NecessityRepository;
import 'package:meta/meta.dart';
import 'package:random_string/random_string.dart';

class FakeNecessityRepository implements NecessityRepository {
  Future<NecessityList> getPrimaryNecessityList() async =>
      _FakeNecessityList.random();
}

class _FakeNecessityList implements NecessityList {
  _FakeNecessityList({@required this.necessities})
      : assert(necessities != null);

  _FakeNecessityList.random()
      : necessities = List.generate(
          randomBetween(20, 40),
          (i) => _FakeNecessity.random(),
        );

  @override
  final List<Necessity> necessities;

  @override
  NecessityList delete(Necessity necessity) => _FakeNecessityList(
        necessities: necessities.where((n) => n != necessity).toList(),
      );
}

class _FakeNecessity implements Necessity {
  _FakeNecessity({
    @required this.id,
    @required this.name,
    @required this.note,
    @required this.isUrgent,
    @required this.quantity,
    @required this.linkedPlaces,
    @required this.isDone,
  })  : assert(id != null),
        assert(name != null),
        assert(note != null),
        assert(isUrgent != null),
        assert(quantity != null),
        assert(linkedPlaces != null),
        assert(isDone != null);

  _FakeNecessity.random()
      : id = randomAlphaNumeric(64),
        name = randomAlphaNumeric(randomBetween(6, 32)),
        note = randomAlphaNumeric(randomBetween(6, 32)),
        isUrgent = randomBool(),
        quantity = randomBetween(1, 3),
        linkedPlaces =
            List.generate(randomBetween(0, 5), (i) => _FakePlace.random()),
        isDone = randomBool();

  @override
  final String id;

  @override
  final String name;

  @override
  final String note;

  @override
  final bool isUrgent;

  @override
  final int quantity;

  @override
  final List<Place> linkedPlaces;

  @override
  final bool isDone;
}

class _FakePlace implements Place {
  _FakePlace.random()
      : name = randomAlpha(randomBetween(6, 24)),
        address = randomAlpha(randomBetween(18, 64)),
        latitude = randomBetween(-180000, 179999) / 1000,
        longitude = randomBetween(-180000, 179999) / 1000;

  @override
  final String name;

  @override
  final String address;

  @override
  final double latitude;

  @override
  final double longitude;
}

bool randomBool() => randomBetween(0, 1) == 1 ? false : true;
