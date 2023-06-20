class LbcDataModel {
  String? courseName;
  List<TitleModel>? topics;

  LbcDataModel({this.courseName, this.topics});

  LbcDataModel.fromJson(Map<String, dynamic> json) {
    courseName = json['CourseName'];
    if (json['Topics'] != null) {
      topics = [];
      json['Topics'].forEach((courseJson) {
        topics!.add(TitleModel.fromJson(courseJson));
      });
    }
  }
}

class TitleModel {
  String? topicName;
  String? searchTerm;
  List<String>? syllabus;

  TitleModel({this.topicName, this.syllabus, this.searchTerm});

  TitleModel.fromJson(Map<String, dynamic> json) {
    topicName = json['TopicName'];
    syllabus = List<String>.from(json['Syllabus']);
    searchTerm = json['SearchTerm'];
  }
}