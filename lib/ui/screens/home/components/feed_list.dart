

// ── Feed list ──────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/init/app_routes.dart';
import '../home_provider.dart';
import 'feed_card.dart';

class FeedList extends StatelessWidget {
  final WidgetRef ref;
  const FeedList({super.key, required this.ref});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      padding: const EdgeInsets.only(top: 65),
      itemBuilder: (context, index) => GestureDetector(
          onTap: () async{
            await ref.read(menuProvider.notifier).collapseAndRun((isGoing) {
              if(isGoing){
                if (context.mounted) context.pushNamed(detailScreen);
              }
            });
          },
          child: FeedCard()),
    );
  }
}