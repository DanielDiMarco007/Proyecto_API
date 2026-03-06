# Proyecto_API
# Proyecto_API

Aplicación Flutter para explorar películas con lista y detalle, diseñada para demostración y entrega final de UI/UX.

Este `README.md` documenta cómo ejecutar el proyecto, dependencias importantes, la estructura del código y los cambios relevantes implementados.

---

## Estado del proyecto
- Branch activa: `oswal-1`
- Fecha: 5 de marzo de 2026
- Estado: Estable para pruebas manuales. Se corrigieron errores críticos y se mejoró la UI del detalle.

## Resumen
`Proyecto_API` es una aplicación Flutter que muestra un catálogo de películas (título, año, director, poster, rating y sinopsis) y una pantalla de detalle profesional con soporte para:

- Vista en lista y cuadrícula (persistida por preferencia del usuario)
- Búsqueda en tiempo real
- Favoritos persistentes (SharedPreferences)
- Imágenes cacheadas con placeholders (shimmer)
- Detalle con `SliverAppBar`, hero image, botón "Ver trailer" y acciones (favorito/compartir)

El objetivo fue corregir un crash reportado (Hero duplicado) y mejorar la presentación visual y la experiencia de usuario.

## Características principales

- Alternar vista lista/cuadrícula (preferencia guardada con la clave `isGrid` en `SharedPreferences`).
- Favoritos persistentes por URL/id con `FavoritesService` (clave `favorites_v1`).
- Imágenes con `cached_network_image` y placeholders con `shimmer`.
- Pantalla de detalle profesional con `SliverAppBar`, hero transition, botón de trailer (abre URL externa) y microinteracciones.
- Uso de `ValueNotifier` para cambios reactivos de favoritos.

## Dependencias relevantes

- flutter (SDK)
- cached_network_image
- shimmer
- shared_preferences
- flutter_rating_bar
- url_launcher

Nota: `share_plus` fue valorado pero no fue introducido debido a conflictos de resolución de dependencias en el entorno actual; actualmente la acción de compartir usa el portapapeles como fallback.

## Estructura de archivos importante

- `lib/main.dart` — Pantalla principal: listado (lista/cuadrícula), búsqueda, filtros, persistencia de vista y navegación al detalle.
- `lib/detalle_screen.dart` — Pantalla de detalle: `SliverAppBar`, hero image, play overlay con halo animado, rating y acciones.
- `lib/services/favorites_service.dart` — Servicio con `ValueNotifier<Set<String>>` que persiste en `SharedPreferences`.
- `test/favorites_service_test.dart` — Prueba unitaria básica para `FavoritesService`.
- `pubspec.yaml` — Dependencias y posibles overrides (p. ej. pin de `win32` localmente).

## Claves de persistencia

- `isGrid` — bool en `SharedPreferences` que guarda la preferencia de vista (lista vs cuadrícula).
- `favorites_v1` — clave que `FavoritesService` usa para persistir los favoritos (conjunto de strings, normalmente URLs o IDs).

## Cómo ejecutar (desarrollo)

Requisitos mínimos:

- Tener Flutter instalado y configurado. Se desarrolló con versiones recientes de Flutter/Dart; adapte si su entorno usa otra versión.
- Para ejecutar en desktop Linux: dependencias del SDK para Linux.

Comandos útiles (Linux, bash):

```bash
# instalar dependencias
flutter pub get

# ejecutar en modo debug en Linux
flutter run -d linux

# ejecutar en Android (con dispositivo/emulador conectado)
flutter run -d android

# correr tests unitarios
flutter test

# construir release para Android
flutter build apk --release

# construir app para Linux
flutter build linux
```

## Cambios notables y decisiones de diseño

- Se corrigió el crash: "There are multiple heroes that share the same tag within a subtree".
	- Causa: duplicación de `Hero` en el detalle y la presencia simultánea de subárboles con `Hero`s durante la transición de vista.
	- Solución: eliminar el `Hero` duplicado en la variante de layout ancho del detalle y simplificar el cambio de vista para garantizar que solo un subárbol con `Hero`s esté activo.

- `FavoritesService`:
	- Implementado como singleton con `ValueNotifier<Set<String>>` y persistencia en `SharedPreferences`.
	- Provee `load()`, `toggle(String id)`, `isFavorite(String id)` y notifica listeners.

- Imágenes: reemplazadas por `CachedNetworkImage` y placeholders `Shimmer` para mejorar percepción de rendimiento.

- UI detalle: `SliverAppBar` con hero image, overlay de play con halo/pulse, rating y chips informativos.

## Known issues y notas de entorno

- En algunos entornos Linux puede aparecer un mensaje de advertencia desde ATK/Wayland similar a:
	`Atk-CRITICAL **: atk_socket_embed: assertion 'plug_id != NULL' failed` — es un warning del entorno de ejecución (no del código) y no bloquea la ejecución.
- Se usó el portapapeles como fallback para compartir en lugar de `share_plus` por compatibilidad.

## Testing

- Ejecutar `flutter test` para ejecutar pruebas incluidas. Actualmente hay una prueba unitaria para `FavoritesService`.

## Próximos pasos recomendados

1. Reintroducir animaciones de transición entre lista y cuadrícula con seguridad (usar `HeroMode` para desactivar `Hero`s en el subárbol saliente o transiciones personalizadas).
2. Añadir pruebas widget para `HomeScreen` y `DetalleScreen`.
3. Añadir soporte de reproducción embebida para trailers (`video_player` o WebView) si desea ver trailers dentro de la app.
4. Mejorar accesibilidad (más `Semantics`, roles, y contraste).

## Cómo contribuir

1. Cree una rama a partir de `oswal-1`.
2. Haga cambios y confirme con mensajes claros.
3. Abra un pull request describiendo el objetivo y los pasos para reproducir.

## Licencia

Agregue aquí la licencia que prefiera (por ejemplo MIT) o indique restricciones de uso.

---

Si quieres, puedo:

- Añadir capturas de pantalla/video (sube las imágenes a `assets/` y las enlazo).
- Hacer el README bilingüe (español/inglés).
- Automáticamente crear un commit sugerido y preparar el push.




