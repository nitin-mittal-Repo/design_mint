import 'package:design_mint/core/init/app_routes.dart';
import 'package:design_mint/ui/utils/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
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
  final _formKey = GlobalKey<FormState>();

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
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: "logo",
              child: Container(alignment: Alignment.centerLeft, child: Image.asset(AppAssets.imgLogo, height: 120)),
            ),

            AppTextView(heading: "Welcome to Mint", fontSize: 18, paddingH: 20),

            AppTextView(heading: "Login your account", fontSize: 14, paddingH: 20, fontWeight: FontWeight.w300),

            const SizedBox(height: 30),

            AppTextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              hintText: "Enter your email",
              paddingH: 15,
              validator: (value) {
                if (emailController.text.trim().isEmpty) {
                  return "email_required";
                }
                if (!emailController.text.contains("@")) {
                  return "invalid_email";
                }
                return null;
              },
            ),

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

                  if (_formKey.currentState!.validate()) {
                    Future.delayed(Duration(seconds: 2), () {
                      context.goNamed(homeScreen);
                    });
                  } else {
                    ref.read(loginLoader.notifier).state = false;
                  }
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
      ),
    );
  }
}
