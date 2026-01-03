# 📸 Screenshots Guide

Panduan lengkap untuk menambahkan screenshots ke folder `assets/screenshots/`.

---

## 📁 Folder Structure

```
assets/screenshots/
├── mobile/
│   ├── 1_splash.png
│   ├── 2_login.png
│   ├── 3_home.png
│   ├── 4_booking_step1.png
│   ├── 5_booking_step2.png
│   ├── 6_booking_step3.png
│   ├── 7_upload_proof.png
│   ├── 8_invoice.png
│   └── 9_qris_payment.png
├── web/
│   ├── 1_home_desktop.png
│   ├── 2_booking_flow.png
│   ├── 3_invoice_dashboard.png
│   └── 4_payment_confirmation.png
└── README.md (this file)
```

---

## 📱 Mobile Screenshots (9 Required)

### 1. **Splash Screen** (`1_splash.png`)
- Size: 1080x2340px (or 540x1170px for mobile device)
- Content:
  - Waven logo
  - Loading animation
  - Company branding
- Duration shown: ~2-3 seconds

### 2. **Login Page** (`2_login.png`)
- Size: 1080x2340px
- Content:
  - Email input field
  - Password input field
  - "Sign In" button
  - "Sign Up" link
  - Google OAuth button (optional)
  - Dark theme background

### 3. **Home Page** (`3_home.png`)
- Size: 1080x2340px
- Content:
  - Navigation bar at top
  - Package list carousel or grid
  - Package cards showing:
    - Package image/thumbnail
    - Package name
    - Price (in IDR format)
    - Rating/reviews
  - Search/filter options
  - Portfolio link

### 4. **Booking Step 1** (`4_booking_step1.png`)
- Size: 1080x2340px
- Content:
  - Progress indicator (Step 1 of 3)
  - "Pilih tanggal dan waktu" header
  - University dropdown
  - Date picker showing calendar
  - Time range selector (start/end time)
  - "Check Availability" button
  - Waven logo or branding

### 5. **Booking Step 2** (`5_booking_step2.png`)
- Size: 1080x2340px
- Content:
  - Progress indicator (Step 2 of 3)
  - "Pilih Paket dan Isi Form" header
  - Package selection dropdown
  - Add-ons checkboxes (prints, albums, etc)
  - Pricing breakdown
  - Customer info fields (Name, WhatsApp, Instagram)
  - "Lanjut ke Pembayaran" button

### 6. **Booking Step 3** (`6_booking_step3.png`)
- Size: 1080x2340px
- Content:
  - Progress indicator (Step 3 of 3)
  - "Konfirmasi Pesanan" header
  - Booking summary showing:
    - Package details
    - Date & time
    - Amount (IDR formatted: "Rp 1.500.000")
    - Add-ons list
  - Payment method selection:
    - Bank Transfer (VA)
    - QRIS
    - E-Wallet
  - "Konfirmasi & Bayar" button

### 7. **Upload Proof** (`7_upload_proof.png`)
- Size: 1080x2340px
- Content:
  - "Upload Bukti Transfer" header
  - Image preview area
  - Upload button / Image picker
  - Image displayed (if already uploaded)
  - File name and size info
  - "Kirim" button

### 8. **Invoice Details** (`8_invoice.png`)
- Size: 1080x2340px
- Content:
  - Invoice header with invoice number
  - Customer info (name, WhatsApp, Instagram)
  - Booking details:
    - Package name & date
    - Time slot
    - Amount (IDR formatted)
    - Payment status badge
  - QR code for reference (if applicable)
  - Download/Share buttons
  - Payment status indicator

### 9. **QRIS Payment Screen** (`9_qris_payment.png`)
- Size: 1080x2340px
- Content:
  - "Scan QRIS Untuk Membayar" header
  - Large QR code centered
  - Amount to pay (IDR)
  - Timer/expiry time (if applicable)
  - "Pembayaran Berhasil" confirmation message OR
  - Instructions: "Scan dengan aplikasi e-wallet Anda"
  - Status indicator

---

## 🖥️ Web/Desktop Screenshots (4 Optional)

### 1. **Home Desktop** (`web/1_home_desktop.png`)
- Size: 1920x1080px or 1366x768px
- Full page layout with navigation sidebar/header
- Package grid or list view
- Responsive design

### 2. **Booking Flow** (`web/2_booking_flow.png`)
- Size: 1920x1080px
- Multi-step form displayed (all steps visible or current step)
- Form fields for customer details
- Package & add-ons selection

### 3. **Invoice Dashboard** (`web/3_invoice_dashboard.png`)
- Size: 1920x1080px
- Invoice list with filters
- Columns: Invoice ID, Date, Amount, Status
- Action buttons (View, Download, Print)

### 4. **Payment Confirmation** (`web/4_payment_confirmation.png`)
- Size: 1920x1080px
- Payment success page
- Invoice details
- Transaction reference number
- Download PDF button

---

## 🎨 Screenshot Guidelines

### Best Practices

1. **Quality**
   - Use actual device screenshots (not mockups)
   - Clear, readable text
   - No private data visible (use test accounts)
   - Consistent lighting & colors

2. **Consistency**
   - All mobile screenshots: same device/resolution
   - Dark theme (as per design)
   - Same app version
   - Consistent state (data presence/absence)

3. **Content**
   - Use realistic but non-sensitive test data
   - Show happy path (successful scenarios)
   - Highlight key features & workflows
   - Include payment methods display

4. **Format**
   - PNG format (lossless)
   - Optimized size (< 2MB each)
   - Correct dimensions/aspect ratio
   - No watermarks or device frames (unless intentional)

### Tools to Capture Screenshots

**Mobile (Android/iOS):**
- Built-in screenshot tool (Home + Power button, or Volume Down + Power)
- AndroidStudio Device Emulator screenshot button
- iOS Simulator screenshot (Cmd + S)

**Web/Desktop:**
- Chrome DevTools device emulation
- Snipping Tool (Windows)
- Screenshot tool (macOS: Cmd + Shift + 4)

### Image Optimization

```bash
# Linux/macOS - Reduce file size
convert 1_splash.png -quality 85 1_splash_optimized.png

# Windows - Using ImageMagick
magick convert 1_splash.png -quality 85 1_splash_optimized.png
```

---

## 📋 Checklist

- [ ] Create `assets/screenshots/mobile/` folder
- [ ] Create `assets/screenshots/web/` folder
- [ ] Capture 9 mobile screenshots (required)
- [ ] Capture 4 web screenshots (optional)
- [ ] Optimize image sizes
- [ ] Name files correctly (1_splash.png, 2_login.png, etc)
- [ ] Verify images are readable
- [ ] Test app still runs with images added
- [ ] Update README with screenshot preview section
- [ ] Commit screenshots to git

---

## 🚀 How to Add to README

After adding screenshots, update README.md with preview sections:

```markdown
### Mobile Screenshots

#### 1. Splash Screen
![Splash Screen](assets/screenshots/mobile/1_splash.png)
*Loading animation dengan Waven branding*

#### 2. Login Page
![Login](assets/screenshots/mobile/2_login.png)
*Login dengan email & password atau Google OAuth*

#### 3. Home Page
![Home](assets/screenshots/mobile/3_home.png)
*Browse photography packages tersedia*

... (and so on for each screenshot)
```

---

## 📸 Before & After Template

**Example markdown with screenshots:**

```markdown
## 📱 Screenshots

### Mobile App Flow

| Step | Screenshot | Description |
|------|-----------|-------------|
| 1 | ![Splash](assets/screenshots/mobile/1_splash.png) | App splash screen |
| 2 | ![Login](assets/screenshots/mobile/2_login.png) | User authentication |
| 3 | ![Home](assets/screenshots/mobile/3_home.png) | Browse packages |
| 4 | ![Booking](assets/screenshots/mobile/4_booking_step1.png) | Start booking |
| 5 | ![Payment](assets/screenshots/mobile/9_qris_payment.png) | QRIS payment |

### Web Dashboard

| Feature | Screenshot |
|---------|-----------|
| **Home Desktop** | ![Home Web](assets/screenshots/web/1_home_desktop.png) |
| **Invoice Management** | ![Invoice Dashboard](assets/screenshots/web/3_invoice_dashboard.png) |
```

---

## 🔧 Git Configuration

Add to `.gitignore` if images are too large:
```
# Large screenshot files (optional)
assets/screenshots/*.png
!assets/screenshots/placeholder.png
```

Or keep them in repo for documentation:
```bash
git add assets/screenshots/
git commit -m "docs: add app screenshots"
```

---

## 📝 Notes

- Screenshots should reflect **current version** of app
- Update screenshots when major UI changes occur
- Keep backup of original screenshots
- Consider creating a "screenshots" branch for management
- Test responsiveness across different screen sizes

---

**Last Updated:** January 3, 2026

*Ready to add screenshots? Follow the folder structure above and checklist!*
