import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String fname;
  final String lname;
  final String email;
  final String uid;
  final String photoURL;
  final List<String> households;
  final String inventory;
  final List<String> invitations;

  const User({
    required this.lname,
    required this.email,
    required this.fname,
    required this.uid,
    required this.photoURL,
    required this.households,
    required this.inventory,
    required this.invitations,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
