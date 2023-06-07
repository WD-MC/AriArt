class AppUser {
  final String uid;

  AppUser({required this.uid}) ;
}

class AppUserData {
  late final String uid;
  late final String name;
  late final int number;

  AppUserData({required this.uid, required this.name, required this.number});
}