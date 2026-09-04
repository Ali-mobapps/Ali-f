# 💎 Dynetix: The Elite A-to-Z Ecosystem
> **A Comprehensive Engineering & Business Walkthrough**

---

## 🏗️ 1. Core Architecture (The Foundation)
The app is built using a **Modular Feature-First Architecture** with a centralized **Core** layer for cross-cutting concerns.

### 📁 `lib/core/` (System Engines)
*   **`ai/`**: Integrated with **Google Gemini 1.5 Flash**. Processes natural language queries about Dynetix services and courses.
*   **`services/`**:
    *   **PDF Service**: Generates professional invoices using the `pdf` and `printing` libraries.
    *   **DeepLink Service**: Handles `dynetix://app` links for smart navigation from notifications.
    *   **Offline Service**: Uses **Hive (NoSQL)** for local data persistence and action queuing.
*   **`notifications/`**: Implements **Firebase FCM V1** with OAuth 2.0. Handles foreground alerts and background broadcasts.
*   **`theme/` & `l10n/`**: Powers the **Obsidian/Champagne** themes and **English/Urdu** translations.

---

## 🔐 2. User Authentication & Security
### 📁 `lib/features/auth/`
*   **Intelligent Routing**: Automatically redirects users based on their role stored in Supabase.
*   **Master Admin Security**: Hardcoded oversight for `info@dynetixhub.com`.
*   **Self-Service Security**: In-app password updates and account deletion logic (fully compliant with Play Store).

---

## 💼 3. The Customer Journey (A to Z)
### 📁 `lib/features/customer/` & `lib/features/services/`
1.  **Discovery**: High-performance search filters for 3D Modeling, Web, SEO, and Graphic Design.
2.  **Education**: Access to professional Python AI and Data Strategy courses.
3.  **Real-time Interaction**:
    *   **`lib/features/support/`**: Real-time AI Assistant.
    *   **`lib/features/inquiries/`**: WhatsApp-style direct chat with Admin (supports text and file attachments).
4.  **Order Management**:
    *   **Checkout**: Promo code verification system.
    *   **Tracking**: Live status badges (Pending, In Progress, Review).
    *   **Delivery**: Securely download deliverables directly within the app.
    *   **Feedback**: 5-star rating system with comments (`lib/features/reviews/`).

---

## 🛡️ 4. The Admin Command Center
### 📁 `lib/features/admin/`
*   **Business Intelligence (BI)**:
    *   **Revenue Line Charts**: Monthly financial growth tracking.
    *   **Popularity Pie Charts**: Visualizes which services are generating the most interest.
*   **Operations**:
    *   **Service/Skill Manager**: Create, edit, and apply discounts to offerings.
    *   **Broadcast Hub**: Send push notifications to the entire user base instantly.
    *   **Payment Hub**: Manage and update EasyPaisa, JazzCash, and Bank details.
*   **CRM**: Manage all customer inquiries and support threads from a unified dashboard.

---

## 🛠️ 5. Technical Specification Sheet
| Module | Technology | Function |
| :--- | :--- | :--- |
| **Backend** | Supabase | Real-time DB, Auth, and Secure Storage |
| **State** | BLoC (Cubit) | Predictable and testable logic flow |
| **AI** | Gemini API | Smart contextual assistant |
| **Local DB** | Hive | High-speed offline caching |
| **UI** | Material 3 | Google's latest design standard |
| **Export** | PDF/Dart | Professional document generation |

---

## 📈 6. Business Value
*   **Scalability**: The Supabase + Flutter architecture allows for millions of users without infrastructure changes.
*   **Automation**: Reduces manual work for Admin through automated invoicing and AI support.
*   **Elite Branding**: Pure white design with glass-morphism panels ensures a premium client experience.

---

**Dynetix is now a battle-ready, professional-grade platform ready for deployment.**
