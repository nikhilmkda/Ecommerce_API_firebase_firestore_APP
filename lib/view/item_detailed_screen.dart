import 'package:flutter/material.dart';
import 'package:flutter_application_e_commerse_app_with_api/controller/hive_save.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../controller/api_call.dart';



class ItemDetailedScreen extends StatelessWidget {
  final String watchname;
  final String availability;
  final String watchbrandNameSmall;
  final Function() tapped;

  final String rating;
  final String watchprice;
  final String discount;
  final String description;
  final String stock;
  final String catagory;

  final List<String> imageURL;

  const ItemDetailedScreen(
      {super.key,
      required this.watchprice,
      required this.rating,
      required this.discount,
      required this.availability,
      required this.tapped,
      required this.watchbrandNameSmall,
      required this.watchname,
      required this.description,
      required this.stock,
      required this.catagory,
      required this.imageURL});

  Column productDetail(dynamic icons, String productshort) {
    return Column(
      children: [
        Icon(
          icons,
          color: Colors.grey.shade400,
          size: 30,
        ),
        Text(
          productshort,
          style: GoogleFonts.oswald(color: Colors.grey, fontSize: 18),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final hivecall = Provider.of<HiveHelper>(context);
    final dataProvider = Provider.of<DataProvider>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    double calculatedHeight(int pixels) {
      return height * pixels / 851;
    }

    double calculatedWidth(int pixels) {
      return width * pixels / 393;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Products',
            style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 78, 78, 78),
                Color.fromARGB(255, 34, 32, 27),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              // showSearch(context: context, delegate: CustomSearchDelegate());
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                onPressed: () {
                  dataProvider.navigateToCart(context);
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 28, top: 5),
                child: Container(
                  height: 20,
                  width: 18,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(child: Text('${hivecall.itemscart.length}')),
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade200,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
            child: Column(
              children: [
                Stack(children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      height: height / 2.5,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 40, left: 20, right: 20),
                    child: SizedBox(
                      height: 250,
                      child: ImageSlideshow(
                        indicatorColor: Colors.blue,
                        onPageChanged: (value) {
                          debugPrint('Page changed: $value');
                        },
                        autoPlayInterval: 3000,
                        isLoop: true,
                        children: List.generate(
                          imageURL.length,
                          (index) => Image.network(
                            imageURL[index],
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 15),
                  child: SizedBox(
                    height: height / 18,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            watchname,
                            style: TextStyle(
                                fontSize: height / 30,
                                color: const Color.fromARGB(166, 0, 0, 0),
                                fontWeight: FontWeight.bold),
                            maxLines: null,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: SizedBox(
                    height: 20,
                    child: Row(
                      children: [
                        Text(
                          watchbrandNameSmall,
                          style: const TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8,
                    top: 8,
                  ),
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    color: const Color.fromARGB(255, 204, 255, 205),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                        bottom: 8,
                        right: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ' \$ $watchprice ',
                            style: const TextStyle(
                                fontSize: 30,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' $discount % off ',
                            style: GoogleFonts.oswald(
                                fontSize: 20,
                                color: const Color.fromARGB(255, 0, 153, 3),
                                fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.blue, size: 20),
                              const Icon(Icons.star,
                                  color: Colors.blue, size: 20),
                              const Icon(Icons.star,
                                  color: Colors.blue, size: 20),
                              const Icon(Icons.star,
                                  color: Colors.blue, size: 20),
                              const Icon(Icons.star_border,
                                  color: Colors.grey, size: 20),
                              const SizedBox(width: 5),
                              Text(
                                rating,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.local_shipping_outlined,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        ' Free Shipping Across India',
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.repeat_rounded,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        ' 7 Day Exchange',
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.store_mall_directory_outlined,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        ' 24 Months Warranty',
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),

                //the grey line
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 5, bottom: 5),
                  child: Container(
                    height: 2,
                    color: Colors.grey.shade300,
                  ),
                ),
                const SizedBox(
                  height: 35,
                  child: Row(
                    children: [
                      Text(
                        'Product Details:',
                        style: TextStyle(
                          color: Color.fromARGB(255, 51, 51, 51),
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: width / 1.06,
                        child: Text(
                          description,
                          softWrap: true,
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Text(
                        'Type',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      Text(
                        catagory,
                        style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 48, 48, 48)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Text(
                        'Domestic Warranty',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      Text(
                        '6 Months',
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 48, 48, 48)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Text(
                        'Made in',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      Text(
                        'China',
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 48, 48, 48)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Text(
                        'Stock',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      Text(
                        '$availability Items',
                        style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 48, 48, 48)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade800,
                  boxShadow: [
                    BoxShadow(
                      color:
                          const Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                height: height / 13.2,
                width: width / 2,
                child: const Center(
                  child: Text(
                    'Buy now',
                    style: TextStyle(
                        fontSize: 22,
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              InkWell(
                onTap: tapped,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    boxShadow: [
                      BoxShadow(
                        color:
                            const Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  height: height / 13.2,
                  width: width / 2,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Add to Cart',
                          style: TextStyle(
                              fontSize: 22,
                              color: Color.fromARGB(203, 0, 0, 0),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8, right: 8, bottom: 8),
                        child: Icon(Icons.shopping_cart_outlined),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
