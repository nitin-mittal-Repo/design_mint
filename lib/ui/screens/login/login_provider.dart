
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


// providers.dart
final loginLoader = StateProvider.autoDispose<bool>((ref) => false);
final isVisible = StateProvider<bool>((ref) => true);
final loginProvider = AsyncNotifierProvider<LoginNotifier, void>(LoginNotifier.new);


class LoginNotifier extends AsyncNotifier {
  @override
  void build() {
    // nothing to initialize
  }

  final _supabase = Supabase.instance.client;

  Future<bool> login({required String email, required String password}) async {
    try {
      ref.watch(loginLoader.notifier).state = !ref.watch(loginLoader.notifier).state;
      final result = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (result.user != null && result.session != null) {
        return true;
      } else {
        return false;
      }
    } catch (e, st) {
      debugPrint("Error $e");
      return false;
    } finally {
      ref.watch(loginLoader.notifier).state = false;
    }
  }
}
