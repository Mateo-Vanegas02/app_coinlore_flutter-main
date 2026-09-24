import 'package:app_coinlore_flutter/features/crypto_charts/domain/entities/market_pair_entity.dart';

class MarketPairModel extends MarketPairEntity {
  const MarketPairModel({
    required super.exchangeName,
    required super.base,
    required super.quote,
    required super.price,
    required super.priceUsd,
    required super.volume,
    required super.volumeUsd,
    required super.time,
  });

  factory MarketPairModel.fromJson(Map<String, dynamic> json) {
    return MarketPairModel(
      exchangeName: json['name']?.toString() ?? 'Desconocido',
      base: json['base']?.toString() ?? '',
      quote: json['quote']?.toString() ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      priceUsd: double.tryParse(json['price_usd']?.toString() ?? '0') ?? 0.0,
      volume: double.tryParse(json['volume']?.toString() ?? '0') ?? 0.0,
      volumeUsd: double.tryParse(json['volume_usd']?.toString() ?? '0') ?? 0.0,
      time: int.tryParse(json['time']?.toString() ?? '0') ?? 0,
    );
  }
}
