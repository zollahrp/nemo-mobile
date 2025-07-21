import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'package:image_picker/image_picker.dart';


import 'scanner_detail_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  late Interpreter _interpreter;
  late List<String> _labels;

  bool _isModelReady = false;
  bool _isFlashOn = false;

    void _toggleFlash() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      await _controller!.setFlashMode(
        _isFlashOn ? FlashMode.off : FlashMode.torch,
      );
      setState(() {
        _isFlashOn = !_isFlashOn;
      });
    } catch (e) {
      _showError("Gagal mengubah mode flash: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadModel();
    _setupCamera();
  }

  Future<void> _loadModel() async {
    print("🔍 Cek asset tersedia:");
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    print(manifestContent.contains('assets/model_unquant.tflite')
        ? '✅ Model ada di manifest'
        : '❌ Model TIDAK ditemukan di manifest');
    try {
      final byteData = await rootBundle.load('assets/model_unquant.tflite');
      _interpreter = Interpreter.fromBuffer(byteData.buffer.asUint8List());

      final labelTxt = await rootBundle.loadString('assets/labels.txt');
      _labels = labelTxt
          .split('\n')
          .where((e) => e.trim().isNotEmpty)
          .toList();

      setState(() {
        _isModelReady = true;
      });
    } catch (e) {
      _showError("Gagal memuat model: $e");
    }
  }

  Future<void> _setupCamera() async {
    final status = await Permission.camera.request();

    if (status.isGranted) {
      final cameras = await availableCameras();
      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
      );

      _controller = CameraController(
        backCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      _initializeControllerFuture = _controller!.initialize();
      setState(() {});
    } else {
      if (mounted) {
        _showError("Akses kamera ditolak");
      }
    }
  }

  Future<void> _performScan() async {
    if (!_isModelReady || _interpreter == null) {
      _showError("Model belum siap sepenuhnya.");
      return;
    }

    if (!(_controller?.value.isInitialized ?? false)) {
      _showError("Kamera belum siap");
      return;
    }

    if (_controller!.value.isTakingPicture) {
      _showError("Kamera sedang mengambil gambar...");
      return;
    }

    try {
      await _initializeControllerFuture;

      final picture = await _controller!.takePicture();
      final bytes = await File(picture.path).readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) {
        _showError("Gagal mengubah gambar");
        return;
      }

      final input = _preprocess(image);
      final outputShape = _interpreter.getOutputTensor(0).shape;
      final output = List.filled(outputShape.reduce((a, b) => a * b), 0.0)
          .reshape(outputShape);

      _interpreter.run(input, output);

      final scores = List<double>.from(output[0]);
      final maxScore = scores.reduce((a, b) => a > b ? a : b);
      final topIndex = scores.indexOf(maxScore);

      final rawLabel = _labels[topIndex];
      final cleanedLabel = rawLabel.replaceFirst(RegExp(r'^\d+\s*'), '');

      final parts = cleanedLabel.split(' ');
      final jenis = parts[0];
      final status = parts.length > 1 ? parts.sublist(1).join(' ') : 'sehat';

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScannerDetailScreen(
              jenisIkan: jenis,
              status: status,
            ),
          ),
        );
      }
    } catch (e) {
      _showError("Scan error: $e");
    }
  }

  Future<void> _performScanFromFile(File file) async {
    if (!_isModelReady || _interpreter == null) {
      _showError("Model belum siap sepenuhnya.");
      return;
    }

    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      _showError("Gagal mengubah gambar dari galeri");
      return;
    }

    final input = _preprocess(image);
    final outputShape = _interpreter.getOutputTensor(0).shape;
    final output = List.filled(outputShape.reduce((a, b) => a * b), 0.0)
        .reshape(outputShape);

    _interpreter.run(input, output);

    final scores = List<double>.from(output[0]);
    final maxScore = scores.reduce((a, b) => a > b ? a : b);
    final topIndex = scores.indexOf(maxScore);

    final rawLabel = _labels[topIndex];
    final cleanedLabel = rawLabel.replaceFirst(RegExp(r'^\d+\s*'), '');

    final parts = cleanedLabel.split(' ');
    final jenis = parts[0];
    final status = parts.length > 1 ? parts.sublist(1).join(' ') : 'sehat';

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScannerDetailScreen(
            jenisIkan: jenis,
            status: status,
          ),
        ),
      );
    }
  }

  List<List<List<List<double>>>> _preprocess(img.Image image) {
    final resized = img.copyResize(image, width: 224, height: 224);
    final imageData = List.generate(224, (y) {
      return List.generate(224, (x) {
        final pixel = resized.getPixel(x, y);
        final r = pixel.r.toDouble();
        final g = pixel.g.toDouble();
        final b = pixel.b.toDouble();
        return [
          (r / 127.5) - 1.0,
          (g / 127.5) - 1.0,
          (b / 127.5) - 1.0,
        ];
      });
    });

    return [imageData];
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    _controller?.dispose();
    if (_isModelReady) {
      _interpreter.close();
    }
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.black,
    body: SafeArea(
      child: Stack(
        children: [
          // Kamera Preview
          _initializeControllerFuture != null
              ? FutureBuilder(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return SizedBox.expand(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CameraPreview(_controller!),
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF45B1F9),
                        ),
                      );
                    }
                  },
                )
              : const Center(child: CircularProgressIndicator()),

          // Judul
          Positioned(
            top: 24,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Nemo.AI Scanner",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ),

          // Flash Button (kiri bawah)
          Positioned(
            bottom: 30,
            left: 30,
            child: GestureDetector(
              onTap: _toggleFlash,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isFlashOn ? Icons.flash_on : Icons.flash_off,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),

          // Galeri Button (kanan bawah)
          Positioned(
            bottom: 30,
            right: 30,
            child: GestureDetector(
              onTap: () async {
                final picker = ImagePicker();
                final picked = await picker.pickImage(source: ImageSource.gallery);
                if (picked != null) {
                  final file = File(picked.path);
                  await _performScanFromFile(file);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.photo_library, color: Colors.white, size: 28),
              ),
            ),
          ),

          // Tombol Scan (tengah bawah)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: _isModelReady ? _performScan : null,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: _isModelReady ? const Color(0xFF45B1F9) : Colors.grey,
                        shape: BoxShape.circle,
                        boxShadow: [
                          if (_isModelReady)
                            BoxShadow(
                              color: const Color(0xFF45B1F9).withOpacity(0.6),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                        ],
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        size: 36,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _isModelReady ? "Scan dari kamera / galeri" : "Memuat model...",
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}