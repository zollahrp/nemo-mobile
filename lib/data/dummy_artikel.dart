class ArtikelData {
  final String title;
  final String content;
  final String imageUrl;

  ArtikelData({
    required this.title,
    required this.content,
    required this.imageUrl,
  });
}

final List<ArtikelData> artikelList = [
  ArtikelData(
    title: 'Bagaimana cara identifikasi ikan',
    imageUrl: 'lib/assets/images/artikel1.jpg',
    content: '''
Identifikasi ikan adalah langkah pertama yang penting sebelum kamu memelihara atau mengamati ikan lebih lanjut. Kalau kamu mengenali ciri khas setiap jenis ikan, kamu bisa memahami kebutuhan, karakteristik, bahkan potensi penyakit yang mungkin menyerang.

Berikut beberapa cara **mengidentifikasi ikan** secara visual (yang dapat kita lihat):

- Perhatikan **warna dan pola tubuh**  
- Amati bentuk **sirip dan ekor**  
- Cek jenis **sisik**, bentuk mulut, dan ukuran tubuh

Kamu tau gak sih? Biasanya, ikan dari spesies yang berbeda akan menunjukkan ciri morfologi yang cukup mencolok. Tapi tenang, kamu nggak harus hafal semua jenis ikan satu per satu. Di sinilah teknologi bisa bantu kamu.

---

### Identifikasi Ikan dengan Teknologi *Scan*

IYA! kamu gak salah baca, melalui fitur *scan* pada aplikasi **Nemo.AI**, kamu cukup arahkan kamera ke ikan yang ingin kamu kenali. Sistem akan memproses citra ikan tersebut dan mencocokkannya dengan basis data spesies. Hasilnya? Kamu akan langsung tahu nama ikan, deskripsi singkat, dan habitat asalnya.

> *Tips:* Gunakan fitur ini pada pencahayaan yang cukup ya! dan usahakan kamera fokus pada ikan agar hasil scan lebih akurat.

---

### Mendeteksi Penyakit pada Ikan

Tidak cuma identifikasi, fitur ini juga bisa bantu kamu mengenali **tanda-tanda penyakit** pada ikan lhoo. Misalnya:

- Muncul bercak putih, merah, atau luka di tubuh
- Sirip rusak atau menguncup  

Kalau ditemukan gejala mencurigakan, sistem akan memberikan kemungkinan jenis penyakit yang menyerang beserta rekomendasi penanganannya. Hebat kan?

---

### Kenapa Identifikasi Itu Penting?

Dengan mengetahui jenis dan kondisi ikan sejak awal, kamu bisa:

- Menyediakan lingkungan yang sesuai  
- Mencegah penularan penyakit ke ikan lain  
- Menentukan pakan yang tepat  
- Menjaga keseimbangan ekosistem akuarium

---

Yuk mulai kenali ikanmu lebih dalam bersama **Nemo.AI**. Jangan lupa cobain fiturnya ya!

''',
  ),
  ArtikelData(
    title: 'Bagaimana memilih ikan sehat',
    imageUrl: 'lib/assets/images/artikel2.jpg',
    content: '''
Memilih ikan yang sehat itu penting banget, apalagi kalau kamu baru mulai memelihara ikan di rumah. Ikan yang sakit bisa menularkan penyakit ke ikan lain dan merusak seluruh ekosistem akuariummu. Dengan memilih ikan yang sehat dari awal, kamu bisa mencegah banyak masalah di kemudian hari. Lebih baik mencegah daripada harus repot mengobati, kan?

Berikut beberapa tanda-tanda **ikan yang sehat**:

- Bergerak **aktif** dan cepat merespons saat didekati  
- Warna tubuhnya **cerah**, tidak kusam  
- Tidak ada **bintik putih**, luka, atau benjolan aneh  
- Nafsu makan tetap **normal** dan mau makan saat diberi pakan

> *Catatan:* Hindari memilih ikan yang hanya diam di dasar akuarium atau berenang miring! Itu bisa jadi tanda ia sedang sakit.
''',
  ),
  ArtikelData(
    title: 'Tips merawat akuarium agar tetap jernih',
    imageUrl: 'lib/assets/images/artikel3.jpg',
    content: '''
Akuarium yang jernih bukan cuma enak dilihat, tapi juga jadi tempat tinggal yang sehat buat ikan-ikanmu. Air yang keruh bisa jadi tanda ada masalah, entah itu dari sisa makanan, kotoran, atau kurangnya sirkulasi.

Berikut beberapa tips supaya akuariummu tetap **jernih dan bersih**:

- Rutin **ganti air**, sekitar 20% setiap minggu  
- Gunakan **filter** untuk menyaring kotoran dan zat berbahaya  
- Hindari *overfeeding*, karena sisa pakan bisa bikin air cepat keruh  
- Tambahkan **tanaman air** seperti *anubias* atau *java moss* untuk menyerap zat sisa secara alami

> *Pro tip:* Kamu juga bisa pakai lampu *UV sterilizer* buat membantu membunuh bakteri dan menjernihkan air lebih cepat.
''',
  ),
  ArtikelData(
    title: 'Jenis penyakit ikan yang umum dan cara mencegahnya',
    imageUrl: 'lib/assets/images/artikel4.jpg',
    content: '''
Ikan juga bisa kena sakit, lho dan kalau nggak ditangani dengan benar, bisa menular ke ikan lain di akuarium. Tapi tenang, kebanyakan penyakit bisa dicegah asal kamu tahu gejalanya sejak awal.

Berikut beberapa **penyakit ikan yang umum ditemui**:

1. **White Spot (*Ich*)**  
   Muncul bintik-bintik putih di tubuh ikan, biasanya karena suhu air terlalu rendah atau stres.

2. **Fin Rot**  
   Ujung sirip terlihat membusuk atau terkikis. Penyebab utamanya adalah kualitas air yang buruk.

3. **Dropsy**  
   Perut ikan membuncit dan sisiknya mengembang seperti duri landak. Biasanya ini tanda infeksi bakteri serius.

---

### Cara Mencegah Penyakit pada Ikan

- Selalu jaga **kualitas air** tetap stabil dan bersih  
- Lakukan **karantina ikan baru** sebelum dicampur ke akuarium utama  
- Berikan pakan yang **bernutrisi**, secukupnya saja dan jangan berlebihan  
- Bersihkan akuarium secara rutin dan hindari stresor seperti suara bising atau perubahan suhu ekstrem

> *Ingat:* Pencegahan selalu lebih mudah dan murah daripada harus mengobati.
''',
  ),
];
