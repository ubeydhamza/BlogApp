import 'package:blog_app_project/core/common/widgets/loader.dart';
import 'package:blog_app_project/core/theme/app_pallete.dart';
import 'package:blog_app_project/core/utils/show_snackbar.dart';
import 'package:blog_app_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app_project/features/auth/presentation/pages/signup_page.dart';
import 'package:blog_app_project/features/auth/presentation/widgets/auth_field.dart';
import 'package:blog_app_project/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthFailure) {
                  showSnackBar(context, state.message);
                }
              },
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const Loader();
                }
                return Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // SignIn text
                      const Text(
                        'Sign In.',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 30),

                      //Email textfield
                      AuthField(
                        controller: emailController,
                        hintText: 'Email',
                        isObscure: false,
                      ),
                      const SizedBox(height: 10),

                      //Password Textfield
                      AuthField(
                        controller: passwordController,
                        hintText: 'Password',
                        isObscure: true,
                      ),
                      const SizedBox(height: 20),

                      //SignIn Button
                      AuthGradientButton(
                        butonText: "Sign In",
                        onTop: () {
                          if (formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                  AuthSignIn(
                                      email: emailController.text,
                                      password: passwordController.text),
                                );
                          }
                        },
                      ),
                      const SizedBox(height: 20),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignUpPage(),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                              text: 'Dont have an account?  ',
                              style: Theme.of(context).textTheme.titleMedium,
                              children: [
                                TextSpan(
                                  text: 'Sign Up Here',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: AppPallete.gradient2,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ]),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
