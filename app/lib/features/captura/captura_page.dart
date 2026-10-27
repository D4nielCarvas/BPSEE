import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../providers.dart';
import '../resultado/resultado_page.dart';

class CapturaPage extends ConsumerStatefulWidget {
  const CapturaPage({super.key});

  @override
  ConsumerState<CapturaPage> createState() => _CapturaPageState();
}

class _CapturaPageState extends ConsumerState<CapturaPage> {
  CameraController? _controller;
  bool _ready = false;
  String? _erroCamera;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cams = await availableCameras();
      if (cams.isEmpty) {
        if (mounted) setState(() => _erroCamera = 'Nenhuma câmera disponível.');
        return;
      }
      _controller = CameraController(cams.first, ResolutionPreset.high);
      await _controller!.initialize();
      if (mounted) setState(() => _ready = true);
    } catch (e) {
      if (mounted) setState(() => _erroCamera = 'Câmera indisponível: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _usar(String path) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final nome = 'bpsee_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final dest = '${dir.path}/$nome';
      await File(path).copy(dest);
      ref.read(analiseSessionProvider.notifier).setImage(dest);
    } catch (_) {
      ref.read(analiseSessionProvider.notifier).setImage(path);
    }
    if (mounted) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const ResultadoPage()));
    }
  }

  Future<void> _tirarFoto() async {
    if (_controller == null || !_ready) return;
    final x = await _controller!.takePicture();
    await _usar(x.path);
  }

  Future<void> _daGaleria() async {
    final x = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (x != null) await _usar(x.path);
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(analiseSessionProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Captura — ${session.modo?.label ?? ''}')),
      body: Column(
        children: [
          Expanded(
            child: _ready && _controller != null
                ? CameraPreview(_controller!)
                : (_erroCamera != null
                    ? Center(
                        child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(_erroCamera!),
                      ))
                    : const Center(child: CircularProgressIndicator())),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledButton.icon(
                  onPressed: (_ready && _controller != null) ? _tirarFoto : null,
                  icon: const Icon(Icons.camera),
                  label: const Text('Tirar foto'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _daGaleria,
                  icon: const Icon(Icons.photo),
                  label: const Text('Escolher da galeria'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
