import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/custom_card.dart';
import '../state/auth_provider.dart';

/// Pantalla de registro con selección de rol (conductor/pasajero)
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  String _selectedRole = 'PASSENGER';

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Crear Cuenta',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Logo
              _buildHeader(context),
              const SizedBox(height: 24),

              // Formulario de registro
              CustomCard(
                backgroundColor: Colors.white,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Únete a TaxiRuta',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // Selección de rol
                      _buildRoleSelection(),
                      const SizedBox(height: 16),

                      // Campos de información personal
                      Row(
                        children: [
                          Expanded(child: _buildFirstNameField()),
                          const SizedBox(width: 12),
                          Expanded(child: _buildLastNameField()),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _buildEmailField(),
                      const SizedBox(height: 16),

                      _buildPhoneField(),
                      const SizedBox(height: 16),

                      _buildPasswordField(),
                      const SizedBox(height: 16),

                      _buildConfirmPasswordField(),
                      const SizedBox(height: 16),

                      // Términos y condiciones
                      _buildTermsCheckbox(),
                      const SizedBox(height: 24),

                      // Mostrar error si existe
                      if (authState.error != null) ...[
                        _buildErrorMessage(authState.error!),
                        const SizedBox(height: 16),
                      ],

                      // Botón de registro
                      _buildRegisterButton(context, authState.isLoading),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Divisor con texto
              _buildDivider(),
              const SizedBox(height: 24),

              // Botón de Google Sign-In
              _buildGoogleSignInButton(context, isLoading: authState.isLoading),
              const SizedBox(height: 24),

              // Link para login
              _buildLoginLink(context),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Construye el campo de confirmar contraseña
  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscureConfirmPassword,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: 'Confirmar contraseña',
        hintText: 'Repite tu contraseña',
        prefixIcon: const Icon(Icons.lock_outlined),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Confirma tu contraseña';
        }
        if (value != _passwordController.text) {
          return 'Las contraseñas no coinciden';
        }
        return null;
      },
      onFieldSubmitted: (_) => _handleRegister(),
    );
  }

  /// Construye el divisor con texto "o regístrate con"
  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.white.withOpacity(0.5),
            thickness: 1,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'o regístrate con',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.white.withOpacity(0.5),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  /// Construye el campo de email
  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Correo electrónico',
        hintText: 'tu@email.com',
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ingresa tu email';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Email inválido';
        }
        return null;
      },
    );
  }

  /// Construye el mensaje de error
  Widget _buildErrorMessage(String error) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[600], size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              error,
              style: TextStyle(
                color: Colors.red[600],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construye el campo de nombre
  Widget _buildFirstNameField() {
    return TextFormField(
      controller: _firstNameController,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Nombre',
        hintText: 'Tu nombre',
        prefixIcon: const Icon(Icons.person_outline),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ingresa tu nombre';
        }
        if (value.length < 2) {
          return 'Mínimo 2 caracteres';
        }
        return null;
      },
    );
  }

  /// Construye el botón de Google Sign-In
  Widget _buildGoogleSignInButton(BuildContext context,
      {required bool isLoading}) {
    return ElevatedButton.icon(
      onPressed: isLoading ? null : _handleGoogleSignIn,
      icon: Image.network(
        'https://www.google.com/favicon.ico',
        width: 24,
        height: 24,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.g_mobiledata,
              size: 32, color: Color(0xFF4285F4));
        },
      ),
      label: const Text(
        'Continuar con Google',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
    );
  }

  /// Construye el header con logo
  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(
            Icons.local_taxi,
            size: 40,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Comienza tu viaje',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  /// Construye el campo de apellido
  Widget _buildLastNameField() {
    return TextFormField(
      controller: _lastNameController,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Apellido',
        hintText: 'Tu apellido',
        prefixIcon: const Icon(Icons.person_outline),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ingresa tu apellido';
        }
        if (value.length < 2) {
          return 'Mínimo 2 caracteres';
        }
        return null;
      },
    );
  }

  /// Construye el link para login
  Widget _buildLoginLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '¿Ya tienes cuenta? ',
          style: TextStyle(color: Colors.white70),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Inicia sesión',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  /// Construye el campo de contraseña
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Contraseña',
        hintText: 'Mínimo 8 caracteres',
        prefixIcon: const Icon(Icons.lock_outlined),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ingresa tu contraseña';
        }
        if (value.length < 8) {
          return 'Mínimo 8 caracteres';
        }
        return null;
      },
    );
  }

  /// Construye el campo de teléfono
  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Teléfono',
        hintText: '+51 999 999 999',
        prefixIcon: const Icon(Icons.phone_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ingresa tu teléfono';
        }
        if (value.length < 9) {
          return 'Mínimo 9 dígitos';
        }
        return null;
      },
    );
  }

  /// Construye el botón de registro
  Widget _buildRegisterButton(BuildContext context, bool isLoading) {
    return ElevatedButton(
      onPressed: isLoading || !_acceptTerms ? null : _handleRegister,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Text(
              'Crear Cuenta',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }

  /// Construye la selección de rol
  Widget _buildRoleSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quiero ser:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Pasajero'),
                subtitle: const Text('Buscar viajes'),
                value: 'PASSENGER',
                groupValue: _selectedRole,
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Conductor'),
                subtitle: const Text('Ofrecer viajes'),
                value: 'DRIVER',
                groupValue: _selectedRole,
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Construye el checkbox de términos y condiciones
  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _acceptTerms,
          onChanged: (value) {
            setState(() {
              _acceptTerms = value ?? false;
            });
          },
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _acceptTerms = !_acceptTerms;
              });
            },
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black87),
                children: [
                  const TextSpan(text: 'Acepto los '),
                  TextSpan(
                    text: 'Términos y Condiciones',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(text: ' y la '),
                  TextSpan(
                    text: 'Política de Privacidad',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Maneja el proceso de Google Sign-In con selección de rol
  void _handleGoogleSignIn() async {
    // Limpiar errores previos
    ref.read(authProvider.notifier).clearError();

    try {
      print('🔍 REGISTER SCREEN (Google): Intentando login primero...');

      // 1. Primero intentar hacer login (por si el usuario ya existe)
      await ref.read(authProvider.notifier).loginWithGoogle();

      // Pequeño delay para asegurar que el estado se actualize
      await Future.delayed(const Duration(milliseconds: 100));

      final authState = ref.read(authProvider);

      // 2. Si el login fue exitoso, el usuario ya existía
      if (authState.isAuthenticated && authState.user != null) {
        print('✅ REGISTER SCREEN (Google): Usuario existente - Login exitoso');
        print('  user: ${authState.user?.fullName}');
        print('  role: ${authState.user?.role}');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Bienvenido de nuevo! Sesión iniciada con Google'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          // Navegar según el rol del usuario
          final userRole = authState.user?.role;
          if (userRole == 'DRIVER') {
            context.go('/driver/dashboard');
          } else {
            context.go('/passenger/dashboard');
          }
        }
      }
      // 3. Si hay error, podría ser que el usuario no existe, intentar registrar
      else if (authState.error != null) {
        print(
            '⚠️ REGISTER SCREEN (Google): Login falló, intentando registro...');
        print('  error: ${authState.error}');

        // Limpiar el error del intento de login
        ref.read(authProvider.notifier).clearError();

        // Intentar registrar con el rol seleccionado
        await ref.read(authProvider.notifier).registerWithGoogle(
              role: _selectedRole,
            );

        await Future.delayed(const Duration(milliseconds: 100));

        final registerState = ref.read(authProvider);

        if (registerState.isAuthenticated && registerState.user != null) {
          print(
              '✅ REGISTER SCREEN (Google): Registro exitoso como ${registerState.user?.role}');

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text('¡Registro exitoso con Google! Bienvenido a TaxiRuta'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );

            // Navegar según el rol del usuario
            final userRole = registerState.user?.role;
            if (userRole == 'DRIVER') {
              context.go('/driver/dashboard');
            } else {
              context.go('/passenger/dashboard');
            }
          }
        } else if (registerState.error != null) {
          print(
              '❌ REGISTER SCREEN (Google): Error de registro: ${registerState.error}');
        }
      }
    } catch (e) {
      print('❌ REGISTER SCREEN (Google): Excepción: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al autenticarse con Google: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Maneja el proceso de registro
  void _handleRegister() async {
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes aceptar los términos y condiciones'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Limpiar errores previos
    ref.read(authProvider.notifier).clearError();

    if (_formKey.currentState!.validate()) {
      await ref.read(authProvider.notifier).register(
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            password: _passwordController.text.trim(),
            role: _selectedRole,
          );

      // Si el registro fue exitoso, mostrar mensaje y navegar
      final authState = ref.read(authProvider);
      if (authState.isAuthenticated) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Registro exitoso! Bienvenido a TaxiRuta'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          // Navegar según el rol del usuario
          final userRole = authState.user?.role;
          if (userRole == 'DRIVER') {
            context.go('/driver/dashboard');
          } else {
            context.go('/passenger/dashboard');
          }
        }
      }
    }
  }
}
