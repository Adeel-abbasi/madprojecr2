class DataModel {
  final int? id;
  final String work;
  final String description;

  DataModel(
      {this.id,
      required this.work,
      required this.description,});

  DataModel.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        work = res["work"],
        description = res["description"];

  Map<String, Object> toMap() {
  if (id != null) {
    return {
      "id": id!,
      "work": work,
      "description": description,
    };
  } else {
    return {
      "work": work,
      "description": description,
    };
  }
}
}
