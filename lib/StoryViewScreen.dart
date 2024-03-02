import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photomanagerpackage/controller/storyController.dart';
import 'package:story_view/widgets/story_view.dart';

class StoriesScreen extends StatelessWidget {
  StoriesScreen({super.key});
  final storyControl = Get.put(StoriesController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: storyControl.dummyDataList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => Get.to(() =>
                    StoryViewScreen(user: storyControl.dummyDataList[index])),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                          storyControl.dummyDataList[index].image ?? ''),
                    ),
                    Text(storyControl.dummyDataList[index].name ?? '')
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class StoryViewScreen extends StatefulWidget {
  final User user;

  const StoryViewScreen({super.key, required this.user});

  @override
  State<StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen> {
  final storyControl = Get.find<StoriesController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        child: SizedBox(
          height: 399,
          child: Stack(
            children: [
              // if (widget.user.obs == false)

              Positioned.fill(
                child: StoryView(
                  controller: storyControl.controller,
                  storyItems: List.generate(
                    widget.user.stories?.length ?? 0,
                    (index) {
                      if (widget.user.stories![index].type == 0) {
                        return StoryItem.text(
                          title: widget.user.stories![index].content ?? '',
                          // "aaaaa",
                          backgroundColor: Colors.orange,
                          roundedTop: true,
                        );
                      }
                      if (widget.user.stories![index].type == 1) {
                        return StoryItem.inlineImage(
                          url: widget.user.stories![index].image ?? '',
                          // "aaaaa",

                          roundedTop: true, controller: storyControl.controller,
                        );
                      }
                      if (widget.user.stories![index].type == 2) {
                        return StoryItem.pageVideo(
                          controller: storyControl.controller,
                          widget.user.stories![index].video ?? '',

                          // url: widget.user.stories![index].image ?? '',
                          // // "aaaaa",

                          // roundedTop: true, controller: storyControl.controller,
                        );
                      }
                      return StoryItem.text(
                        title: widget.user.stories![index].content ?? '',
                        // "aaaaa",
                        backgroundColor: Colors.orange,
                        roundedTop: true,
                      );
                    },
                  ),
                  //       onStoryShow: (storyItem) {
                  //   print('Story shown: ${storyItem.caption}');
                  // },
                  onComplete: () {
                    print('All stories have been viewed');
                  },
                ),
              ),
              if (widget.user.own == false)
                Positioned(
                  top: 100,
                  left: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () {
                      _showModalBottomSheet(context);
                    },
                    child: const Icon(
                      Icons.linked_camera,
                      color: Colors.red,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(18)),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Viewers',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                    ),
                    Icon(
                      Icons.close,
                      size: 24,
                    )
                  ],
                ),
                const SizedBox(height: 0),
                Expanded(
                  // height: 149,
                  child: ListView.separated(
                      padding: EdgeInsets.zero,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      // cacheExtent: 60,
                      itemCount: 55,
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const UserImageView(
                              url:
                                  "https://images.unsplash.com/photo-1708246116930-98cdc77b46c9?w=300&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw0MDF8fHxlbnwwfHx8fHw%3D"),
                          title: const Text(
                            "NAME",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    // Color(0xff20191366),
                                    // Color(0xff20191366),
                                    Color(0xffFFFFFF),
                                    Color(0xffC890EB),

                                    // Color(0xffD797FF),
                                    // // Color(0x0ff00000)
                                    // Color(0xffd797ff00)
                                  ]),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: Colors.white
                                  // border: Border.all(color: const Color(0xffD797FF)
                                  // )
                                  ),
                              child: const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Text('View Profile',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: Color(0xff201913)))),
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class UserImageView extends StatelessWidget {
  final height = 100;
  final width = 100;

  final String url;

  const UserImageView({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: Image(
        image: NetworkImage(
          url,
        ),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.broken_image,
            size: 50,
          );
        },
      ),
    );
  }
}
