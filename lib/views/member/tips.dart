import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/models/tip.dart';
import 'package:bike_life/services/tip_service.dart';
import 'package:bike_life/styles/animations.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/widgets/buttons/top_left_button.dart';
import 'package:bike_life/widgets/click_region.dart';
import 'package:bike_life/widgets/error.dart';
import 'package:bike_life/widgets/loading.dart';
import 'package:flutter/material.dart';

class TipsPage extends StatefulWidget {
  const TipsPage({Key? key}) : super(key: key);

  @override
  _TipsPageState createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {
  late Future<List<Tip>> _tips;

  @override
  void initState() {
    super.initState();
    _tips = _loadTips();
  }

  Future<List<Tip>> _loadTips() async {
    final HttpResponse response = await TipService().getByTopic('%');

    if (response.success()) {
      return createTips(response.body());
    } else {
      throw Exception(response.message());
    }
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > maxWidth) {
          return _narrowLayout(context);
        } else {
          return _wideLayout(context);
        }
      }));

  Widget _narrowLayout(BuildContext context) => Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 12),
      child: _wideLayout(context));

  Widget _wideLayout(BuildContext context) => FutureBuilder<List<Tip>>(
      future: _tips,
      builder: (_, snapshot) {
        if (snapshot.hasError) {
          return const AppError(message: 'Erreur de connexion avec le serveur');
        } else if (snapshot.hasData) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                for (Tip tip in snapshot.data!) _buildTip(tip)
              ]);
        }
        return const AppLoading();
      });

  Widget _buildTip(Tip tip) => Card(
        elevation: 5,
        child: GestureDetector(
          onTap: () => Navigator.push(
              context, animationRightLeft(TipDetailsPage(tip: tip))),
          child: ListTile(
            title: AppClickRegion(child: Text(tip.title)),
            subtitle: AppClickRegion(child: Text(tip.writeDate)),
          ),
        ),
      );
}

class TipDetailsPage extends StatelessWidget {
  final Tip tip;
  const TipDetailsPage({Key? key, required this.tip}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > maxWidth) {
          return _narrowLayout(context);
        } else {
          return _wideLayout(context);
        }
      }));

  Widget _narrowLayout(BuildContext context) => Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 12),
      child: _wideLayout(context));

  Widget _wideLayout(BuildContext context) => ListView(
        padding: const EdgeInsets.symmetric(horizontal: thirdSize),
        children: <Widget>[
          AppTopLeftButton(title: 'Conseils', callback: () => _back(context)),
          buildText(tip.title, boldTextStyle, TextAlign.center),
          buildText(tip.content, thirdTextStyle, TextAlign.center),
        ],
      );

  Padding buildText(String text, TextStyle style, TextAlign textAlign) =>
      Padding(
          padding: const EdgeInsets.symmetric(vertical: thirdSize),
          child: Text(text, textAlign: textAlign, style: style));

  void _back(BuildContext context) => Navigator.pop(context);
}
