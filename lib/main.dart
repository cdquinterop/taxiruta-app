import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/app_routes.dart';
import 'core/lifecycle/app_lifecycle_handler.dart';
import 'firebase_options.dart';
import 'shared/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Configurar orientación de pantalla
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configurar UI del sistema
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    const ProviderScope(
      child: TaxiRutaApp(),
    ),
  );
}

class TaxiRutaApp extends ConsumerStatefulWidget {
  const TaxiRutaApp({super.key});

  @override
  ConsumerState<TaxiRutaApp> createState() => _TaxiRutaAppState();
}

class _TaxiRutaAppState extends ConsumerState<TaxiRutaApp> {
  @override
  Widget build(BuildContext context) {
    return AppLifecycleHandler(
      child: MaterialApp.router(
        title: 'TaxiRuta',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRoutes.router,
        builder: (context, child) {
          // Configurar responsive design
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(
                  MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2)),
            ),
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Inicializar estado de autenticación al arrancar la app
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ref.read(authControllerProvider.notifier).initialize();
    });
  }
}
