import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/services/member_service.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/widgets/buttons/button.dart';
import 'package:bike_life/widgets/buttons/top_left_button.dart';
import 'package:bike_life/widgets/error.dart';
import 'package:bike_life/widgets/loading.dart';
import 'package:bike_life/widgets/snackbar.dart';
import 'package:bike_life/widgets/textfield.dart';
import 'package:flutter/material.dart';

class UpdateEmailPage extends StatefulWidget {
  const UpdateEmailPage({Key? key}) : super(key: key);

  @override
  State<UpdateEmailPage> createState() => _UpdateEmailPageState();
}

class _UpdateEmailPageState extends State<UpdateEmailPage> {
  final _keyForm = GlobalKey<FormState>();

  final _emailFocus = FocusNode();
  final _email = TextEditingController();

  final _memberService = MemberService();
  late final Future<String> _userEmail;

  @override
  void initState() {
    super.initState();
    _userEmail = _load();
  }

  Future<String> _load() async {
    final HttpResponse response = await _memberService.getEmail();

    if (response.success()) {
      return response.email();
    } else {
      throw Exception(response.message());
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth > maxWidth) {
            return _narrowLayout(context);
          } else {
            return _wideLayout();
          }
        }),
      );

  Widget _narrowLayout(BuildContext context) => Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 8),
      child: _wideLayout());

  Widget _wideLayout() => Form(
        key: _keyForm,
        child: Column(
          children: <Widget>[
            AppTopLeftButton(
              title: "Changer l'email",
              callback: () => Navigator.pop(context),
            ),
            FutureBuilder(
                future: _userEmail,
                builder: (_, snapshot) {
                  if (snapshot.hasError) {
                    return const AppError(message: 'Problème de connexion');
                  } else if (snapshot.hasData) {
                    _email.text = snapshot.data.toString();
                    return AppTextField(
                      keyboardType: TextInputType.emailAddress,
                      label: 'Email',
                      focusNode: _emailFocus,
                      textfieldController: _email,
                      validator: emailValidator,
                      icon: Icons.alternate_email,
                    );
                  }
                  return const AppLoading();
                }),
            AppButton(
              text: "Modifier",
              callback: _onUpdate,
              icon: const Icon(Icons.save),
            )
          ],
        ),
      );

  void _onUpdate() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _updateEmail();
    }
  }

  void _updateEmail() async {
    final HttpResponse response =
        await _memberService.updateEmail(_email.text.trim());

    if (response.success()) {
      showSuccessSnackBar(context, response.message());
    } else {
      showErrorSnackBar(context, response.message());
    }
  }
}
