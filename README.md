# Дала тарихы

Қазақстан тарихы бойынша жаттау ойыны (тақырыптық тест 11 және 12): бөлімдер, карточкалар, тест, XP, 16 атақ, жетістіктер, рейтинг.

Сайт: https://arsenchulanov1-code.github.io/Kaztarih-/

## Общая база данных и рейтинг (Firebase)

Пока `firebase-config.js` пустой, аккаунты и прогресс хранятся только на одном устройстве.
После подключения Firebase: вход с любого телефона, **все игроки видят друг друга в рейтинге**, есть админ‑панель.

Код сайта уже готов — нужно только создать бесплатный проект (≈5 минут, тариф Spark бесплатный):

1. Открой https://console.firebase.google.com → **Create project** → любое имя (например `dala-tarihy`). Google Analytics можно выключить.
2. **Build → Authentication → Get started → Sign-in method → Email/Password → Enable → Save.**
3. **Authentication → Settings → Authorized domains → Add domain:** `arsenchulanov1-code.github.io`
4. **Build → Firestore Database → Create database** → регион `europe-west` (или любой) → **Start in production mode**.
5. Во вкладке **Rules** удали всё, вставь содержимое файла `firestore.rules` из этого репозитория → **Publish**.
6. **⚙ Project settings → General → Your apps → значок `</>` (Web)** → любое имя → **Register app**.
   Скопируй значения из `firebaseConfig` в `firebase-config.js` (apiKey, authDomain, projectId, …) и сделай commit.
   Эти ключи не секретные — их можно хранить в публичном репозитории, доступ защищают правила.
7. Готово: открой сайт, зарегистрируйся — ты появишься в общем рейтинге.

### Как стать админом
1. Зарегистрируйся на сайте.
2. Firebase Console → **Authentication → Users** → скопируй свой **User UID**.
3. **Firestore Database → Data → Start collection** → ID коллекции `admins` → Document ID = твой UID → поле `by` (string) любое → Save.
4. Обнови сайт — появится кнопка админ‑панели. Дальше других админов можно назначать прямо из панели.

### Что хранится и кто видит
| Коллекция | Что внутри | Кто читает | Кто пишет |
|---|---|---|---|
| `players` | имя, XP, атақ, звёзды, сколько выучено | **все** (рейтинг) | сам игрок (с проверкой данных) или админ |
| `progress` | полный прогресс, ошибки | только сам игрок и админы | сам игрок или админ |
| `admins` | список админов | вошедшие игроки | только админы |

Правила проверяют данные рейтинга: имя до 24 символов, XP не больше 1 000 000, никаких лишних полей — чужой результат изменить нельзя.

Деплой правил через CLI (необязательно): `npx firebase-tools deploy --only firestore:rules --project <projectId>`.
