import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:show_you/data/localization/local_keys.dart';
import 'package:show_you/services/cubit/authentication/authentication_cubit.dart';
import 'package:show_you/services/cubit/authentication/authentication_state.dart';
import 'package:show_you/ui/page/user_profile_page.dart';
import 'package:show_you/ui/view/loading_animation.dart';
import 'package:show_you/ui/view/login_register_logo.dart';
import 'package:show_you/ui/view/reset_password.dart';

class AuthenticatePage extends StatefulWidget {
  const AuthenticatePage({super.key});

  @override
  State<AuthenticatePage> createState() => _SignUpState();
}

class _SignUpState extends State<AuthenticatePage> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  final authkey = GlobalKey<FormState>();

  var incomingTitle = "";
  var incomingContent = "";
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 10, left: 20, right: 20),
        child: Form(
          key: authkey,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: LoginRegisterTitleLogo(),
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: t1,
                decoration: InputDecoration(
                  hintText: LocaleKeys.email.tr(),
                  hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder:
                      const OutlineInputBorder(borderSide: BorderSide(color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                style: const TextStyle(
                  fontSize: 15,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return LocaleKeys.emptyEmail.tr();
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                obscureText: !passwordVisible,
                keyboardType: TextInputType.text,
                controller: t2,
                decoration: InputDecoration(
                  hintText: LocaleKeys.password.tr(),
                  hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder:
                      const OutlineInputBorder(borderSide: BorderSide(color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(10))),
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                ),
                style: const TextStyle(
                  fontSize: 15,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return LocaleKeys.emptyPassword.tr();
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 25,
              ),
              BlocProvider<AuthCubit>(
                  create: (context) => AuthCubit(),
                  child: BlocListener<AuthCubit, AuthState>(
                    listener: (context, state) async {
                      if (state is SignUpCompleted || state is SignInCompleted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const UserProfilePage()),
                        );
                        if (state is SignUpCompleted && state.user.isNewUser) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(LocaleKeys.newuserdescription.tr())));
                        }
                      }
                    },
                    child: BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return Column(
                          children: [
                            state is SignUpFailed ? Text(state.errorMessage) : const SizedBox.shrink(),
                            state is SignInFailed ? Text(state.errorMessage) : const SizedBox.shrink(),
                            state is SignUpCompliting || state is SignInCompliting ? const LoadingAnimation() : const SizedBox.shrink(),
                            Row(
                              children: [
                                Expanded(
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          if (authkey.currentState!.validate()) {
                                            context.read<AuthCubit>().signInUser(t1.text, t2.text);
                                          }
                                        },
                                        child: Text(
                                          LocaleKeys.authbuttonsignin.tr(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ))),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          if (authkey.currentState!.validate()) {
                                            context.read<AuthCubit>().signUpUser(t1.text, t2.text);
                                          }
                                        },
                                        child: Text(
                                          LocaleKeys.authbuttonsignUp.tr(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ))),
                              ],
                            ),
                            ElevatedButton(
                                onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
                                    ),
                                child: Text(
                                  LocaleKeys.forgotpassword.tr(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ))
                          ],
                        );
                      },
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
