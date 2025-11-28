import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class PontosColetaController extends ChangeNotifier {
  double lat = 0.0;
  double long = 0.0;
  String erro = '';

  PontosColetaController() {
    getPosicao();
  }

  Future<void> getPosicao() async {
    try {
      Position posicao = await posicaoAtual();
      lat = posicao.latitude;
      long = posicao.longitude;
    } catch (e) {
      erro = e.toString();
    }
    notifyListeners();
  }

  Future<Position> posicaoAtual() async {
    LocationPermission permissao;
    bool ativado = await Geolocator.isLocationServiceEnabled();
    if (!ativado) {
      return Future.error('Por favor, habilite a localização no dispositivo.');
    }

    permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        return Future.error('Ative a permissão de localização para o app.');
      }
    }

    if(permissao == LocationPermission.deniedForever) {
      return Future.error('Ative a permissão de localização para o app nas configurações do dispositivo.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
