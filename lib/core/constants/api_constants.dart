class ApiConstants {
  static const String baseUrl = 'https://api.coinlore.net/api';

  // Endpoints
  static const String globalStats = '$baseUrl/global/';
  static const String tickers = '$baseUrl/tickers/';
  static const String ticker = '$baseUrl/ticker/';

  // CDN logos
  static String logoUrl(String nameid) =>
      'https://www.coinlore.com/img/$nameid.png';
}
