# notas_app

# Notas App con Flutter, Firebase y Bloc

Este proyecto es una aplicación de notas en Flutter que permite:

- **Registro e inicio de sesión** usando Firebase Authentication.
- **Crear, leer, editar y eliminar** notas en Cloud Firestore.
- **Clasificar** las notas por categoría.
- **Buscar** notas.
- **Pruebas unitarias** (AuthBloc, NoteBloc, AuthRepository, NoteRepository).

## Características

1. **Firebase Authentication** (correo y contraseña).
2. **Cloud Firestore** para almacenar notas.
3. **Bloc** (flutter_bloc) para manejar la lógica de estados.
4. **Diseño limpio** con widgets personalizados (CustomTextField, CustomButton, etc.).
5. **Pruebas** usando `bloc_test` y `fake_cloud_firestore`.

## Requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Dart](https://dart.dev/get-dart)
- Una cuenta de [Firebase](https://firebase.google.com/) para configurar la app.

## Cómo ejecutar el proyecto

1. **Clonar el repositorio:**

   Abre la terminal y clona el repositorio en tu máquina:
   ```bash
   git clone https://github.com/TuUsuario/notas_app.git
   
2. **Luego, entra en el directorio del proyecto:**
   ```bash
   cd notas_app
3. **Instalar dependencias:**
   ```bash
   flutter pub get
4. **Ejecutar la aplicación:**
   ```bash
   flutter run
## Autor
**Jose Luis Alvarez Campo** – [@josealvarez](https://github.com/JoseAlvrez)








