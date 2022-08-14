class Donars
{
  String? donarsName;
  String? donarsUID;
  String? donarsAvatarUrl;
  String? donarsEmail;

  Donars({
    this.donarsUID,
    this.donarsName,
    this.donarsAvatarUrl,
    this.donarsEmail,
  });

  Donars.fromJson(Map <String, dynamic> json)
  {
    donarsUID = json["donarsUID"];
    donarsName = json["donarsName"];
    donarsAvatarUrl = json["donarsAvatarUrl"];
    donarsEmail = json["donarsEmail"];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["donarsUID"] = this.donarsUID;
    data["donarsName"] = this.donarsName;
    data["donarsAvatarUrl"] = this.donarsAvatarUrl;
    data["donarsEmail"] = this.donarsEmail;
    return data;
  }
}