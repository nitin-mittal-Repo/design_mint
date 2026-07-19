
import 'package:design_mint/core/init/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_theme.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_textview.dart';
import 'components/onboarding_indicator.dart';
import 'onboarding_provider.dart';


class OnboardingScreen extends ConsumerWidget{
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var pageNumber = ref.watch(currentPage);
    var content = ref.watch(contentList);
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [




            Align(
              alignment: AlignmentGeometry.bottomCenter,
              child: Card(
                margin: EdgeInsets.all(18),
                color: AppTheme.darkGray.withValues(alpha: .7),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(12, 20, 12, 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [

                      SizedBox(
                        width: 100,
                        child: OnboardingProgressIndicator(
                          totalScreens: 4,
                          currentIndex: pageNumber,
                        ),
                      ),

                      SizedBox(height: 5),

                      AppTextView(heading: content[pageNumber].title, fontSize: 24,fontWeight: FontWeight.w800),

                      AppTextView(heading: content[pageNumber].subTitle, fontSize: 14),

                      SizedBox(height: 8),

                      AppButton(onPressed: () {
                        final maxIndex = content.length - 1;
                        if (pageNumber < maxIndex) {
                          pageNumber++;
                          ref.read(currentPage.notifier).state = pageNumber;
                        } else {
                          context.goNamed(loginScreen);
                        }
                      }, title: pageNumber != 4 ? "Get Started" : "Start Minting" ,width: double.infinity),

                      Container(
                        alignment: Alignment.center,
                          width: double.infinity,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                              style: ButtonStyle(
                               visualDensity: VisualDensity(vertical: -4)
                              ),
                              onPressed: () => context.goNamed(loginScreen),
                              icon: AppTextView(heading: "Skip", fontSize: 12))),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
