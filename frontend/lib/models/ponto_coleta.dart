class PontoColeta {
  final String id;
  final String geometryName;
  final Geometry geometry;
  final Properties properties;

  PontoColeta({
    required this.id,
    required this.geometryName,
    required this.geometry,
    required this.properties,
  });

  factory PontoColeta.fromJson(Map<String, dynamic> json) {
    return PontoColeta(
      id: json['id'] as String,
      geometryName: json['geometry_name'] as String,
      geometry: Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
      properties: Properties.fromJson(json['properties'] as Map<String, dynamic>),
    );
  }
}

class Geometry {
  final String type;
  final List<double> coordinates;

  Geometry({
    required this.type,
    required this.coordinates,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      type: json['type'] as String,
      coordinates: (json['coordinates'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
    );
  }
}

class Properties {
  final int id;
  final int fid;
  final String nome;
  final String descricao;
  final String tipoDeColeta;
  final String regional;
  final String fonte;
  final String ano;
  final String srcDaCamada;
  final String codificacao;

  Properties({
    required this.id,
    required this.fid,
    required this.nome,
    required this.descricao,
    required this.tipoDeColeta,
    required this.regional,
    required this.fonte,
    required this.ano,
    required this.srcDaCamada,
    required this.codificacao,
  });

  factory Properties.fromJson(Map<String, dynamic> json) {
    return Properties(
      id: json['id'] as int,
      fid: json['fid'] as int,
      nome: json['Nome'] as String,
      descricao: json['Descrição'] as String,
      tipoDeColeta: json['Tipo de coleta'] as String,
      regional: json['Regional'] as String,
      fonte: json['Fonte'] as String,
      ano: json['Ano'] as String,
      srcDaCamada: json['SRC da camada'] as String,
      codificacao: json['Codificação'] as String,
    );
  }
}