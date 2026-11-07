class InputValidators {
  static String? email(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) return 'Введіть електронну пошту';
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(input)) {
      return 'Некоректна електронна адреса';
    }
    return null;
  }

  static String? requiredPassword(String? value) =>
      (value == null || value.isEmpty) ? 'Введіть пароль' : null;

  static String? newPassword(String? value) {
    if (value == null || value.isEmpty) return 'Введіть новий пароль';
    if (value.length < 8 || value.length > 100) return 'Пароль має містити 8–100 символів';
    return null;
  }

  static String? name(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) return 'Введіть ім’я';
    if (input.length > 100) return 'Не більше 100 символів';
    if (!RegExp(r"^[\p{L}\p{M} '\u2019-]+$", unicode: true).hasMatch(input)) {
      return 'Дозволено літери, пробіли, дефіси та апострофи';
    }
    return null;
  }

  static String? httpsImageUrl(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) return null;
    final url = Uri.tryParse(input);
    if (url == null || url.scheme != 'https' || url.host.isEmpty) {
      return 'Вкажіть коректне HTTPS-посилання';
    }
    return null;
  }
}
