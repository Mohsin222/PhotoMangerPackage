// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:story_view/controller/story_controller.dart';

class StoriesController extends GetxController {
  RxList<User> dummyDataList = [
    User(
        id: 1,
        name: "ali",
        own: true,
        image:
            'https://images.unsplash.com/photo-1708443683295-5b9b4a125687?w=300&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw2Mnx8fGVufDB8fHx8fA%3D%3D',
        stories: [
          StoryModel(
              id: 1,
              name: "Mohsin",
              image: "aaa",
              content: "FFFF",
              video: "aaaaaaaaaa",
              type: 0),
          StoryModel(
            id: 1,
            name: "John",
            image:
                "https://images.unsplash.com/photo-1708771754562-163e2994c815?w=300&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw3NHx8fGVufDB8fHx8fA%3D%3D",
            content: "GGGG",
            video: "bbbbbbbbbb",
            type: 1,
          ),
          StoryModel(
            id: 1,
            name: "John",
            image: "bbb",
            content: "GGGG",
            video:
                "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
            type: 2,
          ),
        ]),
    User(
        id: 2,
        name: "Amir",
        own: false,
        image:
            'https://images.unsplash.com/photo-1706449603978-fe8a25d52198?w=300&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyNzB8fHxlbnwwfHx8fHw%3D',
        stories: [
          StoryModel(
              id: 1,
              name: "Mohsin",
              image: "aaa",
              content: "FFFF",
              video: "aaaaaaaaaa",
              type: 0),
          StoryModel(
            id: 1,
            name: "John",
            image:
                "https://images.unsplash.com/photo-1477064601209-5ed2b9f3b1fc?w=300&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyODV8fHxlbnwwfHx8fHw%3D",
            content: "GGGG",
            video: "bbbbbbbbbb",
            type: 1,
          ),
          StoryModel(
            id: 1,
            name: "John",
            image: "bbb",
            content: "GGGG",
            video:
                "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
            type: 2,
          ),
        ]),
  ].obs;
  final StoryController controller = StoryController();

  @override
  void onClose() {
    controller.dispose();
    // TODO: implement onClose
    super.onClose();
  }
}

class User {
  int? id;

  bool? own;
  String? name;
  String? image;
  List<StoryModel>? stories;

  User({this.id, this.name, this.stories, this.image, this.own});

  // Named constructor with a named parameter 'fromJson' for deserialization
  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        image = json['image'],
        own = json['own'] ?? false,
        stories = (json['Stories'] as List<dynamic>?)
            ?.map((e) => StoryModel.fromJson(e))
            .toList();
}

class StoryModel {
  int? id;
  String? name;
  String? image;
  String? content;
  String? video;
  int? type;

  StoryModel(
      {this.id, this.name, this.image, this.content, this.video, this.type});

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      type: json['type'] as int?,
      id: json['id'] as int?,
      name: json['name'] as String?,
      image: json['Image'] as String?,
      content: json['content'] as String?,
      video: json['video'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'Image': image,
      'content': content,
      'video': video,
      'type': type
    };
  }
}
