import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/crypto_entity.dart';

class CryptoModel extends CryptoEntity {
  CryptoModel({
    required String id,
    required int rank,
    required String symbol,
    required String name,
    required String nameid,
    required double priceUsd,
    required double percentChange24h,
    required double percentChange1h,
    required double percentChange7d,
    required double marketCapUsd,
    required double volume24,
  }) : super(
          id: id,
          rank: rank,
          symbol: symbol,
          name: name,
          nameid: nameid,
          priceUsd: priceUsd,
          percentChange24h: percentChange24h,
          percentChange1h: percentChange1h,
          percentChange7d: percentChange7d,
          marketCapUsd: marketCapUsd,
          volume24: volume24,
          logoUrl: ApiConstants.logoUrl(nameid),
        );

  factory CryptoModel.fromJson(Map<String, dynamic> json) {
    return CryptoModel(
      id: json['id']?.toString() ?? '',
      rank: int.tryParse(json['rank']?.toString() ?? '0') ?? 0,
      symbol: json['symbol']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      nameid: json['nameid']?.toString() ?? '',
      priceUsd: double.tryParse(json['price_usd']?.toString() ?? '0') ?? 0.0,
      percentChange24h:
          double.tryParse(json['percent_change_24h']?.toString() ?? '0') ?? 0.0,
      percentChange1h:
          double.tryParse(json['percent_change_1h']?.toString() ?? '0') ?? 0.0,
      percentChange7d:
          double.tryParse(json['percent_change_7d']?.toString() ?? '0') ?? 0.0,
      marketCapUsd:
          double.tryParse(json['market_cap_usd']?.toString() ?? '0') ?? 0.0,
      volume24: double.tryParse(json['volume24']?.toString() ?? '0') ?? 0.0,
    );
  }
}
