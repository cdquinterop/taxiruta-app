import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../shared/constants/app_constants.dart';

/// Widget que maneja el ciclo de vida de la aplicación
/// SIMPLIFICADO: Solo observa estados, NO interfiere con la persistencia de sesión
class AppLifecycleHandler extends ConsumerStatefulWidget {
  final Widget child;

  const AppLifecycleHandler({super.key, required this.child});

  @override
  ConsumerState<AppLifecycleHandler> createState() => _AppLifecycleHandlerState();
}

class _AppLifecycleHandlerState extends ConsumerState<AppLifecycleHandler>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Solo logging, sin interferir con la sesión
    switch (state) {
      case AppLifecycleState.resumed:
        print('📱 LIFECYCLE: App resumed');
        break;
      case AppLifecycleState.paused:
        print('📱 LIFECYCLE: App paused');
        break;
      case AppLifecycleState.detached:
        print('📱 LIFECYCLE: App detached - Session preserved');
        break;
      case AppLifecycleState.inactive:
        print('📱 LIFECYCLE: App inactive');
        break;
      case AppLifecycleState.hidden:
        print('📱 LIFECYCLE: App hidden');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}