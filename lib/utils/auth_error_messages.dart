import 'package:firebase_auth/firebase_auth.dart';

String friendlyAuthError(Object error) {
  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'invalid-email': return 'Некоректна електронна адреса.';
      case 'email-already-in-use': return 'Цю адресу вже використовує інший обліковий запис.';
      case 'weak-password': return 'Пароль недостатньо надійний.';
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found': return 'Не вдалося увійти. Перевірте email і пароль.';
      case 'user-disabled': return 'Цей обліковий запис вимкнено.';
      case 'too-many-requests': return 'Забагато спроб. Спробуйте пізніше.';
      case 'network-request-failed': return 'Немає з’єднання з мережею. Спробуйте ще раз.';
      case 'requires-recent-login': return 'Для цієї дії необхідно повторно підтвердити вхід.';
      case 'not-authenticated': return 'Спочатку увійдіть у застосунок.';
      case 'missing-email': return 'Обліковий запис не підтримує вхід за паролем.';
      case 'operation-not-allowed': return 'Цю операцію не дозволено в налаштуваннях Firebase.';
      case 'expired-action-code': return 'Термін дії посилання закінчився.';
      case 'invalid-action-code': return 'Посилання недійсне або вже використане.';
      default: return 'Не вдалося виконати операцію. Спробуйте ще раз.';
    }
  }
  return 'Сталася помилка. Перевірте підключення й повторіть спробу.';
}
