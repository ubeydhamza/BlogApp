import 'package:blog_app_project/core/common/widgets/loader.dart';
import 'package:blog_app_project/core/theme/app_pallete.dart';
import 'package:blog_app_project/core/utils/show_snackbar.dart';
import 'package:blog_app_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app_project/features/auth/presentation/pages/login_page.dart';
import 'package:blog_app_project/features/auth/presentation/widgets/auth_field.dart';
import 'package:blog_app_project/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:blog_app_project/features/blog/presantation/pages/blog_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
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
                } else if (state is AuthSuccess) {
                  Navigator.pushAndRemoveUntil(
                      context, BlogPage.route(), (route) => false);
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
                        'Sign Up.',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 30),
                      //Name textfield
                      AuthField(
                        controller: nameController,
                        hintText: 'Name',
                        isObscure: false,
                      ),

                      const SizedBox(height: 10),

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
                        butonText: "Sign Up",
                        onTop: () {
                          if (formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                  AuthSignUp(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                      name: nameController.text.trim()),
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
                              builder: (_) => const LoginPage(),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                              text: 'Already have an account?  ',
                              style: Theme.of(context).textTheme.titleMedium,
                              children: [
                                TextSpan(
                                  text: 'Sign In Here',
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
