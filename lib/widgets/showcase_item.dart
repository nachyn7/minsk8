import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:minsk8/import.dart';

class ShowcaseItem extends StatefulWidget {
  ShowcaseItem({
    Key key,
    this.item,
    this.index,
    this.tag,
  }) : super(key: key);

  final ItemModel item;
  final int index;
  final String tag;

  @override
  _ShowcaseItemState createState() {
    return _ShowcaseItemState();
  }
}

class _ShowcaseItemState extends State<ShowcaseItem> {
  bool isBottom = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            // Navigator.of(context).push(PageRouteBuilder(
            //   settings: RouteSettings(
            //     arguments: ItemRouteArguments(item, tag: tag),
            //   ),
            //   pageBuilder: (context, animation, secondaryAnimation) =>
            //       ItemScreen(),
            //   transitionsBuilder:
            //       (context, animation, secondaryAnimation, child) {
            //     return child;
            //   },
            // ));
            setState(() {
              isBottom = false;
            });
            Navigator.pushNamed(
              context,
              '/item',
              arguments: ItemRouteArguments(
                widget.item,
                tag: widget.tag,
                member: widget.item.member,
                isShowcase: true,
              ),
            ).then((value) {
              setState(() {
                isBottom = true;
              });
            });
          },
          child: Hero(
            tag: widget.tag,
            child: _buildImage(widget.item),
          ),
        ),
        // SizedBox(
        //   height: 5.0,
        // ),
        // _buildTags(item),
        // SizedBox(
        //   height: 5.0,
        // ),
        if (isBottom)
          _buildBottom(widget.item),
        // SizedBox(
        //   height: 8.0,
        // ),
      ],
    );
  }

  Widget _buildImage(ItemModel item) {
    // final itemEndTime = DateTime.now().millisecondsSinceEpoch +
    //     // 1000 * 60 * 60 * 24 * 1 +
    //     1000 * 10;
    final image = item.images[0];
    return AspectRatio(
      aspectRatio: image.width / image.height,
      child:
          // ClipRRect(
          // borderRadius: BorderRadius.all(kImageBorderRadius),
          // child:
          Stack(
        fit: StackFit.expand,
        children: [
          ExtendedImage.network(
            image.getDummyUrl(item.id),
            fit: BoxFit.fill,
            // shape: BoxShape.rectangle,
            // border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1.0),
            // borderRadius: BorderRadius.all(kImageBorderRadius),
            loadStateChanged: loadStateChanged,
          ),
          _buildText(item.text),
          if (item.isBlocked ?? false)
            _buildStatus(
              'Заблокировано',
              isClosed: true,
            )
          else if (item.transferredAt != null)
            _buildStatus(
              'Забрали',
              isClosed: true,
            )
          else if (item.win != null)
            _buildStatus(
              'Завершено',
              isClosed: true,
            )
          else if (item.expiresAt != null)
            CountdownTimer(
              endTime: item.expiresAt.millisecondsSinceEpoch,
              builder: (BuildContext context, int seconds) {
                return _buildStatus(
                  seconds < 1 ? 'Завершено' : formatDDHHMMSS(seconds),
                  isClosed: seconds < 1,
                );
              },
            )
          else if (item.urgent != UrgentStatus.none)
            _buildStatus(
              urgents
                  .firstWhere((urgentModel) => urgentModel.value == item.urgent)
                  .name,
              isClosed: false,
            ),
          // _buildTopRightLabel(item.images.length.toString()),
        ],
      ),
    );
  }

  Widget _buildBottom(ItemModel item) {
    return Row(
      children: [
        // ExtendedImage.network(
        //   item.avatarUrl,
        //   width: 25.0,
        //   height: 25.0,
        //   shape: BoxShape.circle,
        //   //enableLoadState: false,
        //   border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1.0),
        //   // loadStateChanged: (state) {
        //   //   if (state.extendedImageLoadState == LoadState.completed) {
        //   //     return null;
        //   //   }
        //   //   return Image.asset("assets/avatar.jpeg");
        //   // },
        // ),
        // SizedBox(
        //   width: 16.3,
        // ),
        item.price == null ? GiftButton(item) : PriceButton(item),
        Spacer(),
        SizedBox(
          width: kButtonWidth,
          height: kButtonHeight,
          child: ShareButton(item),
        ),
        SizedBox(
          width: kButtonWidth,
          height: kButtonHeight,
          child: WishButton(item),
        ),
      ],
    );
  }

  Widget _buildText(String text) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            colors: [
              Colors.grey.withOpacity(0.0),
              Colors.black.withOpacity(0.4),
            ],
          ),
        ),
        padding: EdgeInsets.only(
          left: 8.0,
          top: 32.0,
          right: 8.0,
          bottom: 8.0,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  _buildStatus(String data, {bool isClosed}) {
    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: isClosed
              ? Colors.grey.withOpacity(0.8)
              : Colors.pink.withOpacity(0.8),
          // border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1.0),
          // borderRadius: BorderRadius.all(Radius.circular(6.5)),
          // borderRadius: BorderRadius.only(
          //   // topLeft: kImageBorderRadius,
          //   bottomRight: kImageBorderRadius,
          // ),
        ),
        child: Text(
          data,
          style: TextStyle(
            fontSize: kFontSize,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

// Widget _buildTags(TuChongItem item) {
//   return Wrap(
//     runSpacing: 5.0,
//     spacing: 5.0,
//     children: item.tags.map<Widget>((tag) {
//       final color = item.tagColors[item.tags.indexOf(tag)];
//       return Container(
//         padding: EdgeInsets.all(3.0),
//         decoration: BoxDecoration(
//           color: color,
//           border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1.0),
//           borderRadius: BorderRadius.all(
//             Radius.circular(5.0),
//           ),
//         ),
//         child: Text(
//           tag,
//           textAlign: TextAlign.start,
//           style: TextStyle(
//               fontSize: fontSize,
//               color:
//                   color.computeLuminance() < 0.5 ? Colors.white : Colors.black),
//         ),
//       );
//     }).toList(),
//   );
// }

  Widget _buildTopRightLabel(String data) {
    return Positioned(
      top: 5.0,
      right: 5.0,
      child: Container(
        padding: EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          // color: Colors.grey.withOpacity(0.6),
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.withOpacity(0.4),
            width: 1.0,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: Text(
          data,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: kFontSize * 1.6,
            color: Colors.orange,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
