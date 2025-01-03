import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chato/authentication/presentation/components/Forms/sign_in_form/sign_in_form.dart';
import 'package:chato/authentication/presentation/components/Forms/sign_up_form/sign_up_form.dart';
import 'package:chato/authentication/presentation/components/social_accounts_/social_account_login.dart';
import 'package:chato/authentication/presentation/controllers/authentication_controller.dart';
import 'package:chato/channel/presentation/screens/channel_screen.dart';

class AuthenticationScreen extends ConsumerStatefulWidget {
  const AuthenticationScreen({super.key});

  String get loginRouteName => '/authentication/sign-in';

  String get registerRouteName => '/authentication/sign-up';

  @override
  AuthenticationScreenState createState() => AuthenticationScreenState();
}

class AuthenticationScreenState extends ConsumerState<AuthenticationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController? _controller;
  bool isLogin = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _controller!.forward();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium!;
    ref.listen<AuthenticationState>(
      authenticationControllerProvider,
          (previous, next) async {

        if (next.exception != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.exception!.toString())),
          );
        }
        if (next.user != null) {
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ChannelScreen(),
            ),
          );
        }
      },
    );
    Widget content = isLogin ? const SignInForm() : const SignUpForm();
    return WillPopScope(
      onWillPop: () {
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else {
          exit(0);
        }
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        body: FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1)
              .animate(_controller!)
              .drive(CurveTween(curve: Curves.easeInOut)),
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 250,
                  ),
                ),
                IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: content, // Dynamically sizes the container
                    ),
                  ),
                ),
                const SocialAccountsLogin(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      isLogin
                          ? 'Don\'t have an account? '
                          : 'Already have an account? ',
                      style: bodyMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: Text(
                        isLogin ? 'Sign Up' : 'Sign In',
                        style: bodyMedium.copyWith(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
