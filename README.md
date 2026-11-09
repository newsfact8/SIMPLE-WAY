# Backend structure (planned)

Suggested first backend: Firebase (Authentication, Firestore, Cloud Functions) or a small Node.js API.

Collections / tables:
- users: id, displayName, phone, createdAt
- categories: id, name, enabled
- providers: id, categoryId, name, status, baseUrl
- offers: id, providerId, title, price, currency, deeplink, fetchedAt, expiresAt
- click_events: id, userId, offerId, clickedAt

API outline:
- GET /categories
- GET /search?category=&query=
- GET /offers?category=&query=
- POST /click-events

Only display provider offers from authorized APIs/feeds. Cache with a short expiry and clearly show when a price was last checked. Never fabricate live prices.
