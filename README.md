# 🐠 Nemo Mobile

Nemo Mobile adalah aplikasi Flutter berbasis kecerdasan buatan (AI) yang dirancang untuk membantu pengguna dalam merawat ikan hias, memberikan edukasi, serta mendeteksi jenis ikan secara otomatis.

---

## 🚀 Fitur Utama

- 🔍 **Identifikasi Ikan Otomatis**  
  Deteksi jenis ikan dengan mengunggah gambar menggunakan teknologi AI dari Google Gemini.

- 🧠 **FishBot (Chatbot AI)**  
  Chatbot pintar untuk tanya jawab seputar perawatan ikan.

- 📚 **Artikel Edukatif**  
  Artikel menarik dan informatif untuk meningkatkan pengetahuan pengguna dalam merawat ikan hias.

- 🐟 **Scanner Akuarium**  
  Memindai kondisi ikan dan memberi saran otomatis.

---

## 📱 Pratinjau

![Fitur Aplikasi](https://raw.githubusercontent.com/zollahrp/nemo-ai/main/public/img/fitur.png)

---

## 🛠 Teknologi yang Digunakan

- Flutter
- Dart
- Gemini API (Google AI)
- Firebase (opsional)
---

## 📦 Instalasi

Pastikan kamu sudah menginstall [Flutter SDK](https://docs.flutter.dev/get-started/install) dan Android Studio atau VS Code.

### 1. Clone Repository

```bash
git clone https://github.com/username/nemo_mobile.git
cd nemo_mobile
```

### 2. Jalankan Aplikasi

```bash
flutter pub get
flutter run --dart-define=GEMINI_API_KEY=ISI_API_KEY_MU
```

> 🔐 Ganti `ISI_API_KEY_MU` dengan API Key Gemini milikmu.  
> **Jangan masukkan API key langsung ke dalam kode.** Gunakan `dart-define` saat build atau sistem keamanan lainnya seperti `.env`.

