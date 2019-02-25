import 'package:daddy/domain.dart' show Necessity, NecessityList;
import 'package:daddy/service.dart' show FakeNecessityRepository;
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter/material.dart';

class NecessityListView extends StatefulWidget {
  @override
  State<NecessityListView> createState() => _NecessityListViewState();
}

class _NecessityListViewState extends State<NecessityListView> {
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

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
  Widget build(BuildContext context) => _necessityList != null
      ? RefreshIndicator(
          key: _refreshIndicatorKey,
          color: Color(0xff1dd1a1),
          onRefresh: _onRefresh,
          child: ListView.separated(
            itemBuilder: (context, i) => _NecessityListViewItem(
                  key: Key(_necessityList.necessities[i].id),
                  necessity: _necessityList.necessities[i],
                  onDismiss: _onDismissItem,
                ),
            separatorBuilder: (context, i) => Divider(height: 0),
            itemCount: _necessityList.necessities.length,
          ),
        )
      : Container();

  Future<void> _onRefresh() async {
    final necessityList =
        await FakeNecessityRepository().getPrimaryNecessityList();

    await Future.delayed(Duration(milliseconds: 750));

    setState(() {
      _necessityList = necessityList;
    });
  }

  void _onDismissItem(DismissDirection direction, Necessity necessity) {
    setState(() {
      _necessityList = _necessityList.delete(necessity);
    });
  }
}

class _NecessityListViewItem extends StatelessWidget {
  _NecessityListViewItem(
      {@required this.necessity, @required this.onDismiss, @required Key key})
      : assert(necessity != null),
        assert(onDismiss != null),
        super(key: key);

  final Necessity necessity;

  final DismissCallback onDismiss;

  @override
  Widget build(BuildContext context) => Dismissible(
        key: key,
        background: Container(
          decoration: BoxDecoration(
            color: Color(0xff1dd1a1),
          ),
          child: Row(
            children: [
              SizedBox.fromSize(size: Size.fromWidth(16)),
              Icon(
                Feather.getIconData('check'),
                color: Color(0xffffffff),
              ),
              SizedBox.fromSize(size: Size.fromWidth(8)),
              Text(
                'Done',
                style: TextStyle(
                  color: Color(0xffffffff),
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
            ],
          ),
        ),
        secondaryBackground: Container(
          decoration: BoxDecoration(
            color: Color(0xff1dd1a1),
          ),
          child: Row(
            children: [
              Spacer(),
              Text(
                'Done',
                style: TextStyle(
                  color: Color(0xffffffff),
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox.fromSize(size: Size.fromWidth(8)),
              Icon(
                Feather.getIconData('check'),
                color: Color(0xffffffff),
              ),
              SizedBox.fromSize(size: Size.fromWidth(16)),
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
        ),
      );

  void _onDismiss(DismissDirection direction) =>
      onDismiss(direction, necessity);
}

typedef void DismissCallback(DismissDirection direction, Necessity necessity);
