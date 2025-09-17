import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'core/config/app_routes.dart';
import 'shared/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
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
  const TaxiRutaApp({Key? key}) : super(key: key);

  @override
  ConsumerState<TaxiRutaApp> createState() => _TaxiRutaAppState();
}

class _TaxiRutaAppState extends ConsumerState<TaxiRutaApp> {
  @override
  void initState() {
    super.initState();
    // Inicializar estado de autenticación al arrancar la app
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ref.read(authControllerProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'TaxiRuta',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRoutes.router,
      builder: (context, child) {
        // Configurar responsive design
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}