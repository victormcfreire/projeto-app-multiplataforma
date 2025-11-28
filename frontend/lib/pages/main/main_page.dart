import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapa/models/ponto_coleta.dart';
import 'package:mapa/pages/main/controller/api_controller.dart';
import 'package:mapa/pages/main/controller/auth_flow.dart';
import 'package:mapa/pages/main/controller/pontos_coleta_controller.dart';
import 'package:mapa/widgets/ponto_detalhes.dart';
import 'package:provider/provider.dart';

final appKey = GlobalKey();

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final ApiController api = ApiController();
  // Guardar os parsers de cada arquivo
  final Map<String, GeoJsonParser> parsers = {
    "turnosColeta": GeoJsonParser(),
    "pontosColeta": GeoJsonParser(),
  };

  final MapController mapController = MapController();

  // Controle de visibilidade
  bool mostrarTurnosColeta = false;
  bool mostrarPontosColeta = true;
  List<PontoColeta> pontosColetaList = [];
  bool _isLoggedIn = false;
  List<Polygon> _turnosPolygons = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        _showLoginDialog();
      });
    });
  }

  void _zoomAteLocalizacao(BuildContext buildContext) async {
    await buildContext.read<PontosColetaController>().getPosicao();
    final pontos = buildContext.read<PontosColetaController>();
    if (pontos.lat != 0 && pontos.long != 0) {
      mapController.move(
        LatLng(pontos.lat, pontos.long),
        16, // nível de zoom desejado
      );
    }
  }

  void _showLoginDialog() {
    AuthFlow.start(
      context,
      onLoginSuccess: () async {
        setState(() => _isLoggedIn = true);

        await Future.delayed(const Duration(milliseconds: 200));

        final providerContext = appKey.currentContext;
        if (providerContext != null) {
          _zoomAteLocalizacao(providerContext);
          _loadFiles();
        }
      },
    );
  }

  Future<void> _loadFiles() async {
    final pontosResp = await api.getPontosColeta();
    final turnosResp = await api.getTurnosColeta();

    if (pontosResp.statusCode == 200 && turnosResp.statusCode == 200) {
      final pontosData = jsonDecode(pontosResp.body);
      final turnosData = jsonDecode(turnosResp.body);

      parsers["pontosColeta"]!.parseGeoJson(pontosData);
      // Guardamos o JSON dos turnos para gerar cores depois
      parsers["turnosColeta"]!.parseGeoJson(turnosData);

      pontosColetaList = (pontosData['features'] as List)
          .map((e) => PontoColeta.fromJson(e as Map<String, dynamic>))
          .toList();

      // Cria os polígonos com cores
      final List features = turnosData['features'] as List;
      for (var feature in features) {
        final turno = (feature['properties']?['Turno'] ?? '')
            .toString()
            .trim()
            .toUpperCase();
        Color cor;
        switch (turno) {
          case 'DIURNO':
            cor = Colors.green.withValues(alpha: 0.5);
            break;
          case 'NOTURNO':
            cor = Colors.blue.withValues(alpha: 0.5);
            break;
          default:
            cor = Colors.grey.withValues(alpha: 0.5);
        }

        final coords = feature['geometry']?['coordinates'];
        if (coords == null) continue;

        final parts = extractPolygonsFromCoords(coords);
        for (var part in parts) {
          // Garante que o flutter_map receba só polígonos válidos (pelo menos 3 pontos)
          if (part.length < 3) continue;
          _turnosPolygons.add(Polygon<Object>(
            points: part,
            color: cor,
            borderColor: Colors.black,
            borderStrokeWidth: 1.0,
          ));
        }
      }
      print(_turnosPolygons);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao carregar dados do servidor")),
      );
    }

    setState(() {});
  }

  List<List<LatLng>> extractPolygonsFromCoords(dynamic coords) {
    bool isPosition(dynamic v) =>
        v is List && v.length >= 2 && (v[0] is num) && (v[1] is num);

    bool isLinearRing(dynamic v) =>
        v is List && v.isNotEmpty && isPosition(v[0]);

    bool isPolygonCoords(dynamic v) =>
        v is List && v.isNotEmpty && isLinearRing(v[0]);

    bool isMultiPolygonCoords(dynamic v) =>
        v is List && v.isNotEmpty && isPolygonCoords(v[0]);

    List<LatLng> toLatLngList(List posList) {
      final list = <LatLng>[];
      for (var p in posList) {
        if (p is List && p.length >= 2 && p[0] is num && p[1] is num) {
          final lon = (p[0] as num).toDouble();
          final lat = (p[1] as num).toDouble();
          // valida ranges básicos
          if (lat.abs() <= 90 && lon.abs() <= 180) {
            list.add(LatLng(lat, lon));
          }
        }
      }
      // Remove último ponto se for igual ao primeiro (GeoJSON fecha anel repetindo o primeiro)
      if (list.length > 1 &&
          list.first.latitude == list.last.latitude &&
          list.first.longitude == list.last.longitude) {
        list.removeLast();
      }
      return list;
    }

    final parts = <List<LatLng>>[];

    if (isPolygonCoords(coords)) {
      // coords: [ [ [lon,lat], ... ], [hole...], ... ]
      final outerRing = coords[0] as List;
      final pts = toLatLngList(outerRing);
      if (pts.length >= 3) parts.add(pts);
    } else if (isMultiPolygonCoords(coords)) {
      // coords: [ [ [ [lon,lat], ... ], [hole...] ], [ [ [lon,lat] ... ] ], ... ]
      for (var poly in (coords as List)) {
        if (poly is List && poly.isNotEmpty && isLinearRing(poly[0])) {
          final outer = poly[0] as List;
          final pts = toLatLngList(outer);
          if (pts.length >= 3) parts.add(pts);
        }
      }
    } else {
      // Fallback: busca por qualquer sequência de posições e agrupa em um único polígono
      // (não ideal, mas evita crash em formatos estranhos)
      void collect(dynamic c, List<LatLng> acc) {
        if (isPosition(c)) {
          final lon = (c[0] as num).toDouble();
          final lat = (c[1] as num).toDouble();
          if (lat.abs() <= 90 && lon.abs() <= 180) acc.add(LatLng(lat, lon));
        } else if (c is List) {
          for (var item in c) collect(item, acc);
        }
      }

      final acc = <LatLng>[];
      collect(coords, acc);
      if (acc.length >= 3) parts.add(acc);
    }

    return parts;
  }

  Future<void> centralizeUser(BuildContext buildContext) async {
    await buildContext.read<PontosColetaController>().getPosicao();
    final pontos = buildContext.read<PontosColetaController>();
    if (pontos.lat != 0.0 && pontos.long != 0.0) {
      mapController.move(LatLng(pontos.lat, pontos.long), 16);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PontosColetaController(),
      child: Builder(
        builder: (context) {
          final pontosColeta = context.watch<PontosColetaController>();
          final LatLng? localAtual =
              (pontosColeta.lat != 0.0 && pontosColeta.long != 0.0)
                  ? LatLng(pontosColeta.lat, pontosColeta.long)
                  : null;
          return Scaffold(
            key: appKey,
            appBar: AppBar(title: const Text("Green City")),
            drawer: Drawer(
              child: ListView(
                children: [
                  const DrawerHeader(
                    child: Text("Camadas disponíveis"),
                  ),
                  CheckboxListTile(
                    title: const Text("Turnos de Coleta"),
                    value: mostrarTurnosColeta,
                    onChanged: (v) =>
                        setState(() => mostrarTurnosColeta = v ?? false),
                  ),
                  CheckboxListTile(
                    title: const Text("Pontos de Coleta"),
                    value: mostrarPontosColeta,
                    onChanged: (v) =>
                        setState(() => mostrarPontosColeta = v ?? false),
                  ),
                  const Divider(),
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context); //fecha o drawer
                      await api.logout();
                      setState(() {
                        _isLoggedIn = false;
                        pontosColetaList = [];
                        mapController.move(
                            const LatLng(-3.730451, -38.521799), 12);
                      });
                      _showLoginDialog();
                    },
                    child: const Text("Sair"),
                  ),
                ],
              ),
            ),
            body: Stack(
              children: [
                FlutterMap(
                  mapController: mapController,
                  options: const MapOptions(
                    initialCenter: LatLng(-3.730451, -38.521799), // Fortaleza
                    initialZoom: 12,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',
                      userAgentPackageName: 'com.example.app',
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    if (localAtual != null && _isLoggedIn)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: localAtual,
                            width: 40,
                            height: 40,
                            child: Icon(
                              Icons.my_location,
                              color: Colors.blue[600]!,
                              size: 30,
                              fontWeight: FontWeight.bold,
                              applyTextScaling: true,
                            ),
                          ),
                        ],
                      ),
                    if (mostrarTurnosColeta)
                      PolygonLayer(
                        polygons: _turnosPolygons,
                      ),
                    if (mostrarPontosColeta)
                      MarkerLayer(
                        markers: pontosColetaList.map((ponto) {
                          final lat = ponto.geometry.coordinates[1];
                          final long = ponto.geometry.coordinates[0];
                          return Marker(
                            point: LatLng(lat, long),
                            width: 40,
                            height: 40,
                            child: IconButton(
                              icon: const Icon(Icons.location_on),
                              color: Colors.indigo,
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) =>
                                      PontoDetalhes(ponto: ponto),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
                if (_isLoggedIn)
                  Positioned(
                    right: 12,
                    bottom: 14,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LegendaItem(
                            cor: Colors.blue[600]!,
                            texto: 'Localização Atual',
                            icone: Icons.my_location,
                          ),
                          const LegendaItem(
                            cor: Colors.green,
                            texto: "Turno Diurno",
                            icone: Icons.square,
                          ),
                          const LegendaItem(
                            cor: Colors.blue,
                            texto: "Turno Noturno",
                            icone: Icons.square,
                          ),
                          const LegendaItem(
                            cor: Colors.indigo,
                            texto: "Ponto de Coleta",
                            icone: Icons.location_on,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            floatingActionButton: _isLoggedIn
                ? Padding(
                  padding: const EdgeInsets.only(bottom: 140.0),
                  child: FloatingActionButton(
                      onPressed: () async {
                        await centralizeUser(context);
                      },
                      child: const Icon(Icons.my_location),
                    ),
                )
                : null,
          );
        },
      ),
    );
  }
}

class LegendaItem extends StatelessWidget {
  final Color cor;
  final String texto;
  final IconData icone;
  const LegendaItem({
    super.key,
    required this.cor,
    required this.texto,
    required this.icone,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icone, color: cor),
          const SizedBox(width: 6),
          Text(texto),
        ],
      ),
    );
  }
}
