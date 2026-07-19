
import 'package:flutter_riverpod/legacy.dart';

/// Immutable state for the Create Post screen.
class CreatePostState {
  final List<String> imgList;
  final int selectedIndex;
  final bool isAnimating;

  const CreatePostState({
    this.imgList = const [],
    this.selectedIndex = 0,
    this.isAnimating = false,
  });

  CreatePostState copyWith({
    List<String>? imgList,
    int? selectedIndex,
    bool? isAnimating,
  }) {
    return CreatePostState(
      imgList: imgList ?? this.imgList,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isAnimating: isAnimating ?? this.isAnimating,
    );
  }

  static const int maxImages = 5;

  bool get canAddMore => imgList.length < maxImages;

  int get remainingSlots => maxImages - imgList.length;
}

/// Notifier that owns all mutations to [CreatePostState].
///
/// NOTE: This notifier intentionally holds only plain data (paths, indices,
/// flags). Anything that needs `BuildContext` / `vsync` (AnimationController,
/// OverlayEntry, GlobalKeys, AnimatedListState) stays in the widget, which
/// reads/writes this provider at the right points in the animation flow.
class CreatePostNotifier extends StateNotifier<CreatePostState> {
  CreatePostNotifier() : super(const CreatePostState());

  /// Adds a single image path to the end of the list and selects it.
  /// Returns the index at which it was inserted, or null if it was rejected
  /// (list already full).
  int? addImage(String path) {
    if (!state.canAddMore) return null;
    final insertIndex = state.imgList.length;
    state = state.copyWith(
      imgList: [...state.imgList, path],
      selectedIndex: insertIndex,
    );
    return insertIndex;
  }

  /// Removes the image at [index]. Adjusts [selectedIndex] so it stays
  /// in bounds, mirroring the original widget's behavior.
  void removeImageAt(int index) {
    if (index < 0 || index >= state.imgList.length) return;

    final newList = [...state.imgList]..removeAt(index);

    int newSelected = state.selectedIndex;
    if (newSelected >= newList.length) {
      newSelected = newList.isEmpty ? 0 : newList.length - 1;
    }

    state = state.copyWith(imgList: newList, selectedIndex: newSelected);
  }

  /// Removes the currently selected image (mirrors `_deleteSelectedImage`).
  void removeSelectedImage() {
    if (state.imgList.isEmpty) return;
    removeImageAt(state.selectedIndex);
  }

  /// Reorders an image from [oldIndex] to [newIndex] (drag & drop / reorder).
  void reorderImage(int oldIndex, int newIndex) {
    if (oldIndex < 0 ||
        oldIndex >= state.imgList.length ||
        newIndex < 0 ||
        newIndex > state.imgList.length) {
      return;
    }

    final newList = [...state.imgList];
    final item = newList.removeAt(oldIndex);

    var insertIndex = newIndex;
    if (newIndex > oldIndex) insertIndex -= 1;
    newList.insert(insertIndex, item);

    state = state.copyWith(imgList: newList, selectedIndex: insertIndex);
  }

  /// Selects the thumbnail at [index] as the main preview image.
  void selectImage(int index) {
    if (index < 0 || index >= state.imgList.length) return;
    state = state.copyWith(selectedIndex: index);
  }

  /// Toggles the "flying image" animation lock (disables the FAB mid-flight).
  void setAnimating(bool value) {
    state = state.copyWith(isAnimating: value);
  }
}

final createPostProvider =
StateNotifierProvider<CreatePostNotifier, CreatePostState>(
      (ref) => CreatePostNotifier(),
);