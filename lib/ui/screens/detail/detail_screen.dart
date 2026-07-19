
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/app_theme.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_textview.dart';
import '../../widgets/appbar_backbtn.dart';
import '../../widgets/appbar_gradient.dart';
import '../home/components/carousel_widget.dart';

class DetailScreen extends ConsumerWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppTheme.darkBackground,
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 5,
                  children: [
                    SizedBox(height: 60),

                    Padding(padding: const EdgeInsets.fromLTRB(5, 0, 5, 0), child: const CarouselWidget()),

                    // title
                    AppTextView(
                      heading: 'The 5 Mandatory Soft Skills Engineers Must Have in the Age of AI',
                      fontSize: 16,
                      paddingH: 10,
                      maxLines: 3,
                    ),

                    const SizedBox(height: 5),
                    AppTextView(heading: 'Yesterday • 9m read time', fontSize: 12, textColor: AppTheme.lightGray, paddingH: 10),

                    const SizedBox(height: 2),
                    AppTextView(
                      heading:
                          'A senior cloud support engineer and technical interviewer argues that five soft skills'
                              ' remain essential for engineers in the AI era: communication that delivers, empathy and '
                              'emotional intelligence, adaptability and a learning mindset, trust-building through '
                              'productive disagreement, and values-driven ownership and judgment.' * 2 ,
                      fontSize: 12,
                      paddingH: 10,
                      textColor: AppTheme.lightGray,
                    ),

                    const SizedBox(height: 10),

                    // tags
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 5,
                        children: List.generate(
                          10,
                          (_) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppTheme.darkGray,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(width: .5, color: AppTheme.primaryPeach.withValues(alpha: .2)),
                            ),
                            child: AppTextView(heading: '#Flutter', fontSize: 12, textColor: AppTheme.lightGray),
                          ),
                        ),
                      ),
                    ),
                    
                    // tags
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryPeach.withValues(alpha: .1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(width: .5, color: AppTheme.primaryPeach.withValues(alpha: .2)),
                        ),
                        child: ListView.builder(
                          itemCount: 2,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                             return AppTextView(heading: "https://github.com/nitin-mittal-Repo", fontSize: 12,paddingV: 3,textColor: AppTheme.primaryPeach);
                            }),
                      )
                    ),




                    SizedBox(height: 80),
                  ],
                ),
              ),

              TopGradient(),

              const AppBarBackButton(),

              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: AppButton(onPressed: () {}, title: "Buy Now", width: double.infinity, paddingH: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
