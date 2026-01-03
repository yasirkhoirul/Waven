# 💳 MIDTRANS INTEGRATION GUIDE

Complete guide untuk mengintegrasikan Waven app dengan Midtrans payment gateway.

---

## 📋 Daftar Isi

1. [Midtrans Account Setup](#account-setup)
2. [Backend Integration](#backend-integration)
3. [Frontend Implementation](#frontend-implementation)
4. [Testing](#testing)
5. [Production Deployment](#production)
6. [Troubleshooting](#troubleshooting)

---

## 🔐 Account Setup

### 1. Create Midtrans Account

1. Kunjungi [Midtrans Dashboard](https://dashboard.midtrans.com)
2. Sign up dengan email perusahaan Anda
3. Lengkapi business information
4. Verify email

### 2. Configure Environment

**Sandbox (Testing):**
- Login ke [Sandbox Dashboard](https://app.sandbox.midtrans.com)
- Copy `Server Key` dan `Client Key`

**Production:**
- Login ke [Production Dashboard](https://app.midtrans.com)
- Activate production mode
- Copy `Server Key` dan `Client Key`

### 3. Store Credentials

Backend harus store di environment variables:
```env
MIDTRANS_SERVER_KEY=SB-Mid-server-xxxxxxxxxxxxxx
MIDTRANS_CLIENT_KEY=SB-Mid-client-xxxxxxxxxxxxxx
MIDTRANS_ENVIRONMENT=sandbox # atau production
```

---

## 🔧 Backend Integration

### Required Endpoints

#### 1. **POST /v1/bookings** - Create Booking with Payment

```javascript
// Request
POST /v1/bookings
{
  "customer": {
    "fullName": "John Doe",
    "whatsappNumber": "+6281234567890",
    "instagram": "@johndoe"
  },
  "booking": {
    "packageId": "pkg_001",
    "date": "2026-01-15",
    "startTime": "09:00",
    "endTime": "12:00",
    "paymentMethod": "bank_transfer", // atau "qris"
    "paymentType": "full",
    "amount": 1500000,
    "addonIds": ["addon_1", "addon_2"]
  },
  "additionalData": {
    "universityId": "univ_001",
    "location": "Jakarta",
    "note": "Please bring props"
  }
}

// Response
{
  "message": "Booking created successfully",
  "data": {
    "bookingDetail": {
      "bookingId": "BOOK-001",
      "midtransId": "123456789", // PENTING: Untuk fetch QR & check status
      "totalAmount": 1500000,
      "paidAmount": 0,
      "currency": "IDR",
      "paymentMethod": "bank_transfer", // atau qris
      "paymentStatus": "pending",
      "transactionTime": "2026-01-03T10:00:00Z"
    },
    "actions": {
      "redirectUrl": "https://app.sandbox.midtrans.com/snap/..." // untuk web
    }
  }
}
```

**Backend Implementation (Node.js/Express example):**

```javascript
const midtransClient = require('midtrans-client');

// Initialize Midtrans Snap Client
const snap = new midtransClient.Snap({
  isProduction: false,
  serverKey: process.env.MIDTRANS_SERVER_KEY,
  clientKey: process.env.MIDTRANS_CLIENT_KEY,
});

app.post('/v1/bookings', async (req, res) => {
  try {
    const { customer, booking, additionalData } = req.body;

    // 1. Create booking in database
    const bookingRecord = await Booking.create({
      customerId: customer.id,
      packageId: booking.packageId,
      date: booking.date,
      startTime: booking.startTime,
      endTime: booking.endTime,
      amount: booking.amount,
      status: 'pending',
    });

    // 2. Create Midtrans transaction
    const parameter = {
      transaction_details: {
        order_id: `BOOK-${bookingRecord.id}`,
        gross_amount: booking.amount,
      },
      customer_details: {
        first_name: customer.fullName,
        phone: customer.whatsappNumber,
      },
      item_details: [
        {
          id: booking.packageId,
          price: booking.amount,
          quantity: 1,
          name: 'Photography Booking',
        },
      ],
      payment_type: booking.paymentMethod, // 'bank_transfer' atau 'qris'
      bank_transfer: booking.paymentMethod === 'bank_transfer' ? {
        bank: 'bca', // atau 'mandiri', 'bni', 'permata'
      } : undefined,
    };

    // 3. Request Snap Token
    const transaction = await snap.createTransaction(parameter);

    // 4. Save midtrans ID to booking
    bookingRecord.midtransId = transaction.token || transaction.redirect_url.split('/').pop();
    await bookingRecord.save();

    // 5. Return response with redirect URL
    return res.status(201).json({
      message: 'Booking created successfully',
      data: {
        bookingDetail: {
          bookingId: bookingRecord.id,
          midtransId: bookingRecord.midtransId,
          totalAmount: booking.amount,
          paidAmount: 0,
          paymentStatus: 'pending',
        },
        actions: {
          redirectUrl: transaction.redirect_url, // untuk web platform
        },
      },
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Booking failed', error: error.message });
  }
});
```

#### 2. **GET /v1/bookings/{transactionId}/qris** - Get QR Code Image

```javascript
app.get('/v1/bookings/:transactionId/qris', async (req, res) => {
  try {
    const { transactionId } = req.params;

    // Get transaction status from Midtrans
    const transaction = await snap.transaction.status(transactionId);

    // Extract QR code (if using QRIS)
    if (transaction.payment_type === 'qris') {
      // Get QR image from Midtrans
      const qrisUrl = transaction.actions.find(a => a.name === 'generate-qr-code')?.url;
      
      if (qrisUrl) {
        // Fetch QR image
        const response = await fetch(qrisUrl);
        const imageBuffer = await response.buffer();
        
        // Return as binary image
        res.setHeader('Content-Type', 'image/png');
        return res.send(imageBuffer);
      }
    }

    return res.status(404).json({ message: 'QR code not found' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Failed to fetch QR code' });
  }
});
```

#### 3. **GET /v1/bookings/{bookingId}/qris/{gatewayId}** - Check Payment Status

```javascript
app.get('/v1/bookings/:bookingId/qris/:gatewayId', async (req, res) => {
  try {
    const { bookingId, gatewayId } = req.params;

    // Get booking from database
    const booking = await Booking.findById(bookingId);
    if (!booking) {
      return res.status(404).json({ message: 'Booking not found' });
    }

    // Check status di Midtrans
    const transaction = await snap.transaction.status(booking.midtransId);

    // Update booking status if paid
    if (transaction.transaction_status === 'settlement' || 
        transaction.transaction_status === 'capture') {
      booking.status = 'paid';
      booking.paidAmount = transaction.gross_amount;
      await booking.save();

      // Create invoice
      await Invoice.create({
        bookingId: booking.id,
        amount: transaction.gross_amount,
        paymentMethod: transaction.payment_type,
        status: 'issued',
      });
    }

    return res.json({
      isPaid: transaction.transaction_status === 'settlement',
      status: transaction.transaction_status,
      amount: transaction.gross_amount,
      paymentMethod: transaction.payment_type,
      timestamp: transaction.transaction_time,
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Failed to check payment status' });
  }
});
```

### 4. **Webhook Setup** (Optional but Recommended)

Configure webhook untuk real-time payment notifications:

```javascript
// Handle Midtrans webhook
app.post('/webhook/midtrans', async (req, res) => {
  try {
    const notification = req.body;

    // Verify signature (important for security)
    const key = process.env.MIDTRANS_SERVER_KEY;
    const orderId = notification.order_id;
    const statusCode = notification.status_code;
    const grossAmount = notification.gross_amount;
    const signature = notification.signature_key;

    // Hash validation
    const hash = crypto
      .createHash('sha512')
      .update(orderId + statusCode + grossAmount + key)
      .digest('hex');

    if (signature !== hash) {
      return res.status(403).json({ message: 'Invalid signature' });
    }

    // Update booking based on transaction status
    const booking = await Booking.findOne({ midtransId: notification.transaction_id });
    if (!booking) {
      return res.status(404).json({ message: 'Booking not found' });
    }

    switch (notification.transaction_status) {
      case 'settlement':
      case 'capture':
        // Payment successful
        booking.status = 'paid';
        booking.paidAmount = notification.gross_amount;
        break;
      case 'deny':
      case 'cancel':
        // Payment failed
        booking.status = 'failed';
        break;
      case 'pending':
        // Still waiting for payment
        booking.status = 'pending';
        break;
    }

    await booking.save();
    return res.json({ message: 'Webhook processed' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Webhook processing failed' });
  }
});
```

---

## 📱 Frontend Implementation

### 1. **Dio Configuration** (Already Implemented)

File: `lib/data/remote/dio.dart`

```dart
// Token refresh & error handling already implemented
// Interceptor handles 401 unauthorized automatically
```

### 2. **Remote API Call**

File: `lib/data/remote/data_remote_impl.dart`

```dart
@override
Future<InvoiceModel> postBooking(
  BookingRequestModel payload, {
  List<int>? image,
}) async {
  try {
    FormData formData;
    final isTransferMethod = payload.bookingData.paymentMethod == Constantclass.paymentMethod[2];
    
    if (image != null && image.isNotEmpty && isTransferMethod) {
      formData = FormData.fromMap({
        'image': MultipartFile.fromBytes(image, filename: 'bukti_transfer.jpg'),
        'data': jsonEncode(payload.toJson()),
      });
    } else {
      formData = FormData.fromMap({'data': jsonEncode(payload.toJson())});
    }

    final response = await dio.dio.post('v1/bookings', data: formData);
    final data = InvoiceModel.fromJson(response.data);
    return data;
  } catch (e) {
    Logger().e("Error posting booking: $e");
    throw Exception(e.toString());
  }
}
```

### 3. **Repository Layer**

File: `lib/data/booking_repository_impl.dart`

```dart
@override
Future<Invoice> submitBooking({
  required Customer customer,
  required Booking bookingdata,
  required AdditionalInfo additionalData,
  List<int>? image,
}) async {
  try {
    final response = await dataRemote.postBooking(payload, image: image);
    
    // Handle web redirect
    Uint8List? qrImageBytes;
    final redirectUrl = response.data.actions?.redirectUrl;
    final midtransId = response.data.bookingDetail.midtransId;

    if (kIsWeb && redirectUrl != null) {
      final uri = Uri.parse(redirectUrl);
      await launchUrl(uri, mode: LaunchMode.platformDefault, webOnlyWindowName: '_self');
    }

    // Fetch QR image if exists
    if (midtransId != null && midtransId.isNotEmpty) {
      try {
        final bytes = await dataRemote.getQris(midtransId);
        qrImageBytes = Uint8List.fromList(bytes);
      } catch (e) {
        Logger().e('Failed to fetch QR: $e');
      }
    }

    return Invoice(
      message: response.message,
      bookingDetail: BookingDetailEntity(
        bookingId: response.data.bookingDetail.bookingId,
        midtransId: midtransId,
        totalAmount: response.data.bookingDetail.totalAmount,
        paymentStatus: response.data.bookingDetail.paymentStatus,
        paymentQrUrl: midtransId,
        gambarqr: qrImageBytes,
      ),
    );
  } catch (e) {
    rethrow;
  }
}
```

### 4. **UI Implementation**

File: `lib/presentation/pages/booking_page.dart`

```dart
// Booking step 3 - Show payment method
class SubmittedPage extends StatelessWidget {
  final Invoice invoice;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Show payment details based on method
        if (invoice.bookingDetail.paymentMethod == 'bank_transfer')
          _buildBankTransferUI(invoice),
        
        if (invoice.bookingDetail.paymentMethod == 'qris' && 
            invoice.bookingDetail.gambarqr != null)
          _buildQRISUI(invoice),
      ],
    );
  }

  Widget _buildBankTransferUI(Invoice invoice) {
    return Container(
      // Display VA number, bank, amount
      // Make account copyable with button
    );
  }

  Widget _buildQRISUI(Invoice invoice) {
    return FutureBuilder<Image>(
      future: _loadQRImage(invoice.bookingDetail.gambarqr),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!;
        }
        return CircularProgressIndicator();
      },
    );
  }
}
```

---

## 🧪 Testing

### 1. **Sandbox Testing**

Use Midtrans test credentials:

**Test Card Numbers:**
- Visa: `4811111111111114`
- Mastercard: `5555555555554444`
- BNI VA: Bank transfer simulation

**Test Phone Number:** `081234567890`

### 2. **Payment Status Simulation**

In Sandbox:
- Complete payment → `settlement`
- Deny payment → `deny`
- Wait for expiry → `expire`

### 3. **Flutter Testing**

```bash
# Run on Android
flutter run -d android

# Run on iOS
flutter run -d ios

# Run on Web
flutter run -d edge
```

---

## 🚀 Production Deployment

### 1. **Switch to Production**

```dart
// lib/data/remote/data_remote_impl.dart
final baseurl = "https://your-production-api.com/";

// Backend: Switch Midtrans environment
const snap = new midtransClient.Snap({
  isProduction: true, // ⚠️ CRITICAL
  serverKey: process.env.PRODUCTION_MIDTRANS_SERVER_KEY,
  clientKey: process.env.PRODUCTION_MIDTRANS_CLIENT_KEY,
});
```

### 2. **Security Checklist**

- ✅ Use HTTPS only
- ✅ Validate all API responses
- ✅ Never expose Server Key in frontend
- ✅ Implement webhook signature verification
- ✅ Add rate limiting on API endpoints
- ✅ Enable CORS restrictions
- ✅ Add logging & monitoring
- ✅ Test payment refund flow

### 3. **Monitoring**

Monitor Midtrans dashboard:
- Transaction volume
- Failed transactions
- Payment methods distribution
- Settlement reports

---

## 🐛 Troubleshooting

### Issue: "Signature key is invalid"

**Solution:**
- Verify Server Key is correct
- Ensure webhook payload hasn't been modified
- Check signature hash calculation

### Issue: "QR Code not generating"

**Solution:**
- Verify payment method is "qris"
- Check if Midtrans account has QRIS enabled
- Ensure transaction amount > 0

### Issue: "Redirect URL not working on web"

**Solution:**
```dart
// Make sure to use webOnlyWindowName: '_self'
await launchUrl(
  uri,
  mode: LaunchMode.platformDefault,
  webOnlyWindowName: '_self', // ← Important
);
```

### Issue: "Payment status not updating"

**Solution:**
- Implement webhook for real-time updates
- Add polling mechanism (check every 5 seconds)
- Verify `midtransId` is saved correctly

---

## 📚 Resources

- [Midtrans Documentation](https://docs.midtrans.com)
- [Midtrans Snap Integration](https://docs.midtrans.com/en/snap/overview)
- [Payment Methods](https://docs.midtrans.com/en/snap/integration-guide)
- [Webhook Guide](https://docs.midtrans.com/en/technical-reference/api-payment-page)

---

**Last Updated:** January 3, 2026
