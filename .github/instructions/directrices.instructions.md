---
applyTo: '**'
---
Directrices y tareas Flutter según endpoints (MVP TaxiRuta)
🔐 Auth / User

Endpoints:

POST /api/auth/register → Registro usuario

POST /api/auth/login → Login JWT

GET /api/users/{id} → Perfil usuario

PUT /api/users/{id} → Actualizar perfil

Tareas:

📂 Data

Crear auth_api.dart → implementar métodos registerUser(), loginUser().

Crear user_api.dart → implementar getUserProfile(id), updateUser(id, data).

Definir UserModel (con Freezed + JSON parsing).

📂 Domain

Definir User (entity pura).

Crear repositorios abstractos: AuthRepository, UserRepository.

Crear casos de uso (usecases): RegisterUser, LoginUser, GetUserProfile, UpdateUser.

📂 Presentation

Crear pantallas:

RegisterPage, LoginPage, ProfilePage, EditProfilePage.

Controladores de estado (auth_controller.dart, user_controller.dart) con Riverpod/Bloc.

Validaciones de formularios (email, password, etc.).

Guardar y manejar token JWT (en secure_storage).

Manejar errores de API (mostrar Snackbars o Dialogs).

🚗 Trips

Endpoints:

POST /api/trips → Crear viaje (conductor)

GET /api/trips → Listar viajes filtrados (origin/destination/date)

GET /api/trips/{id} → Detalle de viaje

PUT /api/trips/{id} → Actualizar viaje

DELETE /api/trips/{id} → Cancelar viaje

Tareas:

📂 Data

Crear trips_api.dart con métodos: createTrip(), getTrips(filter), getTripById(id), updateTrip(id, data), deleteTrip(id).

Definir TripModel.

📂 Domain

Crear entidad Trip.

Repositorio TripRepository.

Use cases: CreateTrip, GetTrips, GetTripDetails, UpdateTrip, DeleteTrip.

📂 Presentation

Pantallas:

CreateTripPage, TripListPage, TripDetailPage, EditTripPage.

Widgets: TripCard, TripForm.

Estado: trip_controller.dart.

Filtrado por origen/destino/fecha en UI.

📑 Bookings / Reservations

Endpoints:

POST /api/trips/{tripId}/bookings → Solicitar asiento (pasajero)

PUT /api/trips/{tripId}/bookings/{bookingId}/accept → Aceptar reserva (conductor)

PUT /api/trips/{tripId}/bookings/{bookingId}/reject → Rechazar reserva (conductor)

GET /api/trips/{tripId}/bookings → Lista de pasajeros (conductor)

GET /api/users/{userId}/bookings → Reservas del pasajero

DELETE /api/trips/{tripId}/bookings/{bookingId} → Cancelar reserva

Tareas:

📂 Data

Crear bookings_api.dart con métodos createBooking(), acceptBooking(), rejectBooking(), getBookingsByTrip(), getBookingsByUser(), deleteBooking().

Definir BookingModel.

📂 Domain

Crear entidad Booking.

Repositorio BookingRepository.

Use cases: CreateBooking, AcceptBooking, RejectBooking, GetBookingsByTrip, GetBookingsByUser, DeleteBooking.

📂 Presentation

Pantallas:

BookingRequestPage, PassengerListPage, MyBookingsPage.

Widgets: BookingCard.

Estado: booking_controller.dart.

Validar reglas: pasajero puede cancelar su reserva, conductor puede aceptar/rechazar.

🌍 Core y Shared (soporte general)

Tareas generales obligatorias:

Configuración de rutas con GoRouter (app_routes.dart).

Manejo de sesión JWT con flutter_secure_storage.

Configuración de Dio en api_client.dart con interceptores (agregar token).

Theming centralizado (app_theme.dart).

Widgets compartidos (shared/widgets/button.dart, shared/widgets/input_field.dart).

Manejo de errores centralizado (exceptions.dart).

Tests unitarios para usecases y repositories.

Tests de integración para los endpoints críticos (login, crear viaje, reservar).

Los endpoint a consumir son los sigueintes:
{
	"info": {
		"_postman_id": "taxiruta-backend-api",
		"name": "TaxiRuta Backend API",
		"description": "Colección completa de endpoints para el sistema TaxiRuta - gestión de viajes compartidos con autenticación JWT",
		"schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json",
		"_exporter_id": "taxiruta"
	},
	"item": [
		{
			"name": "Authentication",
			"item": [
				{
					"name": "Register User",
					"request": {
						"method": "POST",
						"header": [
							{
								"key": "Content-Type",
								"value": "application/json"
							}
						],
						"body": {
							"mode": "raw",
							"raw": "{\n  \"email\": \"newuser@taxiruta.com\",\n  \"password\": \"password123\",\n  \"name\": \"New User\",\n  \"role\": \"PASAJERO\",\n  \"phone\": \"+1234567890\"\n}"
						},
						"url": {
							"raw": "{{baseUrl}}/api/auth/register",
							"host": [
								"{{baseUrl}}"
							],
							"path": [
								"api",
								"auth",
								"register"
							]
						},
						"description": "Registrar un nuevo usuario en el sistema"
					},
					"response": []
				},
				{
					"name": "Login",
					"event": [
						{
							"listen": "test",
							"script": {
								"exec": [
									"if (pm.response.code === 200) {",
									"    const responseJson = pm.response.json();",
									"    pm.environment.set(\"jwt_token\", responseJson.token);",
									"    pm.environment.set(\"user_id\", responseJson.user.id);",
									"}"
								],
								"type": "text/javascript"
							}
						}
					],
					"request": {
						"method": "POST",
						"header": [
							{
								"key": "Content-Type",
								"value": "application/json"
							}
						],
						"body": {
							"mode": "raw",
							"raw": "{\n  \"email\": \"driver@taxiruta.com\",\n  \"password\": \"password123\"\n}"
						},
						"url": {
							"raw": "{{baseUrl}}/api/auth/login",
							"host": [
								"{{baseUrl}}"
							],
							"path": [
								"api",
								"auth",
								"login"
							]
						},
						"description": "Autenticar usuario y obtener token JWT"
					},
					"response": []
				}
			]
		},
		{
			"name": "Users",
			"item": [
				{
					"name": "Get User Profile",
					"request": {
						"method": "GET",
						"header": [
							{
								"key": "Authorization",
								"value": "Bearer {{jwt_token}}"
							}
						],
						"url": {
							"raw": "{{baseUrl}}/api/users/{{user_id}}",
							"host": [
								"{{baseUrl}}"
							],
							"path": [
								"api",
								"users",
								"{{user_id}}"
							]
						},
						"description": "Obtener perfil del usuario autenticado"
					},
					"response": []
				},
				{
					"name": "Update User Profile",
					"request": {
						"method": "PUT",
						"header": [
							{
								"key": "Content-Type",
								"value": "application/json"
							},
							{
								"key": "Authorization",
								"value": "Bearer {{jwt_token}}"
							}
						],
						"body": {
							"mode": "raw",
							"raw": "{\n  \"name\": \"Updated User Name\",\n  \"phone\": \"+9876543210\"\n}"
						},
						"url": {
							"raw": "{{baseUrl}}/api/users/{{user_id}}",
							"host": [
								"{{baseUrl}}"
							],
							"path": [
								"api",
								"users",
								"{{user_id}}"
							]
						},
						"description": "Actualizar perfil del usuario"
					},
					"response": []
				}
			]
		},
		{
			"name": "Trips",
			"item": [
				{
					"name": "Get All Trips",
					"request": {
						"method": "GET",
						"header": [],
						"url": {
							"raw": "{{baseUrl}}/api/trips",
							"host": [
								"{{baseUrl}}"
							],
							"path": [
								"api",
								"trips"
							]
						},
						"description": "Listar todos los viajes disponibles (público)"
					},
					"response": []
				},
				{
					"name": "Search Trips",
					"request": {
						"method": "GET",
						"header": [],
						"url": {
							"raw": "{{baseUrl}}/api/trips?origin=Downtown&destination=Airport&departureDate=2025-09-17T10:00:00",
							"host": [
								"{{baseUrl}}"
							],
							"path": [
								"api",
								"trips"
							],
							"query": [
								{
									"key": "origin",
									"value": "Downtown"
								},
								{
									"key": "destination",
									"value": "Airport"
								},
								{
									"key": "departureDate",
									"value": "2025-09-17T10:00:00"
								}
							]
						},
						"description": "Buscar viajes con filtros"
					},
					"response": []
				},
				{
					"name": "Get Trip Details",
					"request": {
						"method": "GET",
						"header": [],
						"url": {
							"raw": "{{baseUrl}}/api/trips/1",
							"host": [
								"{{baseUrl}}"
							],
							"path": [
								"api",
								"trips",
								"1"
							]
						},
						"description": "Obtener detalles de un viaje específico"
					},
					"response": []
				},
				{
					"name": "Create Trip (Driver Only)",
					"request": {
						"method": "POST",
						"header": [
							{
								"key": "Content-Type",
								"value": "application/json"
							},
							{
								"key": "Authorization",
								"value": "Bearer {{jwt_token}}"
							}
						],
						"body": {
							"mode": "raw",
							"raw": "{\n  \"driverId\": {{user_id}},\n  \"origin\": \"Central Station\",\n  \"destination\": \"Business District\",\n  \"departureTime\": \"2025-09-17T14:30:00\",\n  \"availableSeats\": 4,\n  \"price\": 20.00\n}"
						},
						"url": {
							"raw": "{{baseUrl}}/api/trips",
							"host": [
								"{{baseUrl}}"
							],
							"path": [
								"api",
								"trips"
							]
						},
						"description": "Crear un nuevo viaje (solo conductores)"
					},
					"response": []
				},
				{
					"name": "Update Trip (Driver Only)",
					"request": {
						"method": "PUT",
						"header": [
							{
								"key": "Content-Type",
								"value": "application/json"
							},
							{
								"key": "Authorization",
								"value": "Bearer {{jwt_token}}"
							}
						],
						"body": {
							"mode": "raw",
							"raw": "{\n  \"driverId\": {{user_id}},\n  \"origin\": \"Central Station\",\n  \"destination\": \"Business District\",\n  \"departureTime\": \"2025-09-17T15:00:00\",\n  \"availableSeats\": 3,\n  \"price\": 22.00\n}"
						},
						"url": {
							"raw": "{{baseUrl}}/api/trips/1",
							"host": [
								"{{baseUrl}}"
							],
							"path": [
								"api",
								"trips",
								"1"
							]
						},
						"description": "Actualizar un viaje existente (solo el conductor propietario)"
					},
					"response": []
				},
				{
					"name": "Cancel Trip (Driver Only)",
					"request": {
						"method": "DELETE",
						"header": [
							{
								"key": "Authorization",
								"value": "Bearer {{jwt_token}}"
							}
						],
						"url": {
							"raw": "{{baseUrl}}/api/trips/1",
							"host": [
								"{{baseUrl}}"
							],
							"path": [
								"api",
								"trips",
								"1"
							]
						},
						"description": "Cancelar un viaje (solo el conductor propietario)"
					},
					"response": []
				}
			]
		},
		{
			"name": "Bookings",
			"item": [
				{
					"name": "Create Booking (Passenger Only)",
					"request": {
						"method": "POST",
						"header": [
							{
								"key": "Content-Type",
								"value": "application/json"
							},
							{
								"key": "Authorization",
								"value": "Bearer {{jwt_token}}"
							}
						],
						"body": {
							"mode": "raw",
							"raw": "{\n  \"tripId\": 1,\n  \"passengerId\": {{user_id}}\n}"
						},
						"url": {
							"raw": "{{baseUrl}}/api/trips/1/bookings",
							"host": [
								"{{baseUrl}}"
							],
							"path": [
								"api",
								"trips",
								"1",
								"bookings"
							]
						},
						"description": "Reservar un asiento en un viaje (solo pasajeros)"
					},
					"response": []
				},
				{
					"name": "Get Trip Bookings (Driver Only)",
					"request": {
						"method": "GET",
						"header": [
							{
								"key": "Authorization",
								"value": "Bearer {{jwt_token}}"
							}
						],
						"url": {
							"raw": "{{baseUrl}}/api/trips/1/bookings",
							"host": [
								"{{baseUrl}}"
							],
							"path": [
								"api",
								"trips",
								"1",
								"bookings"
							]
						},
						"description": "Ver todas las reservas de un viaje (solo conductor del viaje)"
					},
					"response": []
				},
				{
					"name": "Update Booking Status (Driver Only)",
					"request": {
						"method": "PUT",
						"header": [
							{
								"key": "Authorization",
								"value": "Bearer {{jwt_token}}"
							}
						],
						"url": {
							"raw": "{{baseUrl}}/api/trips/1/bookings/1?status=CONFIRMED",
							"host": [
								"{{baseUrl}}"
							],
							"path": [
								"api",
								"trips",
								"1",
								"bookings",
								"1"
							],
							"query": [
								{
									"key": "status",
									"value": "CONFIRMED",
									"description": "PENDING, CONFIRMED, REJECTED, CANCELLED"
								}
							]
						},
						"description": "Actualizar estado de una reserva (solo conductor del viaje)"
					},
					"response": []
				},
				{
					"name": "Cancel Booking",
					"request": {
						"method": "DELETE",
						"header": [
							{
								"key": "Authorization",
								"value": "Bearer {{jwt_token}}"
							}
						],
						"url": {
							"raw": "{{baseUrl}}/api/trips/1/bookings/1",
							"host": [
								"{{baseUrl}}"
							],
							"path": [
								"api",
								"trips",
								"1",
								"bookings",
								"1"
							]
						},
						"description": "Cancelar una reserva (pasajero o conductor)"
					},
					"response": []
				}
			]
		}
	],
	"event": [
		{
			"listen": "prerequest",
			"script": {
				"type": "text/javascript",
				"exec": [
					""
				]
			}
		},
		{
			"listen": "test",
			"script": {
				"type": "text/javascript",
				"exec": [
					""
				]
			}
		}
	],
	"variable": [
		{
			"key": "baseUrl",
			"value": "http://localhost:8080",
			"type": "string"
		},
		{
			"key": "jwt_token",
			"value": "",
			"type": "string"
		},
		{
			"key": "user_id",
			"value": "",
			"type": "string"
		}
	]
}


