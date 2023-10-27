import 'dart:developer';

import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DummyScreen extends StatefulWidget {
  const DummyScreen({Key? key}) : super(key: key);

  @override
  State<DummyScreen> createState() => _DummyScreenState();
}

class _DummyScreenState extends State<DummyScreen> {
  int carouselCount = 0;
  //Country List
  List<String> countryList = ["PAKISTAN", "INDIA", "JAPAN", "AUSTRALIA", "RUSSIA", "BELIZE", "BELIZE", "PAKISTAN", "INDIA", "JAPAN", "AUSTRALIA", "RUSSIA", "BELIZE", "BELIZE"];
  CarouselController? carouselController = CarouselController();

  var indicatorController = PageController(viewportFraction: 1, keepPage: true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(),
      body: Center(
          child: Column(
        children: [
          SizedBox(
            height: 0,
            child: PageView.builder(
                itemCount: countryList.length,
                pageSnapping: true,
                clipBehavior: Clip.none,
                controller: indicatorController,
                onPageChanged: (page) {
                  print("page --> ${page}");
                },
                itemBuilder: (context, pagePosition) {
                  return SizedBox();
                }),
          ),
          CarouselSlider(
            // carouselController: indicatorController,
            items: countryList.map((i) {
              // print("CheckIn Image ${ i.imageName.toString()}");

              return Builder(
                builder: (BuildContext context) {
                  return SizedBox(
                    height: Get.width,
                    width: Get.width,
                    /* decoration: BoxDecoration(color: Colors.amber),*/
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        // image: DecorationImage(
                        //   image: NetworkImage("url_image"),
                        //   fit: BoxFit.cover,
                        // ),
                      ),
                      alignment: Alignment.center,
                      child: Text(i),
                    ),
                  );
                },
              );
            }).toList(),
            options: countryList.length > 1
                ? CarouselOptions(
                    height: Get.height * 0.57,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      setState(() {
                        carouselCount = index;
                      });
                      // indicatorController.jumpToPage(index);
                      indicatorController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
                    })
                : CarouselOptions(
                    height: Get.height * 0.57,
                    viewportFraction: 1,
                    scrollPhysics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index, reason) {
                      setState(() {
                        //carouselCount = index;
                      });
                    }),
          ),
          SmoothPageIndicator(
            controller: indicatorController,
            count: countryList.length,
            axisDirection: Axis.horizontal,
            effect: ScrollingDotsEffect(
                fixedCenter: true,
                activeStrokeWidth: 1.5,
                activeDotScale: 1.6,
                maxVisibleDots: 5,
                radius: 8,
                spacing: 10,
                dotHeight: 10,
                dotWidth: 10,
                dotColor: Colors.white.withOpacity(0.5),
                activeDotColor: Colors.white),
          ),
          // CarouselIndicator(
          //   color: Colors.red,
          //   count: countryList.length,
          //   index: carouselCount,
          // ),
        ],
      )),
    );
  }
}
