
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/local/carousel_model.dart';
import '../../../utils/app_theme.dart';
import '../../../widgets/app_textview.dart';
import '../home_provider.dart';

class CarouselWidget extends ConsumerStatefulWidget {
  const CarouselWidget({super.key});

  @override
  ConsumerState<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends ConsumerState<CarouselWidget> {
  final CarouselController _controller = CarouselController();
  int _currentIndex = 0; // ✅ local state instead of hardcoded 0

  @override
  Widget build(BuildContext context) {
    final carouselState = ref.watch(carouselProvider);
    final items = carouselState.items;
    final width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 220,
      child: Stack(
        children: [

          // ✅ wrap with NotificationListener to detect swipe
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollEndNotification) {
                final index = (_controller.offset / width)
                    .round()
                    .clamp(0, items.length - 1);
                if (index != _currentIndex) {
                  setState(() => _currentIndex = index); // ✅ update index
                }
              }
              return false;
            },
            child: CarouselView(
              controller: _controller,
              itemExtent: width,
              reverse: false,
              padding: EdgeInsets.zero,
              enableSplash: true,
              itemSnapping: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              children: items.map((item) => _CarouselSlide(item: item)).toList(),
            ),
          ),

          // ── Slide counter ──────────────────────────────────────
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(6),
              ),
              child: AppTextView(heading: '${_currentIndex + 1} / ${items.length}',
                  fontSize: 12, textColor: AppTheme.white),
            ),
          ),
        ],
      ),
    );
  }
}


// ── Slide ─────────────────────────────────────────────────────────────
class _CarouselSlide extends StatelessWidget {
  final CarouselItem item;
  const _CarouselSlide({required this.item});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(item.url, fit: BoxFit.cover),
        Positioned(
          bottom: 15,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(6),
            ),
            child: AppTextView(heading: item.label, fontSize: 12, textColor: AppTheme.white),
          ),
        ),
      ],
    );
  }
}
