import 'dart:math';

class GeolocatorUtils {
  static const double earthRadiusKm = 6371.01;

  static double degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    double dLat = degreesToRadians(lat2 - lat1);
    double dLon = degreesToRadians(lon2 - lon1);

    lat1 = degreesToRadians(lat1);
    lat2 = degreesToRadians(lat2);

    double a = haversine(dLat) + cos(lat1) * cos(lat2) * haversine(dLon);
    double c = 2 * asin(sqrt(a));
    return earthRadiusKm * c;
  }

  static double haversine(double theta) {
    return pow(sin(theta / 2), 2).toDouble();
  }
}