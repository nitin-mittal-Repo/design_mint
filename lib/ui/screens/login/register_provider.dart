

import 'package:flutter_riverpod/legacy.dart';


final registerLoader = StateProvider<bool>((ref) => false);
final isVisible = StateProvider<bool>((ref) => true);