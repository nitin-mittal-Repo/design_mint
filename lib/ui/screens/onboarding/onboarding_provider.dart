
import 'package:flutter_riverpod/legacy.dart';
import 'components/content_model.dart';



final currentPage = StateProvider<int>((ref) => 0);

final contentList = StateProvider<List<ContentModel>>((ref) {
  return [
    ContentModel(title: "Design. Share. Earn.", subTitle: "Turn your UI designs into income. Welcome to DesignMint."),
    ContentModel(title: "Upload Your Designs", subTitle: "Share your UI screens, kits, and components with a community that values good design."),
    ContentModel(title: "Get Paid for Your Creativity", subTitle: "Every download, purchase, or view brings you closer to real earnings. No more designing for free."),
    ContentModel(title: "Join a Community of Creators", subTitle: "Thousands of designers are already minting their ideas into income. Your turn. CTA button: Get Started / Start Minting"),
  ];
});





