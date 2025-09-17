import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../state/auth_provider.dart';
import '../../../../shared/widgets/custom_card.dart';
import 'register_screen.dart';

/// Pantalla de login con validación de credenciales
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              
              // Logo y título
              _buildHeader(context),
              const SizedBox(height: 40),
              
              // Formulario de login
              CustomCard(
                backgroundColor: Colors.white,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Iniciar Sesión',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      
                      // Campo de email
                      _buildEmailField(),
                      const SizedBox(height: 16),
                      
                      // Campo de contraseña
                      _buildPasswordField(),
                      const SizedBox(height: 16),
                      
                      // Recordar sesión y forgot password
                      _buildOptionsRow(context),
                      const SizedBox(height: 24),
                      
                      // Mostrar error si existe
                      if (authState.error != null) ...[
                        _buildErrorMessage(authState.error!),
                        const SizedBox(height: 16),
                      ],
                      
                      // Botón de login
                      _buildLoginButton(context, authState.isLoading),
                      const SizedBox(height: 16),
                      
                      // Divisor
                      _buildDivider(),
                      const SizedBox(height: 16),
                      
                      // Login con redes sociales
                      _buildSocialLogin(context),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Link para registro
              _buildRegisterLink(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye el header con logo y título
  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
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
            size: 50,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'TaxiRuta',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          'Tu viaje, nuestra pasión',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white70,
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
          return 'Por favor ingresa tu email';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Por favor ingresa un email válido';
        }
        return null;
      },
    );
  }

  /// Construye el campo de contraseña
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: 'Contraseña',
        hintText: 'Tu contraseña',
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
          return 'Por favor ingresa tu contraseña';
        }
        if (value.length < 6) {
          return 'La contraseña debe tener al menos 6 caracteres';
        }
        return null;
      },
      onFieldSubmitted: (_) => _handleLogin(),
    );
  }

  /// Construye la fila de opciones (recordar y forgot password)
  Widget _buildOptionsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            children: [
              Checkbox(
                value: _rememberMe,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                },
              ),
              const Flexible(
                child: Text('Recordarme'),
              ),
            ],
          ),
        ),
        Flexible(
          child: TextButton(
            onPressed: () {
              // TODO: Implementar forgot password
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Función de recuperación de contraseña próximamente'),
                ),
              );
            },
            child: const Text(
              '¿Olvidaste tu contraseña?',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
      ],
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

  /// Construye el botón de login
  Widget _buildLoginButton(BuildContext context, bool isLoading) {
    return ElevatedButton(
      onPressed: isLoading ? null : _handleLogin,
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
              'Iniciar Sesión',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }

  /// Construye el divisor
  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[300])),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'O continúa con',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[300])),
      ],
    );
  }

  /// Construye los botones de login social
  Widget _buildSocialLogin(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO: Implementar login con Google
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Login con Google próximamente'),
                ),
              );
            },
            icon: const Icon(Icons.g_mobiledata, size: 24),
            label: const Text('Google'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: BorderSide(color: Colors.grey[300]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO: Implementar login con Facebook
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Login con Facebook próximamente'),
                ),
              );
            },
            icon: const Icon(Icons.facebook, size: 24),
            label: const Text('Facebook'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: BorderSide(color: Colors.grey[300]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Construye el link para registro
  Widget _buildRegisterLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¿No tienes cuenta? ',
          style: TextStyle(color: Colors.white70),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const RegisterScreen(),
              ),
            );
          },
          child: const Text(
            'Regístrate aquí',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  /// Maneja el proceso de login
  void _handleLogin() async {
    // Limpiar errores previos
    ref.read(authProvider.notifier).clearError();
    
    if (_formKey.currentState!.validate()) {
      await ref.read(authProvider.notifier).login(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
      
      // Pequeño delay para asegurar que el estado se actualize
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Verificar si el login fue exitoso
      final authState = ref.read(authProvider);
      print('🔍 LOGIN SCREEN: Estado después del login:');
      print('  isAuthenticated: ${authState.isAuthenticated}');
      print('  user: ${authState.user?.fullName}');
      print('  error: ${authState.error}');
      
      if (authState.isAuthenticated && authState.user != null) {
        final user = authState.user!;
        // Navegar según el rol del usuario
        String route;
        if (user.isDriver) {
          route = '/driver/dashboard';
          print('✅ LOGIN SCREEN: Usuario conductor - Navegando a $route');
        } else {
          route = '/passenger/dashboard';
          print('✅ LOGIN SCREEN: Usuario pasajero - Navegando a $route');
        }
        
        if (mounted) {
          context.go(route);
        }
      } else if (authState.error != null) {
        print('❌ LOGIN SCREEN: Error de login: ${authState.error}');
      }
    }
  }
}