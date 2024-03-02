import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:photomanagerpackage/ShowPicture.dart';

class PhotosGallery extends StatefulWidget {
  const PhotosGallery({super.key});
  static Future show(context) async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.hasAccess) {
      // Granted.

      return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.green,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        builder: (context) => const PhotosGallery(),
      );
    } else {
      // Limited(iOS) or Rejected, use `==` for more precise judgements.
      // You can call `PhotoManager.openSetting()` to open settings for further steps.
      // Fluttertoast.showToast(msg: "permission_not_granted");
      log("Permission not granted to selete Image");
    }
  }

  @override
  State<PhotosGallery> createState() => _PhotosGalleryState();
}

class _PhotosGalleryState extends State<PhotosGallery> {
  List<AssetEntity> medias = [];
  final int _sizePerPage = 50;
  // AssetEntity? selectedEntity;
  List<AssetEntity> selectedEntity = [];
  bool processing = true;
  int currentPage = 0;
  bool finalLoad = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      // Obtain assets using the path entity.
      loadGallery(0);
    });
  }

  void loadGallery(int from) async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.hasAccess == false) return;
    log("load gallery called");
    if (finalLoad) return;
    processing = true;
    final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
      onlyAll: true,
      type: RequestType.image,
    );
    if (!mounted) {
      return;
    }
    if (paths.isEmpty) {
      // Fluttertoast.showToast(msg: 'No paths found.');
      return;
    }
    AssetPathEntity? path = paths.first;
    int totalEntitiesCount = await path.assetCountAsync;
    var newGallery = await path.getAssetListPaged(
      page: currentPage,
      size: _sizePerPage,
    );

    if (newGallery.isEmpty) {
      finalLoad = true;
    } else {
      medias.addAll(newGallery);
    }
    processing = false;
    setState(() {});
    currentPage++;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Manager'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height / 2,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 15, top: 15),
        child: SafeArea(
          child: Column(
            children: [
              const Center(
                child: Text(
                  'Photos',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: medias.isEmpty
                    ? const Center(
                        child: Text(
                        'Photo Gallery is empty',
                        style: TextStyle(),
                      ))
                    : NotificationListener(
                        onNotification: (scrollInfo) {
                          if (scrollInfo is OverscrollIndicatorNotification) {
                            scrollInfo.disallowIndicator();
                          }
                          if (scrollInfo is ScrollNotification) {
                            log(scrollInfo.metrics.toString());
                            if (!processing &&
                                scrollInfo.metrics.pixels >
                                    (scrollInfo.metrics.maxScrollExtent *
                                        0.8)) {
                              processing = true;
                              loadGallery(medias.length);
                            }
                          }
                          return true;
                        },
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 150,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 1 / 1,
                          ),
                          itemBuilder: ((context, index) => ImageItemWidget(
                                onTap: () {
                                  final asset = medias[index];
                                  setState(() {
                                    // selectedEntity = medias[index];
                                    if (selectedEntity.contains(asset)) {
                                      selectedEntity.remove(asset);
                                    } else {
                                      selectedEntity.add(asset);
                                    }
                                    // selectedEntity.add(medias[index]);
                                  });
                                },
                                // selected: selectedEntity == medias[index],
                                selected:
                                    selectedEntity.contains(medias[index]),
                                key: ValueKey<int>(index),
                                entity: medias[index],
                                option: const ThumbnailOption(
                                  size: ThumbnailSize.square(200),
                                ),
                              )),
                          itemCount: medias.length,
                        ),
                      ),
              ),
              const SizedBox(height: 30),
              TextButton(
                child:
                    Text(selectedEntity == null ? "Select a photo" : "Confirm"),
                onPressed: () async {
                  // final File? fileString = await selectedEntity!.originFile;
                  // final File? fileString = await selectedEntity!.;

                  final List<File?> files = [];
                  for (var i = 0; i < selectedEntity.length; i++) {
                    files.add(await selectedEntity[i].originFile);
                  }
                  // setState(() {});
                  print('call');

                  // Get.back(result: [
                  //   {"value": files}
                  // ]);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SHowPic(images: files)));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageItemWidget extends StatelessWidget {
  const ImageItemWidget({
    super.key,
    required this.entity,
    required this.option,
    required this.selected,
    this.onTap,
  });

  final AssetEntity entity;
  final ThumbnailOption option;
  final VoidCallback? onTap;
  final bool selected;

  Widget buildContent(BuildContext context) {
    if (entity.type == AssetType.audio) {
      return const Center(
        child: Icon(Icons.audiotrack, size: 30),
      );
    }
    return _buildImageWidget(context, entity, option);
  }

  Widget _buildImageWidget(
    BuildContext context,
    AssetEntity entity,
    ThumbnailOption option,
  ) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: AssetEntityImage(
            entity,
            isOriginal: false,
            thumbnailSize: option.size,
            thumbnailFormat: option.format,
            fit: BoxFit.cover,
          ),
        ),
        PositionedDirectional(
          bottom: 4,
          start: 0,
          end: 0,
          child: Row(
            children: [
              if (entity.isFavorite)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.redAccent,
                    size: 16,
                  ),
                ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (entity.isLivePhoto)
                      Container(
                        margin: const EdgeInsetsDirectional.only(end: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 3,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(4),
                          ),
                          color: Theme.of(context).cardColor,
                        ),
                        child: const Text(
                          'LIVE',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (selected)
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              padding: const EdgeInsets.all(2.5),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap!,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: buildContent(context),
      ),
    );
  }
}
