# 🎬 WAVEN - Photography Booking & Invoice Management

[![Flutter](https://img.shields.io/badge/Flutter-3.10+-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.10+-blue.svg)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Status](https://img.shields.io/badge/Status-MVP+-brightgreen.svg)]()

**Waven** adalah platform booking dan manajemen invoice untuk layanan fotografi profesional. Aplikasi ini memungkinkan pengguna untuk memesan sesi fotografi, mengelola pembayaran melalui berbagai metode (Bank Transfer, E-Wallet, QRIS), dan mengakses riwayat transaksi mereka dengan mudah.

---

## 📱 Screenshots

> **Note:** Tambahkan screenshots berikut di folder `assets/screenshots/`

### Mobile Views
```
assets/screenshots/
├── 1_splash.png          # Splash screen loading
├── 2_login.png           # Login page
├── 3_home.png            # Home/Package list
├── 4_booking_step1.png   # Booking - Select date & time
├── 5_booking_step2.png   # Booking - Select package & add-ons
├── 6_booking_step3.png   # Booking - Confirmation & payment method
├── 7_upload_proof.png    # Upload transfer proof (for bank transfer)
├── 8_invoice.png         # Invoice details
└── 9_qris_payment.png    # QRIS payment screen
```

### Web Views
- Desktop responsive layout
- Full booking flow dengan multi-step form
- Invoice & transaction management dashboard

---

## 🚀 Features

### Core Features
- ✅ **Authentication**
  - Login/Signup dengan email & password
  - Google OAuth integration
  - Secure token management dengan refresh token
  - Session management dengan auto-logout

- ✅ **Package & Portfolio Management**
  - Browse photography packages
  - View portfolio gallery
  - Detailed package information & pricing

- ✅ **Booking System**
  - Multi-step booking process (3 steps)
  - Date & time availability checking
  - Add-ons selection (prints, albums, etc)
  - Form validation & state management
  - Image compression sebelum upload (prevents 413 errors)

- ✅ **Payment Integration - Midtrans**
  - **Virtual Account (VA)** - Bank Transfer
    - Support untuk semua major banks (BCA, Mandiri, BNI, PERMATA)
    - Flexible payment period
    - Auto-confirmation saat pembayaran diterima
  - **QRIS** - QR Code Indonesia Standard
    - Mobile wallet payments
    - Real-time payment confirmation
    - QR code image display
  - **Snap Payment Gateway**
    - Web redirect untuk payment di browser
    - Payment status tracking
    - Multi-method payment options

- ✅ **Invoice Management**
  - Invoice history & list
  - Detailed invoice view
  - Download invoice capability
  - Payment status tracking
  - QR code for payment reference

- ✅ **Google Drive Integration**
  - Fetch customer photos dari Google Drive
  - Infinite scroll pagination
  - File selection dengan search
  - Chip-based UI untuk selected files
  - Edit photo names/captions

- ✅ **User Profile**
  - Profile information management
  - Photo upload & preview
  - Edit personal details

- ✅ **Additional Features**
  - Indonesian Rupiah (IDR) currency formatting
  - Responsive design (Mobile, Tablet, Web)
  - Dark theme UI
  - Multi-platform support (Android, iOS, Web)

---

## 💳 Payment Methods - Detailed Integration

### 1. Virtual Account (Bank Transfer)

**Flow:**
```
User selects "Bank Transfer" 
    ↓
Booking submitted → Backend creates VA with Midtrans
    ↓
App displays:
   - Bank name & VA number
   - Payment amount
   - Expiry time
   - Copyable account details
    ↓
User transfers via mobile banking / ATM
    ↓
Midtrans confirms payment
    ↓
Invoice status updated to PAID
```

**Supported Banks:**
- BCA (Bank Central Asia)
- Mandiri (Bank Mandiri)
- BNI (Bank Negara Indonesia)
- PERMATA (Bank PERMATA)

### 2. QRIS (QR Code Indonesia Standard)

**Flow:**
```
User selects "QRIS"
    ↓
Booking submitted → Backend creates QRIS transaction
    ↓
App fetches QR image via: GET /v1/bookings/{transactionId}/qris
    ↓
Display QR code on screen
    ↓
User scans dengan mobile wallet (GCash, OVO, DANA, etc)
    ↓
Payment instant confirmation
    ↓
Invoice updated & receipt generated
```

**Supported Wallets:**
- GCash
- OVO
- DANA
- LinkAja
- All QRIS-compatible wallets

### 3. Snap Payment Gateway (Web Redirect)

**Flow (Web Platform):**
```
User completes booking on web
    ↓
Backend returns redirectUrl dari Midtrans
    ↓
App opens redirect URL di browser:
   launchUrl(uri, mode: LaunchMode.platformDefault, webOnlyWindowName: '_self')
    ↓
User lands di Snap payment page
    ↓
Multiple payment options available
    ↓
Payment completed
    ↓
Redirect ke success page atau check status via API
```

### 4. Payment Status Verification

**Real-time checking:**
```dart
// Check payment status setelah user submit
GET /v1/bookings/{bookingId}/qris/{gatewayId}

// Response indicates:
- pending: Awaiting payment
- confirmed: Payment received
- failed: Payment rejected
- expired: VA/QRIS expired
```

---

## 🏗️ Project Architecture

### Clean Architecture with BLoC Pattern

```
lib/
├── main.dart                          # Entry point
├── injection.dart                     # Dependency Injection (GetIt)
├── common/
│   ├── color.dart                    # Theme colors
│   ├── constant.dart                 # App constants
│   ├── imageconstant.dart            # Image assets
│   └── theme/                        # Material theme
├── domain/
│   ├── entity/                       # Business entities
│   │   ├── invoice.dart
│   │   ├── booking.dart
│   │   ├── list_gdrive.dart
│   │   └── ...
│   ├── repository/                   # Abstract repositories
│   │   ├── booking_repository.dart
│   │   └── auth_repository.dart
│   └── usecase/                      # Business logic
│       ├── post_booking.dart
│       ├── get_list_invoice_user.dart
│       └── ...
├── data/
│   ├── model/                        # API response models (JSON serialization)
│   │   ├── invoicemodel.dart
│   │   ├── google_drive_model.dart
│   │   └── ...
│   ├── remote/                       # API calls (Dio + interceptors)
│   │   ├── dio.dart                 # Dio configuration with auth handling
│   │   ├── data_remote_impl.dart    # API endpoints
│   │   └── data_local_impl.dart     # Secure storage
│   └── *_repository_impl.dart        # Repository implementations
└── presentation/
    ├── cubit/                        # State management (13 cubits)
    │   ├── booking_cubit.dart
    │   ├── detail_invoice_cubit.dart
    │   ├── google_drive_cubit.dart
    │   └── ...
    ├── pages/                        # Full-page screens
    │   ├── booking_page.dart
    │   ├── login_page.dart
    │   └── ...
    ├── widget/                       # Reusable widgets
    │   ├── button.dart
    │   ├── dialogtextinput.dart
    │   ├── frostglass.dart
    │   └── ...
    └── router/                       # GoRouter configuration
        └── routerauth.dart
```

---

## 📋 Tech Stack

### Frontend
- **Framework:** Flutter 3.10+
- **Language:** Dart 3.10+
- **State Management:** Flutter BLoC (Cubit pattern)
- **Routing:** GoRouter
- **HTTP Client:** Dio
- **JSON Serialization:** json_serializable + build_runner

### Local Storage
- **Secure Storage:** flutter_secure_storage (tokens)
- **Local Cache:** DataLocal implementation

### UI Components
- **Fonts:** Google Fonts (Roboto Flex)
- **Icons:** Font Awesome
- **Images:** Cached Network Image
- **Animations:** Lottie
- **Carousel:** Carousel Slider
- **Dropdown:** Dropdown Search

### Payment Integration
- **Midtrans Snap:** Payment gateway integration
  - Virtual Account (Bank Transfer)
  - QRIS (Mobile Wallet)
  - Real-time payment verification
  - Automatic status polling

### Others
- **Image Processing:** flutter_image_compress (client-side compression)
- **Image Picker:** image_picker
- **Utilities:** intl (currency formatting), logger, url_launcher
- **Dev Tools:** flutter_lints, build_runner

---

## 🔧 Setup & Installation

### Prerequisites
- Flutter 3.10+ ([Download](https://flutter.dev/docs/get-started/install))
- Dart 3.10+
- Git
- Midtrans Account (untuk production)

### Environment Setup

1. **Clone Repository**
```bash
git clone https://github.com/yourusername/waven.git
cd waven
```

2. **Install Dependencies**
```bash
flutter pub get
```

3. **Generate Code (JSON serialization & build_runner)**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Midtrans Configuration**

Update `lib/data/remote/data_remote_impl.dart`:
```dart
final baseurl = "https://your-api.com/"; // Your backend URL
```

Backend harus configure Midtrans dengan:
- Server Key (for backend transactions)
- Client Key (untuk Snap integration)
- Configure webhook untuk payment notifications

5. **Run Application**

**Android:**
```bash
flutter run -d android
```

**iOS:**
```bash
flutter run -d ios
```

**Web (Edge/Chrome):**
```bash
flutter run -d edge
# or
flutter run -d chrome
```

---

## 💰 Midtrans Integration Guide

### Backend Requirements

Ensure backend API implements:

```
1. POST /v1/bookings
   - Accept booking data
   - Create Midtrans transaction
   - Return: {
       midtransId: "string",
       bookingDetail: { ... },
       actions: {
         redirectUrl: "https://app.sandbox.midtrans.com/snap/..." // untuk web
       }
     }

2. GET /v1/bookings/{transactionId}/qris
   - Fetch QR code image bytes
   - Return binary JPEG image
   - Response: Uint8List (image bytes)

3. GET /v1/bookings/{bookingId}/qris/{gatewayId}
   - Check payment status
   - Return: { isPaid: boolean, status: string }

4. POST /v1/auth/refresh
   - Refresh access token
   - Return: { 
       x-access-token: "new_token",
       x-refresh-token: "new_refresh_token"
     }
```

### Frontend Implementation

**Booking with Midtrans:**
```dart
// Step 1: User completes booking form
// Step 2: Submit booking with selected payment method
final invoice = await bookingRepository.submitBooking(
  customer: customer,
  bookingdata: booking,
  additionalData: additionalInfo,
  image: compressedImage, // for bank transfer proof
);

// Step 3: App automatically handles:
// - Opens Snap redirect on web (if available)
// - Fetches QR image (if midtransId exists)
// - Displays payment details to user

// Step 4: User completes payment outside app
// Step 5: App polls payment status or receives webhook
```

---

## 📊 State Management Structure

### 13 Cubits (BLoC Pattern)

| Cubit | Purpose | State |
|-------|---------|-------|
| `BookingCubit` | Booking flow & form | Loading, Tahap1-3, Success, Error |
| `AuthCubit` | Login/Signup | Loading, Authenticated, Error |
| `TokenauthCubit` | Token & session mgmt | Valid, Expired, Refreshing |
| `ListInvoiceCubit` | Invoice list & pagination | Loading, Loaded, Error |
| `DetailInvoiceCubit` | Single invoice details | Loading, Loaded, Error |
| `ProfileCubit` | User profile data | Loading, Loaded, Error |
| `TransactionCubit` | Transaction history | Loading, Loaded, Error |
| `GoogleDriveCubit` | Drive file listing | Loading, Loaded, Error |
| `PortoAllCubit` | Portfolio gallery | Loading, Loaded, Error |
| `PackageAllCubit` | Package listing | Loading, Loaded, Error |
| `PackageDetailCubit` | Package details | Loading, Loaded, Error |
| `SignupCubit` | Registration | Loading, Success, Error |
| `AssetLoaderCubit` | Asset preloading | Loading, Loaded |

---

## 🛠️ Development Workflow

### Adding New Features

1. **Create Entity** (`domain/entity/`)
2. **Create Model** (`data/model/`) dengan JSON serialization
3. **Update Repository** (`domain/repository/` + `data/*_repository_impl.dart`)
4. **Create Cubit** (`presentation/cubit/`)
5. **Build UI** (`presentation/pages/` + `widgets/`)
6. **Update Router** (`presentation/router/`)

### Code Generation

After modifying models:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 🐛 Known Issues & Limitations

| Issue | Status | Workaround |
|-------|--------|-----------|
| Image loading failures on slow network | ✅ Fixed | Using cached_network_image |
| Payment status not updating instantly | ⚠️ Requires webhook | Manual refresh button available |
| No offline support | ❌ Future | Requires network connectivity |
| Limited test coverage | ❌ In progress | Manual QA currently |

---

## 🔐 Security

✅ **Implemented:**
- HTTPS only
- Secure token storage (flutter_secure_storage)
- Bearer token in Authorization header
- Token refresh mechanism
- Auto logout on 401
- Dio interceptor untuk automatic token injection

⚠️ **To Review:**
- Rate limiting pada login/signup attempts
- API response validation
- CSRF protection (if applicable)

---

## 📝 License

MIT License - See LICENSE file

---

## 🔗 Resources

- [Flutter Docs](https://flutter.dev/docs)
- [Midtrans Docs](https://docs.midtrans.com)
- [BLoC Library](https://bloclibrary.dev)
- [Dio Package](https://pub.dev/packages/dio)

---

**Made with ❤️ using Flutter**

*Last Updated: January 3, 2026*
