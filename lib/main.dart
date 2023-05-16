// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebView Example',
      home: WebViewExample(),
    );
  }
}

class WebViewExample extends StatefulWidget {
  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      LocationPermission newPermission =
          await Geolocator.requestPermission();
      if (newPermission == LocationPermission.denied) {
        // Exiba um diálogo ou uma mensagem informando ao usuário que a permissão de localização é necessária para a funcionalidade da aplicação.
        print('Permissão de localização negada.');
      } else if (newPermission == LocationPermission.deniedForever) {
        // Exiba um diálogo ou uma mensagem informando ao usuário que a permissão de localização foi negada permanentemente e que ele precisa ativá-la manualmente nas configurações do dispositivo.
        print('Permissão de localização negada permanentemente.');
      } else {
        // A permissão de localização foi concedida.
        _loadWebView();
      }
    } else {
      // A permissão de localização já foi concedida.
      _loadWebView();
    }
  }

  void _loadWebView() {
    setState(() {
      _isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            WebView(
              initialUrl: 'https://mobile.wecare.vc/public/', // URL que você deseja carregar na WebView
              javascriptMode: JavascriptMode.unrestricted, // Modo JavaScript habilitado
              onPageFinished: (String url) {
                setState(() {
                  _isLoading = false;
                });
              },
            ),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Container(),
          ],
        ),
      ),
    );
  }
}
