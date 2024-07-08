import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:show_you/data/localization/local_keys.dart';
import 'package:show_you/services/cubit/authentication/authentication_cubit.dart';
import 'package:show_you/services/cubit/authentication/authentication_state.dart';
import 'package:show_you/ui/view/loading_animation.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final key = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 50.0, bottom: 25.0),
        child: Form(
          key: key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close),
              ),
              const SizedBox(height: 70),
              Text(
                LocaleKeys.forgotpassword.tr(),
                style: const TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                LocaleKeys.resetpasswordescription.tr(),
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40),
              const SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                obscureText: false,
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return LocaleKeys.emptyEmail.tr();
                  }
                  return null;
                },
                autofocus: false,
                style: const TextStyle(
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  errorStyle: const TextStyle(fontSize: 15),
                  isDense: true,
                  hintText: LocaleKeys.email.tr(),
                  hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder:
                      const OutlineInputBorder(borderSide: BorderSide(color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
              const SizedBox(height: 16),
              const Expanded(child: SizedBox()),
              SizedBox(
                height: MediaQuery.of(context).size.height / 20,
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(20),
                  child: BlocProvider<AuthCubit>(
                    create: (context) => AuthCubit(),
                    child: BlocListener<AuthCubit, AuthState>(
                      listener: (context, state) {
                        if (state is ResetPasswordCompleted) {
                          Navigator.pop(context, true);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text(LocaleKeys.recoverPasswordSuccessfulDescription.tr(), style: TextStyle(color: Theme.of(context).primaryColor)),
                            backgroundColor: Theme.of(context).cardColor,
                          ));
                        } else if (state is ResetPasswordFailed) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text(LocaleKeys.recoverPasswordUnsuccessfulDescription.tr(), style: TextStyle(color: Theme.of(context).primaryColor)),
                            backgroundColor: Theme.of(context).cardColor,
                          ));
                        }
                      },
                      child: BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: () async {
                              if (key.currentState!.validate()) {
                                context.read<AuthCubit>().resetPassword(emailController.text.trim());
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  LocaleKeys.recoverPassword.tr(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                state is ResetPasswordCompliting
                                    ? const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: SizedBox(width: 24, height: 24, child: LoadingAnimation()),
                                      )
                                    : const SizedBox.shrink()
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
