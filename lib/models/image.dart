import 'package:json_annotation/json_annotation.dart';
import 'package:minsk8/import.dart';

part 'image.g.dart';

@JsonSerializable()
class ImageModel {
  final String url;
  final int width;
  final int height;

  ImageModel({
    this.url,
    this.width,
    this.height,
  });

  getDummyUrl(String id) {
    final urlHash = generateMd5(url + id);
    return 'https://picsum.photos/seed/$urlHash/${width ~/ 4}/${height ~/ 4}'; // TODO: url
  }

  getLargeDummyUrl(String id) {
    return getDummyUrl(id);
  }

  // ImageProvider createNetworkImage() {
  //   return ExtendedNetworkImageProvider(imageUrl);
  // }

  // ImageProvider createResizeImage() {
  //   return ResizeImage(ExtendedNetworkImageProvider(imageUrl),
  //       width: width ~/ 5, height: height ~/ 5);
  // }

  // for SliverListConfig.collectGarbage
  // void clearCache() {
  //   createNetworkImage().evict();
  //   createResizeImage().evict();
  // }

  factory ImageModel.fromJson(Map<String, dynamic> json) =>
      _$ImageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ImageModelToJson(this);
}
