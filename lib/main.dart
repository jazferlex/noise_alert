import 'dart:typed_data';
import 'dart:math';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Noise Listener',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NoiseListener(),
    );
  }
}




class NoiseListener extends StatefulWidget {
  const NoiseListener({super.key});

  @override
  _NoiseListenerState createState() => _NoiseListenerState();
}

class _NoiseListenerState extends State<NoiseListener> {
  final FlutterAudioCapture _audioCapture = FlutterAudioCapture();
  List<FlSpot> decibelData = [];
  bool _isRecording = false;
  double _currentDecibel = 0.0;

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    await Permission.microphone.request();
    if (await Permission.microphone.isGranted) {
      _startRecording();
    } else {
      // Handle permission denial gracefully
    }
  }
  void listener(dynamic obj) {
    var buffer = Float64List.fromList(obj.cast<double>());
    var newDecibelLevel = calculateDecibelLevel(buffer);
    if (newDecibelLevel.isFinite) {
      setState(() {
        _currentDecibel = newDecibelLevel;
        decibelData.add(FlSpot(decibelData.length.toDouble(), _currentDecibel));
      });
    }
  }
  double calculateDecibelLevel(Float64List buffer) {
      // Convert the audio buffer to a List
    List<double> audioData = List.from(buffer);

    // Calculate the root mean square (RMS) of the audio signal
    double rms = sqrt(audioData.map((x) => x * x).reduce((a, b) => a + b) / audioData.length);

    // Set a reference amplitude (you may need to adjust this based on your specific use case)
    double referenceAmplitude = 1.0;

    // Calculate the decibel level using the formula

    double decibelLevel = 20 * log(rms / referenceAmplitude);

    return decibelLevel;
  }

  void onError(Object obj) {
    print(obj);
  }

  void _startRecording() async {
    await _audioCapture.start(listener, onError, sampleRate: 16000, bufferSize: 3000);
    setState(() {
      _isRecording = true;
    });
  }

  void _stopRecording() async {
    await _audioCapture.stop();
    setState(() {
      _isRecording = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Noise Listener'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Text('Current Noise Level: ${_currentDecibel.toStringAsFixed(2)} dB'),
            // Add other UI elements based on noise detection (e.g., notifications)
          ],
        ),
        
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isRecording ? _stopRecording : _startRecording,
        child: Icon(_isRecording ? Icons.stop : Icons.mic),
      ),
    );
  }
}

