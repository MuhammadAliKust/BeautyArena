import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

import '../../../../../infrastructure/models/categories.dart';
import '../../../../../infrastructure/models/dashboard.dart';
import '../../../explore_screen/explore_view.dart';


class PosterWidget extends StatelessWidget {
  final Poster model;
  const PosterWidget({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: (){
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => ExploreView(category: Datum(
            //           id: model.
            //         ))));
          },
          child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: 13),
              width: MediaQuery.of(context)
                  .size
                  .width,
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(8),
              ),
              child: ClipRRect(
                  borderRadius:
                  BorderRadius.circular(8),
                  child:   ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(

                      imageUrl: model.image.toString(),
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Image.asset(
                        'assets/images/ph.jpg',
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/images/ph.jpg',
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ))),
        ),
        // Positioned.fill(
        //   bottom: 70,
        //   child: Align(
        //     alignment: Alignment.bottomCenter,
        //     child: Container(
        //       decoration: BoxDecoration(
        //           borderRadius:
        //           BorderRadius.circular(
        //               7),
        //           color: Colors.white),
        //       child: Padding(
        //         padding: const EdgeInsets
        //             .symmetric(
        //             horizontal: 40,
        //             vertical: 10),
        //         child: Text(
        //           'Shop Now!',
        //           style: const TextStyle(
        //               fontSize: 14,
        //               fontWeight:
        //               FontWeight.w600,
        //               color:
        //               Color(0xff313131)),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        // Positioned.fill(
        //   bottom: 30,
        //   child: Align(
        //     alignment: Alignment.bottomCenter,
        //     child: new DotsIndicator(
        //       dotsCount: 3,
        //       axis: Axis.horizontal,
        //       decorator: DotsDecorator(
        //         color: Color(0xff707070),
        //         // Inactive color
        //         activeColor: Colors.white,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}


