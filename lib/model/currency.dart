class UserData {
  final String createdAt;
  final String name;
  final String avatar;
  final String like;
  final String address;
  final String city;
  final String job;
  final String id;

  UserData(
      {required this.createdAt,
      required this.name,
      required this.avatar,
      required this.like,
      required this.address,
      required this.city,
      required this.job,
      required this.id});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      createdAt: json['createdAt'],
      name: json['name'],
      avatar: json['avatar'],
      like: json['like'],
      address: json['address'],
      city: json['city'],
      job: json['job'],
      id: json['id'],
    );
  }
}

class ProductData {
  final int id;
  final String title;
  final String description;
  final double price;
  final String image;
  final String category;
  final Map<String, dynamic> rating;

  ProductData({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    required this.rating,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    final ratingJson = json['rating'];
    final rating = {
      'count': ratingJson['count'],
      'rate': ratingJson['rate'].toDouble(),
    };
    return ProductData(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      image: json['image'],
      category: json['category'],
      rating: rating,
    );
  }
}
