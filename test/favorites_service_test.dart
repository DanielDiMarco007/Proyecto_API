import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:api/services/favorites_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('FavoritesService loads and toggles correctly', () async {
    // start with empty prefs
    SharedPreferences.setMockInitialValues({});
    final svc = FavoritesService.instance;

    await svc.load();
    expect(svc.favorites.value, isEmpty);

    const id = 'test-image-url';
    await svc.toggle(id);
    expect(svc.favorites.value.contains(id), isTrue);

    await svc.toggle(id);
    expect(svc.favorites.value.contains(id), isFalse);
  });
}
