import 'package:flutter/material.dart';
import 'package:mapa/models/ponto_coleta.dart';

class PontoDetalhes extends StatelessWidget {
  final PontoColeta ponto;
  const PontoDetalhes({
    super.key,
    required this.ponto,
  });

  String _extractInfo(String info, String key) {
    // Remove tags HTML e quebras de linha
    String cleanedInfo = info.replaceAll(RegExp(r'<[^>]*>'), '').replaceAll('\r', '').replaceAll('\n', ' ').trim();
    // Procura o índice da chave
    int keyIndex = cleanedInfo.indexOf('$key: ');
    if (keyIndex == -1) return '';
    int valueStart = keyIndex + ('$key: ').length;
    // Procura o próximo campo (ex: "Quantidade:", "Data:", etc)
    final nextField = RegExp(r'([A-Za-zÀ-ÿ]+):');
    final match = nextField.firstMatch(cleanedInfo.substring(valueStart));
    int valueEnd;
    if (match != null) {
      valueEnd = valueStart + match.start;
    } else {
      valueEnd = cleanedInfo.length;
    }
    // Retorna apenas o valor da key, sem incluir outros campos
    return cleanedInfo.substring(valueStart, valueEnd).replaceAll(RegExp(r'([A-Za-zÀ-ÿ]+):.*'), '').trim();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ponto.properties.tipoDeColeta,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.location_on, 'Endereço', _extractInfo(ponto.properties.descricao, 'Endereço')),
                _buildInfoRow(Icons.build, 'Equipamento', _extractInfo(ponto.properties.descricao, 'Equipamento')),
                _buildInfoRow(Icons.calendar_today, 'Frequência', _extractInfo(ponto.properties.descricao, 'Frequencia')),
                _buildInfoRow(Icons.access_time, 'Período', _extractInfo(ponto.properties.descricao, 'Periodo')),
                if (_extractInfo(ponto.properties.descricao, 'Histórico').isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Histórico',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _extractInfo(ponto.properties.descricao, 'Histórico'),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 22, color: Colors.blueGrey),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
