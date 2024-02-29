class UserPost {
  final String name;
  final String phoneno;
  final String subCategories;
  final String postedAt;
  final String size;
  final String number;
  final String mainDocId;
  final String available;
  final String type;
  final String price;
  final bool sold;

  UserPost( {
    required this.name,
    required this.mainDocId,
    required this.phoneno,
    required this.subCategories,
    required this.postedAt,
    required this.size,
    required this.number,
    required this.available,
    required this.type,
    required this.price,
    required this.sold,
  });

  factory UserPost.fromJson(Map<String, dynamic> json) {
    return UserPost(
      name: json['Name'] ?? '',
      phoneno: json['phoneno'] ?? '',
      subCategories: json['SubCategories'] ?? '',
      postedAt: json['posted_at'] ?? '',
      size: json['Size'] ?? '',
      number: json['Number'] ?? '',
      available: json['Available'] ?? '',
      type: json['Type'] ?? '',
      price: json['Price'] ?? '',
      mainDocId: json['mainDocId'] ?? '',
      sold: json['sold'] ?? false,
    );
  }
}
