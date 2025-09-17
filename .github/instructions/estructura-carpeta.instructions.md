---
applyTo: '**'
---
·Estructura de carpetas
Crea una estructura de carpetas clara y organizada para tu proyecto. Aquí tienes un ejemplo de cómo podrías estructurar tu proyecto:

```
lib/
│
├── main.dart                     // Entry point
│
├── core/                         // Código reutilizable en toda la app
│   ├── config/                   // Configuración global (theme, constants, env)
│   │   ├── app_theme.dart
│   │   ├── app_routes.dart
│   │   └── constants.dart
│   │
│   ├── error/                    // Manejo de errores global
│   │   └── exceptions.dart
│   │
│   ├── network/                  // Cliente HTTP, interceptores, etc.
│   │   └── api_client.dart
│   │
│   └── utils/                    // Utilidades generales
│       └── validators.dart
│
├── features/                     // Cada módulo de la app separado por dominio
│   ├── auth/                     // Módulo de autenticación
│   │   ├── data/                 // Capa de acceso a datos (API, local storage)
│   │   │   ├── models/           // Modelos que vienen del backend
│   │   │   │   └── user_model.dart
│   │   │   └── auth_api.dart
│   │   │
│   │   ├── domain/               // Lógica de negocio
│   │   │   ├── entities/         // Entidades puras
│   │   │   │   └── user.dart
│   │   │   ├── repositories/     // Contratos abstractos
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/         // Casos de uso (login, register, etc.)
│   │   │       └── login_user.dart
│   │   │
│   │   └── presentation/         // UI
│   │       ├── pages/            // Pantallas
│   │       │   └── login_page.dart
│   │       ├── widgets/          // Widgets reutilizables
│   │       └── state/            // Estado (Provider, Riverpod, Bloc, etc.)
│   │           └── auth_controller.dart
│   │
│   ├── trips/                    // Módulo de viajes
│   │   ├── data/
│   │   │   ├── models/trip_model.dart
│   │   │   └── trips_api.dart
│   │   ├── domain/
│   │   │   ├── entities/trip.dart
│   │   │   ├── repositories/trip_repository.dart
│   │   │   └── usecases/create_trip.dart
│   │   └── presentation/
│   │       ├── pages/trip_list_page.dart
│   │       ├── widgets/trip_card.dart
│   │       └── state/trip_controller.dart
│   │
│   ├── bookings/                 // Módulo de reservas
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── user/                     // Módulo de perfil usuario
│       ├── data/
│       ├── domain/
│       └── presentation/
│
└── shared/                       // Cosas compartidas entre features
    ├── widgets/                  // Botones, inputs, layouts comunes
    └── styles/                   // Tipografía, colores
