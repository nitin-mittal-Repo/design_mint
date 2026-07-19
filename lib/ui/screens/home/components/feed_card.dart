

// ── Feed card ──────────────────────────────────────────────────────────
import 'package:flutter/material.dart';

import '../../../utils/app_theme.dart';
import '../../../widgets/app_textview.dart';
import '../home_screen.dart';
import 'carousel_widget.dart';

class FeedCard extends StatelessWidget {
  const FeedCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.darkGray,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          width: .5,
          color: AppTheme.primaryPeach.withValues(alpha: .2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          // title

          AppTextView(
            heading: 'The 5 Mandatory Soft Skills Engineers Must Have in the Age of AI',
            fontSize: 16,
            maxLines: 3,
          ),



          // description
          AppTextView(
            heading:
            'A senior cloud support engineer and technical interviewer argues that five soft skills'
                ' remain essential for engineers in the AI era: communication that delivers, empathy and '
                'emotional intelligence, adaptability and a learning mindset, trust-building through '
                'productive disagreement, and values-driven ownership and judgment.',
            maxLines: 3,
            textOverflow: TextOverflow.ellipsis,
            fontSize: 12,
            textColor: AppTheme.lightGray,
          ),

          const SizedBox(height: 10),

          // tags
          Wrap(
            spacing: 6,
            runSpacing: 5,
            children: List.generate(
              10,
                  (_) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.darkGray,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    width: .5,
                    color: AppTheme.primaryPeach.withValues(alpha: .2),
                  ),
                ),
                child: AppTextView(heading: '#Flutter', fontSize: 12, textColor: AppTheme.lightGray),
              ),
            ),
          ),

          const SizedBox(height: 5),
          AppTextView(heading: 'Yesterday • 9m read time', fontSize: 12, textColor: AppTheme.lightGray),


          // carousel
          const CarouselWidget(),

          // action bar
          const ActionBar(),
        ],
      ),
    );
  }
}