


class CarouselState {
  final int currentIndex;
  final List<CarouselItem> items;

  const CarouselState({
    this.currentIndex = 0,
    this.items = const [],
  });

  CarouselState copyWith({int? currentIndex, List<CarouselItem>? items}) {
    return CarouselState(
      currentIndex: currentIndex ?? this.currentIndex,
      items: items ?? this.items,
    );
  }
}

class CarouselItem {
  final String url;
  final String label;

  const CarouselItem({required this.url, required this.label});
}

class MenuState {
  final bool isExpanded;

  const MenuState({this.isExpanded = false});

  MenuState copyWith({bool? isExpanded}) {
    return MenuState(isExpanded: isExpanded ?? this.isExpanded);
  }
}