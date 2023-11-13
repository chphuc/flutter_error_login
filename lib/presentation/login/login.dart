import 'package:another_flushbar/flushbar_helper.dart';
import 'package:boilerplate/constants/app_theme.dart';
import 'package:boilerplate/constants/assets.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/core/stores/form/form_store.dart';
import 'package:boilerplate/core/widgets/app_icon_widget.dart';
import 'package:boilerplate/core/widgets/empty_app_bar_widget.dart';
import 'package:boilerplate/core/widgets/progress_indicator_widget.dart';
import 'package:boilerplate/core/widgets/rounded_button_widget.dart';
import 'package:boilerplate/core/widgets/textfield_widget.dart';
import 'package:boilerplate/data/sharedpref/constants/preferences.dart';
import 'package:boilerplate/presentation/home/store/theme/theme_store.dart';
import 'package:boilerplate/presentation/login/store/login_store.dart';
import 'package:boilerplate/utils/device/device_utils.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../di/service_locator.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  //text controllers:-----------------------------------------------------------
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  //stores:---------------------------------------------------------------------
  final ThemeStore _themeStore = getIt<ThemeStore>();
  final FormStore _formStore = getIt<FormStore>();
  final UserStore _userStore = getIt<UserStore>();

  //focus node:-----------------------------------------------------------------
  late FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      appBar: EmptyAppBar(),
      body: _buildBody(),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Material(
      child: Stack(
        children: <Widget>[
          Center(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width,
                      child: _buildLogo(),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      child: _buildForm(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Observer(
            builder: (context) {
              return _userStore.success
                  ? navigate(context)
                  : _showErrorMessage(_formStore.errorStore.errorMessage);
            },
          ),
          Observer(
            builder: (context) {
              return Visibility(
                visible: _userStore.isLoading,
                child: CustomProgressIndicatorWidget(),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      color: AppThemeData.lightColorScheme.primaryContainer,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            child: Image.asset(Assets.appLogo),
          ),
          Text(
            'QUẢN LÝ HÀNH TRÌNH HTTD',
            style: TextStyle(
              fontSize: AppThemeData.bodyText1,
              fontWeight: AppThemeData.bold,
            ),
          ),
          Text(
            'LƯU ĐỘNG',
            style: TextStyle(
              fontSize: AppThemeData.bodyText1,
              fontWeight: AppThemeData.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimens.horizontal_padding,
        vertical: Dimens.vertical_padding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildUserIdField(),
          SizedBox(height: 10),
          _buildPasswordField(),
          SizedBox(height: 10),
          _buildRememberMe(),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: _buildSignInButton(),
              ),
              _buildSignInFinger(),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildUserIdField() {
    return Observer(
      builder: (context) {
        return TextFieldWidget(
          title: 'Tên tài khoản',
          hint: 'Nhập tên tài khoản',
          textController: _userNameController,
          errorText: _formStore.formErrorStore.userEmail,
          onChanged: (value) {
            _formStore.setUserId(_userNameController.text);
          },
        );
      },
    );
  }

  Widget _buildPasswordField() {
    return Observer(
      builder: (context) {
        return TextFieldWidget(
          title: 'Mật khẩu',
          hint: 'Nhập mật khẩu',
          isObscure: true,
          textController: _passwordController,
          errorText: _formStore.formErrorStore.password,
          onChanged: (value) {
            _formStore.setPassword(_passwordController.text);
          },
        );
      },
    );
  }

  Widget _buildRememberMe() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _rememberMe,
            onChanged: (bool? value) {
              setState(() {
                _rememberMe = value!;
              });
            },
            activeColor: Colors.grey,
            hoverColor: Colors.transparent,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          'Ghi nhớ tài khoản',
          style: TextStyle(
            fontSize: AppThemeData.bodyText5,
            fontWeight: AppThemeData.extraBold,
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton() {
    return RoundedButtonWidget(
      buttonText: 'Đăng nhập',
      textColor: Colors.white,
      buttonColor: AppThemeData.lightColorScheme.primary,
      height: 50,
      borderRadius: BorderRadius.circular(12.0),
      onPressed: () async {
        _formStore.validateAll();
        if (_formStore.canLogin) {
          DeviceUtils.hideKeyboard(context);
          _userStore.login(_userNameController.text, _passwordController.text);
        }
      },
    );
  }

  Widget _buildSignInFinger() {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        Icons.fingerprint,
        size: 40.0,
        color: AppThemeData.lightColorScheme.primary,
      ),
    );
  }

  Widget navigate(BuildContext context) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool(Preferences.is_logged_in, true);
    });

    Future.delayed(Duration(milliseconds: 0), () {
      Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.home, (Route<dynamic> route) => false);
    });

    return Container();
  }

  // General Methods:-----------------------------------------------------------
  _showErrorMessage(String message) {
    if (message.isNotEmpty) {
      Future.delayed(Duration(milliseconds: 0), () {
        if (message.isNotEmpty) {
          FlushbarHelper.createError(
            message: message,
            title: AppLocalizations.of(context).translate('home_tv_error'),
            duration: Duration(seconds: 3),
          )..show(context);
        }
      });
    }

    return SizedBox.shrink();
  }

  // dispose:-------------------------------------------------------------------
  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    _userNameController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}
