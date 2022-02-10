import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/component.dart';
import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/services/component_service.dart';
import 'package:bike_life/styles/animations.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/views/member/click_region.dart';
import 'package:bike_life/views/member/component_historic.dart';
import 'package:bike_life/widgets/loading.dart';
import 'package:bike_life/widgets/top_left_button.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class BikeComponentsPage extends StatefulWidget {
  final Bike bike;
  const BikeComponentsPage({Key? key, required this.bike}) : super(key: key);

  @override
  _BikeComponentsPageState createState() => _BikeComponentsPageState();
}

class _BikeComponentsPageState extends State<BikeComponentsPage> {
  late Future<List<Component>> _components;

  @override
  void initState() {
    super.initState();
    _components = _loadComponents();
  }

  Future<List<Component>> _loadComponents() async {
    final ComponentService componentService = ComponentService();
    final HttpResponse response =
        await componentService.getBikeComponents(widget.bike.id);

    if (response.success()) {
      return createComponents(response.body());
    } else {
      throw Exception('Impossible de récupérer les données');
    }
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > maxWidth) {
          return _narrowLayout(context);
        } else {
          return _wideLayout();
        }
      }));

  Widget _narrowLayout(BuildContext context) => Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 8),
      child: _wideLayout());

  Widget _wideLayout() => ListView(children: [
        AppTopLeftButton(title: 'Composants', callback: _back),
        _buildList()
      ]);

  FutureBuilder _buildList() => FutureBuilder<List<Component>>(
      future: _components,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              itemBuilder: (_, index) => _buildTile(snapshot.data![index]));
        }
        return const AppLoading();
      });

  Widget _buildTile(Component component) {
    final Duration diff = DateTime.now().difference(component.changedAt);
    final String kmSinceLastChange =
        (diff.inDays * (widget.bike.kmPerWeek / 7)).toStringAsFixed(2);

    return Card(
        elevation: 5,
        child: ListTile(
            title: AppClickRegion(
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(component.type))),
            subtitle: Column(children: <Widget>[
              _buildLinearPercentBar(component),
              Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                      '$kmSinceLastChange km depuis le ${component.changedAtToString()}'))
            ])));
  }

  Widget _buildLinearPercentBar(Component component) {
    final Duration diff = DateTime.now().difference(component.changedAt);
    double percent =
        diff.inDays * (widget.bike.kmPerWeek / 7) / component.duration;
    percent = percent > 1.0 ? 1 : percent;

    return AppClickRegion(
        child: GestureDetector(
            onTap: () => _onComponentHistoric(component),
            child: LinearPercentIndicator(
                lineHeight: mainSize,
                center: Text('${(percent * 100).toStringAsFixed(0)} %'),
                percent: percent,
                backgroundColor: grey,
                progressColor: percent >= 1
                    ? red
                    : percent > .5
                        ? orange
                        : green,
                barRadius: const Radius.circular(50))));
  }

  void _back() => Navigator.of(context).pop();

  void _onComponentHistoric(Component component) => Navigator.push(
      context, animationRightLeft(ComponentHistoricPage(component: component)));
}
