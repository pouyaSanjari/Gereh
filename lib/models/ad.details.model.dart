class Model {
  double lat;
  double lon;
  String title;
  String imageUrl;
  String adId;
  String category;
  List images;

  Model(
      {required this.lat,
      required this.images,
      required this.category,
      required this.adId,
      required this.lon,
      required this.title,
      required this.imageUrl});
}
