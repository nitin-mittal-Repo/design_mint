import 'package:design_mint/core/init/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hugeicons/styles/stroke_rounded.dart';
import '../../utils/app_components.dart';
import '../../utils/app_theme.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_textfield.dart';
import '../../widgets/app_textview.dart';
import '../splash/splash_screen.dart';
import 'login_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSignLoading = ref.watch(loginLoader);
    final ispVisible = ref.watch(isVisible);

    return AppComponent.appScaffold(
      backButtonVisible: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: "logo",
            child: Container(alignment: Alignment.centerLeft, child: Image.asset("assets/images/app_logo.png", height: 120)),
          ),

          AppTextView(heading: "Welcome to Mint", fontSize: 18, paddingH: 20),

          AppTextView(heading: "Login your account", fontSize: 14, paddingH: 20, fontWeight: FontWeight.w300),

          const SizedBox(height: 30),

          AppTextField(controller: emailController, keyboardType: TextInputType.emailAddress, hintText: "Enter your email", paddingH: 15),

          const SizedBox(height: 10),

          AppTextField(
            controller: passwordController,
            keyboardType: TextInputType.emailAddress,
            hintText: "Enter your password",
            obscureText: ispVisible,
            suffixIcon: GestureDetector(
              onTap: () => ref.watch(isVisible.notifier).state = !ref.watch(isVisible.notifier).state,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Icon(ispVisible ? Icons.visibility : Icons.visibility_off, size: 22, color: AppTheme.primaryPeach),
              ),
            ),
            paddingH: 15,
          ),

          const SizedBox(height: 30),

          Center(
            child: AppButton(
              onPressed: () {
                FocusManager.instance.primaryFocus!.unfocus();
                ref.read(loginLoader.notifier).state = true;
                Future.delayed(Duration(seconds: 2), () {
                  context.goNamed(homeScreen);
                });
              },
              title: "Sign In",
              isLoading: isSignLoading,
              width: MediaQuery.of(context).size.width * .9,
              paddingH: 15,
              buttonColor: AppTheme.primaryPeach,
              textColor: AppColors.darkBackground,
            ),
          ),

          const SizedBox(height: 10),
          Center(
            child: AppButton(
              onPressed: () {
                FocusManager.instance.primaryFocus!.unfocus();
                context.pushNamed(registerScreen);
              },
              title: "Sign Up",
              width: MediaQuery.of(context).size.width * .9,
              paddingH: 15,
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(40, 30, 40, 0),
            child: Row(
              children: [
                Flexible(child: Divider(color: Colors.grey)),
                AppTextView(heading: "or", fontSize: 14, paddingH: 20, fontWeight: FontWeight.w300),
                Flexible(child: Divider(color: Colors.grey)),
              ],
            ),
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: AppComponent.bgContainer(
                child: HugeIcon(icon: HugeIconsStrokeRounded.google, color: AppColors.white),
                radius: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
