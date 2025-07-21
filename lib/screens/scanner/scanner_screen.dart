import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

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
            _initializeControllerFuture != null
                ? FutureBuilder(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return SizedBox.expand(
                          child: CameraPreview(_controller!),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  )
                : const Center(child: CircularProgressIndicator()),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.qr_code_scanner, size: 48, color: Colors.white),
                      onPressed: _isModelReady ? _performScan : null,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _isModelReady ? 'Tekan untuk mulai scan' : 'Memuat model...',
                      style: const TextStyle(color: Colors.white, fontSize: 15),
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
