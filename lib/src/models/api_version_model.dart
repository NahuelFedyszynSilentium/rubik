
class ApiVersionModel {
  String? version;

  ApiVersionModel({
     this.version,
  });

  ApiVersionModel.fromJson(Map<String, dynamic> json) {
    version = json["version"];
  }

}