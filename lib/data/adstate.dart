import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  Future<InitializationStatus> initialization;
  AdState(this.initialization);

  String get districtPageBannerAdUnitId =>
      'ca-app-pub-9509653663198315/2893222963';

  String get pinPageBannerAdUnitId => 'ca-app-pub-9509653663198315/5519386300';

  BannerAdListener get adListener => _adListener;

  BannerAdListener _adListener =
      BannerAdListener(onAdClosed: (ad) => print('Ad Closed : ${ad.adUnitId}'));
}
