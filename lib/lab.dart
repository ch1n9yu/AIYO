import 'dart:typed_data';
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:aiyo11/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Lab());
}

class Lab extends StatefulWidget {
  const Lab({super.key});
  @override
  State<Lab> createState() => _LabState();
}

class _LabState extends State<Lab> {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  int numPhotos = 100;
  Socket? _socket;
  bool isSocketConnected = false;
  String serverMessage = ''; // 用來存來自Server的消息
  String connectionMessage = ''; // 用來顯示連接狀態

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    _initializeCamera();
  }

  Future<void> _checkPermissions() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      _controller = CameraController(cameras![0], ResolutionPreset.medium);
      await _controller!.initialize();
      // 禁用閃光燈
      await _controller!.setFlashMode(FlashMode.off);
      setState(() {});
      await _connectToServer();
      _receiveMessages(); //收server訊息
      await captureAndSaveImages();
    } else {
      print("Can not find the camera");
    }
  }

  Future<void> _connectToServer() async {
    try {
      _socket = await Socket.connect('192.168.0.108', 12345); // 替換為伺服器的IP和端口
      setState(() {
        isSocketConnected = true;
        connectionMessage = 'Connected to server'; // 更新連接訊息
      });

      // 隱藏訊息，在3秒後
      Future.delayed(Duration(seconds: 8), () {
        setState(() {
          connectionMessage = ''; // 清空訊息，隱藏圓框
        });
      });
      print('Connected to server');
    } catch (e) {
      setState(() {
        connectionMessage = 'Failed to connect to server'; // 更新錯誤訊息
      });
      // 隱藏錯誤訊息，在3秒後
      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          connectionMessage = ''; // 清空訊息
        });
      });
      print('Error when connecting to server: $e');
    }
  }

  void _receiveMessages() {
    if (_socket != null) {
      _socket!.listen(
        (Uint8List data) {
          String message = utf8.decode(data);
          setState(() {
            serverMessage = message;
          });
          print('Message from server: $message');
        },
        onError: (error) {
          print('Error receiving data: $error');
          _socket?.close();
        },
        onDone: () {
          print('Server disconnected');
          _socket?.close();
        },
      );
    } else {
      print("Socket is not connected");
    }
  }

  Future<void> captureAndSaveImages() async {
    if (!_controller!.value.isInitialized) {
      print("Camera not initialized yet");
      return;
    }
    final directory = await getExternalStorageDirectory();
    final dirPath = '${directory!.path}/pose_image';
    final dir = Directory(dirPath);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    await Future.delayed(Duration(seconds: 4));
    print("Start taking picture!");

    for (int i = 0; i < numPhotos; i++) {
      final photoFile = await _controller!.takePicture();
      final photoFilename = '$dirPath/captured_image_${i + 1}.png';
      await photoFile.saveTo(photoFilename);
      print("Image saved as '$photoFilename'");

      if (isSocketConnected) {
        await sendImageOverSocket(photoFilename);
      }
      await Future.delayed(Duration(seconds: 3));
    }
    print("All images saved");
  }

  Future<void> sendImageOverSocket(String imagePath) async {
    try {
      File imageFile = File(imagePath);
      if (await imageFile.exists()) {
        //讀取圖片為byte
        List<int> imageData = await imageFile.readAsBytes();
        //圖片識別號為1開頭
        _socket!.add(
            (ByteData(4)..setInt32(0, 1, Endian.big)).buffer.asUint8List());
        //圖片大小
        _socket!.add(
            (ByteData(4)..setInt32(0, imageData.length)).buffer.asUint8List());
        //圖片數據
        _socket!.add(imageData);
        print("Image sent: $imagePath");
        await _socket!.flush(); //刷新數據
      } else {
        print("Image does not exist: $imagePath");
      }
    } catch (e) {
      print("Error when sending image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'AIYO',
            style: TextStyle(
              color: Color(0xFF6563A5),
              fontSize: 25,
            ),
          ),
          backgroundColor: Color(0xFFBDB5BA),
        ),
        body: Stack(
          children: [
            // Camera Preview 或其他主要內容
            Positioned.fill(
              child: _controller == null || !_controller!.value.isInitialized
                  ? Center(child: CircularProgressIndicator())
                  : CameraPreview(_controller!),
            ),

            // Positioned 圓框，顯示 connectionMessage 或 serverMessage
            Positioned(
              top: 20, // 距離螢幕上方 20 個像素
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Color(0xFFBDB5BA), // 背景顏色
                  borderRadius: BorderRadius.circular(30), // 圓角邊框
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: Offset(0, 3), // 陰影效果
                    ),
                  ],
                ),
                child: Text(
                  connectionMessage.isNotEmpty
                      ? connectionMessage // 如果有連接訊息，顯示該訊息
                      : ' $serverMessage', // 否則顯示來自伺服器的訊息
                  textAlign: TextAlign.center, // 文字居中顯示
                  style: TextStyle(
                    fontSize: 16, // 文字大小
                    color: Color(0xFF6563A5), // 使用色碼設定 Server Message 字體顏色
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _socket?.close();
    super.dispose();
  }
}