import 'package:bike_life/constants.dart';
import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/member.dart';
import 'package:bike_life/repositories/bike_repository.dart';
import 'package:bike_life/routes/add_bike_route.dart';
import 'package:bike_life/routes/member_argument.dart';
import 'package:bike_life/routes/profile_page_route.dart';
import 'package:bike_life/views/member/bike_card.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/widgets/top_right_button.dart';
import 'package:bike_life/views/widgets/card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class AllBikesPage extends StatefulWidget {
  final Member member;
  const AllBikesPage({Key? key, required this.member}) : super(key: key);

  @override
  _AllBikesPageState createState() => _AllBikesPageState();
}

class _AllBikesPageState extends State<AllBikesPage> {
  final BikeRepository _bikeRepository = BikeRepository();
  final List<Widget> _cards = [];
  List<Bike> _bikes = [];

  void _loadBikes() async {
    dynamic jsonBikes = await _bikeRepository.getBikes(widget.member.id);
    setState(() {
      _bikes = createSeveralBikes(jsonBikes['bikes']);
      Future.wait(_bikes.map((bike) async => _cards.add(BikeCard(bike: bike))));
      _cards.add(_buildAddBikeCard());
    });
  }

  @override
  void initState() {
    super.initState();
    _loadBikes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: <Widget>[
      AppTopRightButton(callback: _onClickProfile, icon: Icons.person),
      Center(child: _buildCarousel())
    ]));
  }

  Widget _buildCarousel() => CarouselSlider.builder(
      options: CarouselOptions(
          height: MediaQuery.of(context).size.height - ratio,
          enableInfiniteScroll: false),
      itemCount: _cards.length,
      itemBuilder: (BuildContext context, int index, int realIndex) =>
          _cards.elementAt(index));

  void _onClickProfile() =>
      Navigator.pushNamed(context, ProfilePageRoute.routeName,
          arguments: MemberArgument(widget.member));

  Widget _buildAddBikeCard() => SizedBox(
      width: double.infinity,
      child: AppCard(
          child: IconButton(
              icon: const Icon(Icons.add, size: 50.0, color: mainColor),
              onPressed: _onClickAddBike),
          elevation: secondSize));

  void _onClickAddBike() => Navigator.pushNamed(context, AddBikeRoute.routeName,
      arguments: MemberArgument(widget.member));
}
