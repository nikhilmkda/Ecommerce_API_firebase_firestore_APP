import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'api_call.dart';
import 'hive_save.dart';

class CustomWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String starRating;
  final String cost;
  final Function() itemTapped;

  CustomWidget(
      {required this.imageUrl,
      required this.title,
      required this.itemTapped,
      required this.description,
      required this.starRating,
      required this.cost});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    double calculatedHeight(int pixels) {
      return height * pixels / 851;
    }

    double calculatedWidth(int pixels) {
      return width * pixels / 393;
    }

    final dataProvider = Provider.of<DataProvider>(context);

    return InkWell(
      onTap: itemTapped,
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          //borderRadius: BorderRadius.circular(25),
        ),
        width: 190,
        height: 200,
        padding: EdgeInsets.only(
          top: 8,
          left: 8,
          right: 8,
        ),
        child: Column(
          children: [
            Container(
              height: height / 9,
              decoration: BoxDecoration(
                //border: Border.all(width: 2, color: Colors.grey.shade200),
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: NetworkImage(
                    imageUrl,
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.ptSerif(
                        fontSize: 17, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Text(
                    description,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.blue, size: 20),
                      Icon(Icons.star, color: Colors.blue, size: 20),
                      Icon(Icons.star, color: Colors.blue, size: 20),
                      Icon(Icons.star, color: Colors.blue, size: 20),
                      Icon(Icons.star_border, color: Colors.grey, size: 20),
                      SizedBox(width: 5),
                      Text(
                        starRating,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      )
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(' \$ $cost/-',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 2,
              width: 140,
              color: Colors.grey.shade100,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomWidgetItemDetails extends StatelessWidget {
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

  final String imageURL;

  CustomWidgetItemDetails(
      {required this.watchprice,
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
          decoration: BoxDecoration(
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
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
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
                icon: Icon(
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
      body: Column(children: [
        SingleChildScrollView(
          child: Container(
            height: height / 1.2265,
            child: ListView(
              children: [
                SizedBox(
                  height: 30,
                ),
                Stack(children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5, top: 0),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      height: 280,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 14, left: 20, right: 20),
                    child: Container(
                      height: 250,
                      decoration: BoxDecoration(
                          //color: Colors.amber,
                          borderRadius: BorderRadius.circular(25),
                          image: DecorationImage(
                              fit: BoxFit.fitHeight,
                              image: NetworkImage(imageURL))),
                    ),
                  ),
                ]),
                SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(
                        height: 480,
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: SizedBox(
                                height: 33,
                                child: Row(
                                  children: [
                                    Text(
                                      watchname,
                                      style: TextStyle(
                                          fontSize: 28,
                                          color: Color.fromARGB(166, 0, 0, 0),
                                          fontWeight: FontWeight.bold),
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
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8, top: 8),
                              child: Container(
                                height: 60,
                                width: double.infinity,
                                color: Color.fromARGB(255, 204, 255, 205),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8, bottom: 8, right: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        ' \$ $watchprice ',
                                        style: TextStyle(
                                            fontSize: 30,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        ' $discount % off ',
                                        style: GoogleFonts.oswald(
                                            fontSize: 20,
                                            color:
                                                Color.fromARGB(255, 0, 153, 3),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.star,
                                              color: Colors.blue, size: 20),
                                          Icon(Icons.star,
                                              color: Colors.blue, size: 20),
                                          Icon(Icons.star,
                                              color: Colors.blue, size: 20),
                                          Icon(Icons.star,
                                              color: Colors.blue, size: 20),
                                          Icon(Icons.star_border,
                                              color: Colors.grey, size: 20),
                                          SizedBox(width: 5),
                                          Text(
                                            rating,
                                            style: TextStyle(
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
                            Container(
                              height: 30,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.local_shipping_outlined,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
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
                                  Icon(
                                    Icons.repeat_rounded,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
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
                                  Icon(
                                    Icons.store_mall_directory_outlined,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
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
                            SizedBox(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  SizedBox(
                                    width: 350,
                                    child: Text(
                                      description,
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 60),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Text(
                                    'Type',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                  Text(
                                    catagory,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color.fromARGB(255, 48, 48, 48)),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 60),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Text(
                                    'Domestic Warranty',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
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
                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 60),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Text(
                                    'Made in',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
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
                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 60),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Text(
                                    'Stock',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                  Text(
                                    '$availability Items',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color.fromARGB(255, 48, 48, 48)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade800,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Buy now',
                  style: TextStyle(
                      fontSize: 22,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold),
                ),
              ),
              height: calculatedHeight(55),
              width: calculatedWidth(195),
            ),
            InkWell(
              onTap: tapped,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white54,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                height: height / 13.12,
                width: width / 2,
                child: Row(
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
                      padding:
                          const EdgeInsets.only(top: 8, right: 8, bottom: 8),
                      child: Icon(Icons.shopping_cart_outlined),
                    )
                  ],
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }
}
