# Ejemplos de Peticiones HTTP

Esta es una aplicación Flutter que muestra ejemplos de peticiones con http y Dio librería de Dart/Flutter ademas de que se muestra una lista de contactos con los integratantes del equipo que elaboraron el proyecto y permite ver detalles sobre cada contacto, incluyendo la capacidad de realizar llamadas telefónicas y enviar mensajes SMS.

## Contenidos del Proyecto

- **DioScreen**: Muestra imágenes de gatos obtenidas a través de la API de The Cat API usando el paquete Dio.
- **HttpScreen**: Muestra imágenes de gatos obtenidas a través de la API de The Cat API usando el paquete `http`.
- **ContactListScreen**: Muestra una lista de contactos en una cuadrícula.
- **ContactDetailScreen**: Muestra los detalles de un contacto, incluyendo opciones para realizar llamadas y enviar mensajes SMS.
- **CallService**: Servicio para realizar llamadas telefónicas.
- **SmsService**: Servicio para enviar mensajes SMS.

## Configuración

1. **Clonar el Repositorio**

   Clona este repositorio a tu máquina local usando el siguiente comando:

   ```bash
   git clone https://github.com/tu_usuario/tu_repositorio.git
   ```

2. **Instalar Dependencias**

   Navega al directorio del proyecto y ejecuta el siguiente comando para instalar las dependencias:

   ```bash
   flutter pub get
   ```

3. **Configurar Permisos**

   - **Android**: Asegúrate de que los permisos necesarios están en el archivo `AndroidManifest.xml`. Por ejemplo:

     ```xml
     <uses-permission android:name="android.permission.CALL_PHONE"/>
     <uses-permission android:name="android.permission.SEND_SMS"/>
     ```

   - **iOS**: Agrega los permisos necesarios en el archivo `Info.plist`. Por ejemplo:

     ```xml
     <key>NSCameraUsageDescription</key>
     <string>Esta aplicación necesita acceso a la cámara</string>
     <key>NSPhotoLibraryUsageDescription</key>
     <string>Esta aplicación necesita acceso a la galería de fotos</string>
     ```

4. **Ejecutar la Aplicación**

   Conecta un dispositivo o inicia un emulador y ejecuta el siguiente comando:

   ```bash
   flutter run
   ```

## Estructura del Proyecto

- **lib/**
  - **domain/models/**: Contiene los modelos de datos (e.g., `Contact`).
  - **presentation/screens/**: Contiene las pantallas de la aplicación (e.g., `DioScreen`, `HttpScreen`, `ContactListScreen`, `ContactDetailScreen`).
  - **presentation/widgets/**: Contiene los widgets personalizados (e.g., `ContactAvatar`, `ContactAction`, `ContactInfo`).
  - **services/**: Contiene los servicios para llamadas y mensajes SMS (e.g., `CallService`, `SmsService`).
  - **main.dart**: Punto de entrada de la aplicación.

## Paquetes Usados

- `dio`: Para realizar peticiones HTTP.
- `http`: Para realizar peticiones HTTP.
- `flutter_staggered_grid_view`: Para mostrar una cuadrícula de diseño escalonado.
- `flutter_phone_direct_caller`: Para realizar llamadas telefónicas directamente desde la aplicación.
- `direct_sms`: Para enviar mensajes SMS.
