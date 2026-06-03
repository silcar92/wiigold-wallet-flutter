class EasypostTracker {
  final String id;
  final String trackingCode;
  final String status;
  final String publicUrl;
  final String carrier;
  final List<TrackingDetail> trackingDetails;

  EasypostTracker({
    required this.id,
    required this.trackingCode,
    required this.status,
    required this.publicUrl,
    required this.carrier,
    required this.trackingDetails,
  });

  factory EasypostTracker.fromJson(Map<String, dynamic> json) {
    var detailsList = json['tracking_details'] as List? ?? [];
    List<TrackingDetail> details =
        detailsList.map((i) => TrackingDetail.fromJson(i)).toList();
    details.sort((a, b) => b.datetime.compareTo(a.datetime));

    return EasypostTracker(
      id: json['id'] ?? '',
      trackingCode: json['tracking_code'] ?? 'N/A',
      status: json['status'] ?? 'unknown',
      publicUrl: json['public_url'] ?? '',
      carrier: json['carrier'] ?? 'N/A',
      trackingDetails: details,
    );
  }
}

class TrackingDetail {
  final String message;
  final String status;
  final DateTime datetime;
  final TrackingLocation? location;

  TrackingDetail({
    required this.message,
    required this.status,
    required this.datetime,
    this.location,
  });

  factory TrackingDetail.fromJson(Map<String, dynamic> json) {
    return TrackingDetail(
      message: json['message'] ?? 'Status update',
      status: json['status'] ?? 'unknown',
      datetime: DateTime.tryParse(json['datetime'] ?? '') ?? DateTime.now(),
      location:
          json['tracking_location'] != null
              ? TrackingLocation.fromJson(json['tracking_location'])
              : null,
    );
  }
}

class TrackingLocation {
  final String? city;
  final String? state;
  final String? country;
  final String? zip;

  TrackingLocation({this.city, this.state, this.country, this.zip});

  factory TrackingLocation.fromJson(Map<String, dynamic> json) {
    return TrackingLocation(
      city: json['city'],
      state: json['state'],
      country: json['country'],
      zip: json['zip'],
    );
  }

  @override
  String toString() {
    return [
      city,
      state,
      country,
      zip,
    ].where((s) => s != null && s.isNotEmpty).join(', ');
  }
}
