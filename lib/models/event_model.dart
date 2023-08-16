class EventModel {
  final String id;
  final String name;
  final String imageUrl;
  final String startDate;
  final String endDate;
  final String info;
  final bool isInWishlist;
  final String genre;

  EventModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.info,
    required this.isInWishlist,
    required this.genre,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    // Logging the entire JSON for debugging purposes
    // print("Parsing event: $json");

    // Safely extract startDate and endDate
    String? startDate = json['dates']?['start']?['dateTime'] as String?;
    String? endDate = json['dates']?['end']?['dateTime'] as String?;

    return EventModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['images'][1]['url'] as String, // Using the first image URL
      startDate: startDate ?? 'Unknown Start Date',
      endDate: endDate ?? 'Unknown End Date',
      info: (json['info'] ?? '') as String,
      isInWishlist: false, // defaulting to false
      genre: (json['classifications'][0]?['genre']?['name'] ?? '') as String,
    );
  }
}
