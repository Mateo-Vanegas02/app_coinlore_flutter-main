class CryptoDetailEntity {
  final String id;
  final String symbol;
  final String name;
  final String nameid;
  final double price;
  final double change24h;
  final double change1h;
  final double change7d;
  final double marketCap;
  final double volume;
  final String circulatingSupply;
  final String totalSupply;
  final String maxSupply;
  final double ath;
  final String athDate;
  final String startDate;
  final String platform;
  final String website;
  final String twitter;
  final String explorer;
  final String logo;

  CryptoDetailEntity({
    required this.id,
    required this.symbol,
    required this.name,
    required this.nameid,
    required this.price,
    required this.change24h,
    required this.change1h,
    required this.change7d,
    required this.marketCap,
    required this.volume,
    required this.circulatingSupply,
    required this.totalSupply,
    required this.maxSupply,
    required this.ath,
    required this.athDate,
    required this.startDate,
    required this.platform,
    required this.website,
    required this.twitter,
    required this.explorer,
    required this.logo,
  });
}
