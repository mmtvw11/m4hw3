import 'package:equatable/equatable.dart';

class CityModel extends Equatable {
  final String name;
  final String country;
  final double latitude;
  final double longitude;
  final String? state;

  const CityModel({
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
    this.state,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      name: json['name'] ?? 'Unknown',
      country: json['country'] ?? 'Unknown',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'state': state,
    };
  }

  String get displayName {
    if (state != null && state!.isNotEmpty) {
      return '$name, $state ($country)';
    }
    return '$name, $country';
  }

  @override
  List<Object?> get props => [name, country, latitude, longitude, state];
}
