import 'package:design_mint/ui/utils/mixin_component.dart';
import 'package:design_mint/ui/widgets/app_button.dart';
import 'package:design_mint/ui/widgets/app_textfield.dart';
import 'package:design_mint/ui/widgets/app_textview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/app_theme.dart';
import '../../widgets/appbar_backbtn.dart';
import '../../widgets/appbar_gradient.dart';
import 'dart:async';
import 'dart:math' as math;
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'create_post_provider.dart';


class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen>
    with TickerProviderStateMixin, MixinComponent {
  final GlobalKey _mainImageKey = GlobalKey();
  final GlobalKey _listContainerKey = GlobalKey();
  final GlobalKey<AnimatedListState> _thumbListKey = GlobalKey<AnimatedListState>();

  OverlayEntry? _flyingEntry;

  Future<File?> pickImageFromGallery() async {
    final hasPermission = await requestGalleryPermission();
    if (!hasPermission) {
      return null;
    }

    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  Future<bool> requestGalleryPermission() async {
    PermissionStatus status;

    if (Platform.isAndroid) {
      // Android 13+ uses Permission.photos, older uses Permission.storage
      status = await Permission.photos.request();
      if (status.isDenied) {
        status = await Permission.storage.request();
      }
    } else {
      status = await Permission.photos.request();
    }

    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      // User denied permanently ? guide them to app settings
      await openAppSettings();
      return false;
    } else {
      return false;
    }
  }

  Future<void> _addImagesWithAnimation() async {
    final isAnimating = ref.read(createPostProvider).isAnimating;
    if (isAnimating) return;

    final remainingSlots = ref.read(createPostProvider).remainingSlots;
    if (remainingSlots <= 0) return;

    final hasPermission = await requestGalleryPermission();
    if (!mounted || !hasPermission) return;

    final picker = ImagePicker();
    final List<XFile> picked = await picker.pickMultiImage();
    if (!mounted || picked.isEmpty) return;

    if (picked.length > remainingSlots) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Only $remainingSlots image(s) added ? max 5 reached')),
      );
    }

    final toAdd = picked.take(remainingSlots).map((x) => x.path).toList();

    // Fly them in one at a time, in order.
    for (final path in toAdd) {
      await _flyOneImageIntoList(path);
    }
  }

  Future<void> _flyOneImageIntoList(String path) async {
    final notifier = ref.read(createPostProvider.notifier);

    if (ref.read(createPostProvider).imgList.isEmpty) {
      notifier.addImage(path);
      return;
    }

    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;

    final mainRenderObject = _mainImageKey.currentContext?.findRenderObject();
    final listRenderObject = _listContainerKey.currentContext?.findRenderObject();

    if (mainRenderObject is! RenderBox || listRenderObject is! RenderBox) {
      final insertIndex = ref.read(createPostProvider).imgList.length;
      notifier.addImage(path);
      _thumbListKey.currentState?.insertItem(insertIndex, duration: const Duration(milliseconds: 300));
      return;
    }

    final mainBox = mainRenderObject;
    final listBox = listRenderObject;

    notifier.setAnimating(true);

    final startOffset = mainBox.localToGlobal(Offset.zero);
    final startSize = mainBox.size;

    final thumbWidth = MediaQuery.of(context).size.width * .15;
    final thumbHeight = MediaQuery.of(context).size.height * .085;

    final listOffset = listBox.localToGlobal(Offset.zero);
    final currentLength = ref.read(createPostProvider).imgList.length;
    final endTopLeft = Offset(
      listOffset.dx + 2 + (currentLength * (thumbWidth + 4)),
      listOffset.dy + ((listBox.size.height - thumbHeight) / 2),
    );

    final startCenter = startOffset + Offset(startSize.width / 2, startSize.height / 2);
    final endCenter = endTopLeft + Offset(thumbWidth / 2, thumbHeight / 2);

    final midX = (startCenter.dx + endCenter.dx) / 2;
    final arcLift = (startCenter.dy - endCenter.dy).abs() * 0.5 + 40;
    final controlPoint = Offset(midX, math.min(startCenter.dy, endCenter.dy) - arcLift);

    // IMPORTANT: local controller, created fresh for THIS flight only.
    final controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 550));
    final curved = CurvedAnimation(parent: controller, curve: Curves.easeInOutCubic);

    final overlay = Overlay.of(context);

    _flyingEntry = OverlayEntry(
      builder: (context) {
        return AnimatedBuilder(
          animation: curved,
          builder: (context, child) {
            final t = curved.value;
            final oneMinusT = 1 - t;

            final center = Offset(
              oneMinusT * oneMinusT * startCenter.dx + 2 * oneMinusT * t * controlPoint.dx + t * t * endCenter.dx,
              oneMinusT * oneMinusT * startCenter.dy + 2 * oneMinusT * t * controlPoint.dy + t * t * endCenter.dy,
            );

            final width = startSize.width + (thumbWidth - startSize.width) * t;
            final height = startSize.height + (thumbHeight - startSize.height) * t;
            final rotation = math.sin(t * math.pi) * 0.12;
            final opacity = t < 0.75 ? 1.0 : 1.0 - ((t - 0.75) / 0.25);

            return Positioned(
              left: center.dx - width / 2,
              top: center.dy - height / 2,
              width: width,
              height: height,
              child: Opacity(
                opacity: opacity.clamp(0.0, 1.0),
                child: Transform.rotate(
                  angle: rotation,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8 + (2 * (1 - t))),
                    child: Image.file(File(path), fit: BoxFit.cover),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    overlay.insert(_flyingEntry!);

    Future.delayed(const Duration(milliseconds: 410), () {
      if (!mounted) return;
      final insertIndex = ref.read(createPostProvider).imgList.length;
      notifier.addImage(path);
      _thumbListKey.currentState?.insertItem(insertIndex, duration: const Duration(milliseconds: 300));
    });

    await controller.forward();

    _flyingEntry?.remove();
    _flyingEntry = null;
    controller.dispose(); // safe: this controller is local to this call only
    notifier.setAnimating(false);
  }

  void _deleteSelectedImage() {
    final state = ref.read(createPostProvider);
    if (state.imgList.isEmpty) return;

    final removedIndex = state.selectedIndex;
    final removedPath = state.imgList[removedIndex];

    ref.read(createPostProvider.notifier).removeImageAt(removedIndex);

    _thumbListKey.currentState?.removeItem(
      removedIndex,
          (context, animation) => _buildThumbnail(removedPath, removedIndex, animation),
      duration: const Duration(milliseconds: 320),
    );
  }

  Widget _buildThumbnail(String item, int index, Animation<double> animation) {
    return DragTarget<int>(
      onWillAccept: (fromIndex) => fromIndex != index,
      onAccept: (fromIndex) => _reorderItem(fromIndex, index),
      builder: (context, candidateData, rejectedData) {
        final isTarget = candidateData.isNotEmpty;
        return LongPressDraggable<int>(
          data: index,
          feedback: Material(child: _thumbnailContent(item, index: index)),
          childWhenDragging: Opacity(opacity: 0.3, child: _thumbnailContent(item, index: index)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: EdgeInsets.symmetric(horizontal: isTarget ? 8 : 2),
            child: _thumbnailContent(item, index: index),
          ),
        );
      },
    );
  }

  Widget _thumbnailContent(String item, {required int index}) {
    final selectedIndex = ref.watch(createPostProvider.select((s) => s.selectedIndex));
    return Container(
      width: MediaQuery.of(context).size.width * .15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: selectedIndex == index ? 2 : 0),
        image: DecorationImage(image: FileImage(File(item)), fit: BoxFit.cover),
      ),
    );
  }

  void _reorderItem(int fromIndex, int toIndex) {
    final state = ref.read(createPostProvider);
    final item = state.imgList[fromIndex];

    // Removal animation, then let the provider handle the actual reorder.
    _thumbListKey.currentState?.removeItem(
      fromIndex,
          (context, animation) => _buildThumbnail(item, fromIndex, animation),
      duration: const Duration(milliseconds: 200),
    );

    ref.read(createPostProvider.notifier).reorderImage(fromIndex, toIndex);

    final insertIndex = fromIndex < toIndex ? toIndex : toIndex;
    _thumbListKey.currentState?.insertItem(insertIndex, duration: const Duration(milliseconds: 200));
  }

  @override
  Widget build(BuildContext context) {
    final createPostState = ref.watch(createPostProvider);
    final imgList = createPostState.imgList;
    final selectedIndex = createPostState.selectedIndex;
    final isAnimating = createPostState.isAnimating;

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              children: [
                const SizedBox(height: 70),

                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Container(
                    key: _mainImageKey,
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * .2,
                    decoration: BoxDecoration(
                      border: Border.all(width: .5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
                          child: imgList.isNotEmpty
                              ? Image.file(File(imgList[selectedIndex]), key: ValueKey(imgList[selectedIndex]))
                              : const Column(
                            key: ValueKey('empty'),
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Icon(Icons.upload), Text("upload a image"), Text("max. 5 image you can add")],
                          ),
                        ),
                        if (imgList.isNotEmpty)
                          Align(
                            alignment: Alignment.topRight,
                            child: InkWell(
                              borderRadius: const BorderRadius.all(Radius.circular(6)),
                              onTap: _deleteSelectedImage,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.all(5),
                                child: const Icon(Icons.delete, color: Colors.black),
                              ),
                            ),
                          ),
                        if (imgList.length < 5)
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              width: 40,
                              height: 40,
                              margin: const EdgeInsets.all(10),
                              child: FloatingActionButton(
                                onPressed: isAnimating ? null : _addImagesWithAnimation,
                                backgroundColor: isAnimating ? Colors.grey : null,
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                child: const Icon(Icons.upload),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                if (imgList.isNotEmpty)
                  Container(
                    key: _listContainerKey,
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * .09,
                    padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 3),
                    decoration: BoxDecoration(
                      border: Border.all(width: .5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ReorderableListView.builder(
                      scrollDirection: Axis.horizontal,
                      buildDefaultDragHandles: false,
                      itemCount: imgList.length,
                      proxyDecorator: (child, index, animation) {
                        return Material(color: Colors.transparent, borderRadius: BorderRadius.circular(8), child: child);
                      },
                      onReorder: (oldIndex, newIndex) {
                        if (newIndex > oldIndex) newIndex -= 1;
                        ref.read(createPostProvider.notifier).reorderImage(oldIndex, newIndex);
                      },
                      itemBuilder: (context, index) {
                        final item = imgList[index];
                        return ReorderableDragStartListener(
                          key: ValueKey(item),
                          index: index,
                          child: GestureDetector(
                            onTap: () {
                              ref.read(createPostProvider.notifier).selectImage(index);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              child: _thumbnailContent(item, index: index),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                const SizedBox(height: 50),
                const AppTextField(hintText: "Title", paddingH: 10),
                const SizedBox(height: 10),
                const AppTextField(hintText: "Description", minLines: 5, maxLines: 8, paddingH: 10),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Flexible(child: AppTextField(hintText: "Price", paddingH: 10)),
                    bgContainer(child: const AppTextView(heading: "Free", fontSize: 14, paddingH: 12, paddingV: 12)),
                    const SizedBox(width: 10),
                  ],
                ),
                const SizedBox(height: 10),
                const AppTextField(hintText: "Tags", paddingH: 10),
                const SizedBox(height: 10),
                const AppTextField(hintText: "Link (Only github url)", paddingH: 10),

                const SizedBox(height: 10),
                bgContainer(
                  marginH: 10,
                  paddingH: 10,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.check_box_outlined, color: AppTheme.primaryPeach.withValues(alpha: .5)),
                              const AppTextView(heading: "Public", fontSize: 14, paddingH: 12, paddingV: 12),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.check_box_outline_blank, color: AppTheme.primaryPeach.withValues(alpha: .5)),
                              const AppTextView(heading: "Private", fontSize: 14, paddingH: 12, paddingV: 12),
                            ],
                          ),
                        ],
                      ),
                      const AppTextView(
                        heading: "Note: Please ensure your GitHub token is valid before proceeding.",
                        fontSize: 12,
                        paddingV: 10,
                        textColor: AppTheme.red,
                      ),
                      const AppTextField(hintText: "Valid Access Token"),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 50),

                AppButton(
                  onPressed: () {},
                  title: "Create Post",
                  width: double.infinity,
                  paddingV: 10,
                  color: AppTheme.primaryPeach,
                  textColor: Colors.black,
                  paddingH: 10,
                ),

                const SizedBox(height: 10),
              ],
            ),

            const TopGradient(),
            const AppBarBackButton(),
          ],
        ),
      ),
    );
  }
}