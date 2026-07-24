import 'package:design_mint/core/init/app_routes.dart';
import 'package:design_mint/ui/screens/login/register_provider.dart';
import 'package:design_mint/ui/screens/splash/splash_screen.dart';
import 'package:design_mint/ui/widgets/app_button.dart';
import 'package:design_mint/ui/widgets/app_textfield.dart';
import 'package:design_mint/ui/widgets/app_textview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hugeicons/styles/stroke_rounded.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_components.dart';
import '../../utils/app_theme.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
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
    final isSignLoading = ref.watch(registerLoader);
    final ispVisible = ref.watch(isVisible);
    return AppComponent.appScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Hero(
            tag: "logo",
            child: Container(alignment: Alignment.centerLeft, child: Image.asset("assets/images/app_logo.png", height: 120)),
          ),

          AppTextView(heading: "Welcome to Mint", fontSize: 18, paddingH: 20),
          AppTextView(heading: "Create your account", fontSize: 14, paddingH: 20, fontWeight: FontWeight.w300),

          const SizedBox(height: 30),

          AppTextField(controller: nameController, keyboardType: TextInputType.emailAddress, hintText: "Enter your full name", paddingH: 15),

          const SizedBox(height: 10),

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
              onPressed: () {},
              title: "Sign Up",
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
                Future.delayed(Duration(seconds: 2), () {
                  context.goNamed(loginScreen);
                });
              },
              title: "Sign In",
              width: MediaQuery.of(context).size.width * .9,
              paddingH: 15,
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Row(
              children: [
                Flexible(child: Divider(color: Colors.grey)),
                AppTextView(heading: "or", fontSize: 14, paddingH: 20, fontWeight: FontWeight.w300),
                Flexible(child: Divider(color: Colors.grey)),
              ],
            ),
          ),

          20.verticalSpace,
          AppButton(
            onPressed: () {
              FocusManager.instance.primaryFocus!.unfocus();
              context.pushNamed(registerScreen);
            },
            title: "Continue with google",
            width: MediaQuery.of(context).size.width * .9,
            leftIcon: AppAssets.iconGoogle,
            paddingH: 15,
          ),
        ],
      ),
    );
  }
}
