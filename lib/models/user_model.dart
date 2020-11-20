class User {
  final String id;
  final String name;
  final String mob;
  static var dic_mob;

  User({
    this.id,
    this.name,
    this.mob,
  });

  void setdicmob(var temp){
    dic_mob = temp;
  }
}
