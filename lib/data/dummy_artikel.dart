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
Identifikasi ikan adalah langkah pertama yang penting dalam memelihara ikan hias.  
Berikut beberapa cara **mengidentifikasi ikan**:

- Lihat **warna dan pola tubuhnya**  
- Amati bentuk **sirip dan ekornya**
- Cek **jenis sisik** dan bentuk mulutnya

Biasanya, ikan yang berasal dari spesies berbeda akan menunjukkan ciri morfologi yang mencolok.

> *Tips:* Gunakan aplikasi pendeteksi ikan untuk memudahkan proses identifikasi.
''',
  ),
  ArtikelData(
    title: 'Bagaimana memilih ikan sehat',
    imageUrl: 'lib/assets/images/artikel1.jpg',
    content: '''
Memilih ikan sehat sangat penting agar tidak menularkan penyakit ke akuarium.  
Berikut tanda-tanda **ikan sehat**:

- Gerakannya **aktif dan responsif**
- Warna tubuh cerah dan tidak kusam
- Tidak ada **bintik putih**, luka, atau benjolan
- Nafsu makan **normal**

> *Catatan:* Jangan pernah memilih ikan yang terlihat diam di dasar akuarium.
''',
  ),
  ArtikelData(
    title: 'Tips merawat akuarium agar tetap jernih',
    imageUrl: 'lib/assets/images/artikel1.jpg',
    content: '''
Akuarium yang jernih bikin ikan lebih sehat dan enak dilihat. Berikut tipsnya:

- **Ganti air** rutin (sekitar 20% per minggu)
- Pakai **filter biologis dan mekanis**
- Jangan overfeeding, karena sisa makanan bikin air keruh
- Tambahkan **tanaman air** untuk menyerap zat berlebih

> *Pro tip:* Gunakan lampu UV untuk membantu menjernihkan air.
''',
  ),
  ArtikelData(
    title: 'Jenis penyakit ikan yang umum dan cara mencegahnya',
    imageUrl: 'lib/assets/images/artikel1.jpg',
    content: '''
Beberapa penyakit ikan yang sering muncul:

1. **White Spot (Ich)** - muncul bintik putih, sebab suhu air rendah
2. **Fin Rot** - ujung sirip membusuk, sebab kualitas air buruk
3. **Dropsy** - perut buncit dan sisik mengembang

Cara mencegah:

- Jaga **kualitas air**
- Karantina ikan baru
- Beri pakan bernutrisi dan tidak berlebihan

> *Ingat:* Pencegahan lebih baik daripada mengobati.
''',
  ),
];
