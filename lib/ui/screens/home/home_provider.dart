
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/models/local/carousel_model.dart';


// providers/providers.dart
// ── Menu ─────────────────────────────────────────────────────────────
final menuProvider = StateNotifierProvider<MenuNotifier, MenuState>((ref) {
  return MenuNotifier();
});

// ── Carousel ─────────────────────────────────────────────────────────
final carouselProvider = StateNotifierProvider<CarouselNotifier, CarouselState>((ref) {
  return CarouselNotifier();
});

// ── Search query ─────────────────────────────────────────────────────
final searchQueryProvider = StateProvider<String>((ref) => '');



class CarouselNotifier extends StateNotifier<CarouselState> {
  CarouselNotifier()
      : super(
    CarouselState(
      items: const [
        CarouselItem(
          url: 'https://thumbs.dreamstime.com/b/beautiful-rain-forest-ang-ka-nature-trail-doi-inthanon-national-park-thailand-36703721.jpg',
          label: 'Rain Forest',
        ),
        CarouselItem(
          url: 'https://cdn.pixabay.com/photo/2017/07/24/19/57/tiger-2535888_640.jpg',
          label: 'Bengal Tiger',
        ),
      ],
    ),
  );

  void setIndex(int index) {
    if (index < 0 || index >= state.items.length) return;
    state = state.copyWith(currentIndex: index);
  }

  void next() {
    final next = (state.currentIndex + 1) % state.items.length;
    state = state.copyWith(currentIndex: next);
  }

  void previous() {
    final prev = (state.currentIndex - 1 + state.items.length) % state.items.length;
    state = state.copyWith(currentIndex: prev);
  }
}

class MenuNotifier extends StateNotifier<MenuState> {
  MenuNotifier() : super(const MenuState());

  void toggle() => state = state.copyWith(isExpanded: !state.isExpanded);

  void collapse() => state = state.copyWith(isExpanded: false);

  void expand() => state = state.copyWith(isExpanded: true);


  Future<void> collapseAndRun(Function(bool isGoing) action) async {
    if (state.isExpanded) {
      collapse();
      await Future.delayed(const Duration(milliseconds: 200));
      action(false);
      return;
    }
    action(true);
  }
}

