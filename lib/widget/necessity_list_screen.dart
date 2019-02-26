import 'dart:math' as math;
import 'package:daddy/domain.dart' show Necessity, NecessityList;
import 'package:daddy/service.dart' show FakeNecessityRepository;
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter/material.dart';

class NecessityListScreen extends StatefulWidget {
  @override
  State<NecessityListScreen> createState() => _NecessityListScreenState();
}

class _NecessityListScreenState extends State<NecessityListScreen> {
  NecessityList _necessityList;

  @override
  void initState() {
    super.initState();

    FakeNecessityRepository()
        .getPrimaryNecessityList()
        .then((necessityList) => setState(() {
              _necessityList = necessityList;
            }));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(
                'Shopping List',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              centerTitle: true,
              elevation: 1,
              floating: true,
              snap: true,
            ),
            _necessityList == null
                ? SliverList(
                    delegate: SliverChildListDelegate([]),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => i.isOdd
                          ? _NecessityListViewItem(
                              key: Key(_necessityList.necessities[i ~/ 2].id),
                              necessity: _necessityList.necessities[i ~/ 2],
                              onTap: () {},
                              onDone: () => _onNecessityDone(
                                    context,
                                    _necessityList.necessities[i ~/ 2],
                                  ),
                              onDeleted: () => _onNecessityDeleted(
                                    context,
                                    _necessityList.necessities[i ~/ 2],
                                  ),
                            )
                          : Divider(
                              key: Key("div$i"),
                              height: 0,
                            ),
                      childCount: math.max(
                          0, _necessityList.necessities.length * 2 - 1),
                    ),
                  ),
          ],
        ),
      );

  void _onNecessityDone(BuildContext context, Necessity necessity) {
    int necessityIndex = _necessityList.indexOf(necessity);

    setState(() {
      _necessityList = _necessityList.delete(necessity);
    });

    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Marked an item "${necessity.name}" done.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => setState(() {
                _necessityList =
                    _necessityList.insert(necessityIndex, necessity);
              }),
        ),
      ),
    );
  }

  void _onNecessityDeleted(BuildContext context, Necessity necessity) {
    int necessityIndex = _necessityList.indexOf(necessity);

    setState(() {
      _necessityList = _necessityList.delete(necessity);
    });

    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted an item "${necessity.name}".'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => setState(() {
                _necessityList =
                    _necessityList.insert(necessityIndex, necessity);
              }),
        ),
      ),
    );
  }
}

class _NecessityListViewItem extends StatelessWidget {
  _NecessityListViewItem({
    @required this.necessity,
    @required this.onTap,
    @required this.onDone,
    @required this.onDeleted,
    @required Key key,
  })  : assert(necessity != null),
        assert(onTap != null),
        assert(onDone != null),
        assert(onDeleted != null),
        super(key: key);

  final Necessity necessity;

  final VoidCallback onTap;

  final VoidCallback onDone;

  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context) => Dismissible(
        key: key,
        background: Container(
          decoration: BoxDecoration(
            color: Color(0xff1dd1a1),
          ),
          child: Row(
            children: [
              SizedBox.fromSize(size: Size.fromWidth(24)),
              Icon(
                Feather.getIconData('check'),
                color: Color(0xffffffff),
              ),
              Spacer(),
            ],
          ),
        ),
        secondaryBackground: Container(
          decoration: BoxDecoration(
            color: Color(0xffff6b6b),
          ),
          child: Row(
            children: [
              Spacer(),
              Icon(
                Feather.getIconData('trash'),
                color: Color(0xffffffff),
              ),
              SizedBox.fromSize(size: Size.fromWidth(24)),
            ],
          ),
        ),
        onDismissed: _onDismiss,
        child: ListTile(
          title: Text(
            necessity.name,
            style: TextStyle(
              fontFamily: 'Rubik',
            ),
          ),
          onTap: onTap,
        ),
      );

  void _onDismiss(DismissDirection direction) =>
      direction == DismissDirection.startToEnd ? onDone() : onDeleted();
}

typedef void NecessityCallback(Necessity necessity);
