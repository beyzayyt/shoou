import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:show_you/services/cubit/authentication/authentication_cubit.dart';
import 'package:show_you/services/cubit/authentication/authentication_state.dart';
import 'package:show_you/ui/user_profile_form_page.dart';

class AuthenticatePage extends StatefulWidget {
  const AuthenticatePage({Key? key}) : super(key: key);

  @override
  State<AuthenticatePage> createState() => _SignUpState();
}

class _SignUpState extends State<AuthenticatePage> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();

  var incomingTitle = "";
  var incomingContent = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(9.0),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: MediaQuery.of(context).size.height / 2,
          margin: const EdgeInsets.fromLTRB(0, 90, 0, 0),
          child: Center(
              child: Column(
            children: [
              TextFormField(
                cursorColor: Colors.amber,
                keyboardType: TextInputType.emailAddress,
                controller: t1,
                decoration: InputDecoration(
                  hintText: "E-mail",
                  hintStyle: Theme.of(context).textTheme.titleMedium,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor), borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                cursorColor: Colors.amber,
                keyboardType: TextInputType.text,
                controller: t2,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: Theme.of(context).textTheme.subtitle1,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor), borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              BlocProvider<AuthCubit>(
                  create: (context) => AuthCubit(),
                  child: BlocListener<AuthCubit, AuthState>(
                    listener: (context, state) async {
                      if (state is SignUpCompleted || state is SignInCompleted) {
                        if (state is SignUpCompleted && state.user.isNewUser) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(content: Text("Please add your several informations and let us know you!")));
                        }

                        // If user get success from sign up or sign in, navigate to account page.
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const UserProfileFormPage()),
                        );
                      }
                    },
                    child: BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return Column(
                          children: [
                            state is SignUpFailed ? Text(state.errorMessage) : const SizedBox.shrink(),
                            state is SignUpCompliting
                                ? SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: Lottie.asset(
                                      'assets/lottie/loading_animation.json',
                                      fit: BoxFit.fill,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            ElevatedButton(onPressed: () => context.read<AuthCubit>().signUpUser(t1.text, t2.text), child: Text('Sign Up')),
                            ElevatedButton(onPressed: () => context.read<AuthCubit>().signInUser(t1.text, t2.text), child: Text('Sign in')),
                          ],
                        );
                      },
                    ),
                  ))
            ],
          )),
        ),
      ),
    );
  }
}
