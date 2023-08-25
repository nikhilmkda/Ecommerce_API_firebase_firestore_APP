import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

import '../view/add_cart_costomwidget.dart';
import 'api_call.dart';
import 'hive_save.dart';
import '../view/homepage.dart';

class Cart_page extends StatefulWidget {
  const Cart_page({super.key});

  @override
  State<Cart_page> createState() => _Cart_pageState();
}

class _Cart_pageState extends State<Cart_page> {
  final HiveHelper hiveHelper = HiveHelper();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final dataProvider = Provider.of<DataProvider>(context);
    final hivecall = Provider.of<HiveHelper>(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'My Cart',
          style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold),
        ),
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
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.home,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 2, color: Colors.grey),
            ),
            height: height / 8,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Deliver to:'),
                  ElevatedButton(onPressed: () {}, child: const Text('Change')),
                ],
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: height / 1.45,
              width: width,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 1.65,
                ),
                itemCount: hivecall.itemscart.length,
                itemBuilder: (BuildContext context, int index) {
                  return Custom_widget_cart(
                    itemName: dataProvider
                        .productsofproduct[hivecall.itemscart[index]].title,
                    deliveryDate: 'Monday 8',
                    freeDelivery: 'freeDelivery',
                    rating: dataProvider
                        .productsofproduct[hivecall.itemscart[index]].rating
                        .toString(),
                    itemPrice: dataProvider
                        .productsofproduct[hivecall.itemscart[index]].price
                        .toString(),
                    imageURL: dataProvider
                        .productsofproduct[hivecall.itemscart[index]]
                        .images
                        .first,
                    itemTapped: () {
                      hivecall.removeCartItemhive(index);

                      // print('${hivecall.itemscart}');
                      // print('${hivecall.totalcartPrice}');
                    },
                    qtydecrement: () {
                      hivecall.itemQTYidecrement(
                          index,
                          dataProvider
                              .productsofproduct[hivecall.itemscart[index]]
                              .price);
                      //   print('QTY LIst decrement ${hivecall.itemQTyList}');
                    },
                    qtyincrement: () {
                      hivecall.itemQTYincrement(
                          index,
                          dataProvider
                              .productsofproduct[hivecall.itemscart[index]]
                              .price);
                      //   print('QTY LIst increment ${hivecall.itemQTyList}');
                    },
                    quantityItem: hivecall.itemQTyList.isEmpty
                        ? 0
                        : hivecall.itemQTyList[index],
                    discount: dataProvider
                        .productsofproduct[hivecall.itemscart[index]]
                        .discountPercentage
                        .toString(),
                  );
                },
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white54,
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  height: height / 13.8,
                  width: width,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 4, right: 8),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade800,
                      ),
                      onPressed: () {},
                      child: Text(
                        'Place Order',
                        style: GoogleFonts.actor(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      )),
                ),
                FutureBuilder(
                  future: hiveHelper.getIntListCart(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Row(
                        children: [
                          SizedBox(
                            height: 40,
                            child: LoadingIndicator(
                              indicatorType: Indicator.lineScaleParty,
                              colors: [Colors.blue.shade800],
                              strokeWidth: 4.0,
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      hivecall.totalCartPriceSum = hivecall.totalcartPrice.fold(
                          0,
                          (previousValue, element) => previousValue + element);
                      //  print('the price sum is ${hivecall.totalCartPriceSum}');
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10, left: 10),
                          child: Text(
                            'Total : \$ ${hivecall.totalCartPriceSum}',
                            style: GoogleFonts.openSans(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
