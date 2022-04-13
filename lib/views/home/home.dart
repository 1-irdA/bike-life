import 'dart:async';

import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/views/home/discover.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/views/member/member_home.dart';
import 'package:bike_life/widgets/buttons/nav_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StreamController<bool> _authState = StreamController();

  @override
  void initState() {
    super.initState();
    Storage.checkIfLogged(_authState);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: AuthGuard(
          authStream: _authState.stream,
          signedIn: const MemberHomePage(),
          signedOut: _layout()));

  Widget _layout() => ListView(
        children: <Widget>[
          Center(
            child: Padding(
              child: Text(title, style: mainTextStyle),
              padding: const EdgeInsets.only(top: 10.0),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(thirdSize),
                  child: Lottie.asset('assets/bike.json', fit: BoxFit.contain)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: thirdSize),
                child: Center(
                  child: Text(
                    "La santé de votre vélo se surveille de près.",
                    style: italicTextStyle,
                  ),
                ),
              ),
              const AppNavButton(
                  text: 'Découvrir',
                  destination: DiscoverPage(),
                  color: primaryColor),
              const AppNavButton(
                  text: 'Connexion',
                  destination: SigninPage(),
                  color: primaryColor)
            ],
          )
        ],
      );
}
