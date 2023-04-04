import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_e_commerse_app_with_api/user_details/get_user_data.dart';
import 'package:flutter_application_e_commerse_app_with_api/user_details/google_sign_in.dart';
import 'package:flutter_application_e_commerse_app_with_api/progress_indicator.dart/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'costom_widget.dart';

import 'api_call.dart';
import 'drawer.dart';
import 'hive_save.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final HiveHelper hiveHelper = HiveHelper();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      Provider.of<DataProvider>(context, listen: false).fetchData();
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    final hivecall = Provider.of<HiveHelper>(context);
    final getuser = Provider.of<UserDataProvider>(context);
    final authenticationProvider = Provider.of<GoogleSignInProvider>(context);
    var itemsOfAPI = dataProvider.productsofproduct;
    return Scaffold(
      key: _scaffoldKey,
      drawer: Consumer<UserDataProvider>(
        builder: (context, userDataProvider, child) {
          final authUser = FirebaseAuth.instance.currentUser;
          if (authUser != null) {
            if (authUser.providerData
                .any((provider) => provider.providerId == 'google.com')) {
              // User signed in with Google
              return StreamBuilder<Map<String, dynamic>>(
                stream: userDataProvider.getUserDetailsgoogle(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data!;
                    return DrawerScreen('${data['name']}', '${data['email']}');
                  } else {
                    return DrawerScreen('User not found', 'Email not found');
                  }
                },
              );
            } else if (authUser.providerData
                .any((provider) => provider.providerId == 'password')) {
              // User signed in with email/password
              return StreamBuilder<Map<String, dynamic>>(
                stream: userDataProvider.getUserData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data!;
                    return DrawerScreen(
                        '${data['fullName']}', '${data['email']}');
                  } else {
                    return DrawerScreen('User not found', 'Email not found');
                  }
                },
              );
            }
          }
          // User not signed in
          return const SizedBox.shrink();
        },
      ),
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
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
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
                  child: Center(
                    child: FutureBuilder<Map<String, List<int>>>(
                      future: hiveHelper.getIntListCart(),
                      builder: (BuildContext context,
                          AsyncSnapshot<Map<String, List<int>>> snapshot) {
                        if (snapshot.hasData) {
                          hivecall.itemscart = snapshot.data!['itemscart']!;
                          return Text('${hivecall.itemscart.length}');
                        }
                        return const Text('!');
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: dataProvider.isLoading
            ? SizedBox(
                height: 30,
                width: 100,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballRotateChase,
                  colors: kDefaultRainbowColors,
                ),
              )
            : FutureBuilder<Map<String, List<int>>>(
                future: hiveHelper.getIntListCart(),
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, List<int>>> snapshot) {
                  if (snapshot.hasData) {
                    hivecall.itemscart = snapshot.data!['itemscart']!;
                    hivecall.totalcartPrice = snapshot.data!['totalcartPrice']!;
                    hivecall.itemQTyList = snapshot.data!['itemQTyList']!;
                    hivecall.totalCartPriceSum = hivecall.totalcartPrice.fold(
                        0, (previousValue, element) => previousValue + element);

                    print('the price sum is ${hivecall.totalCartPriceSum}');
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, childAspectRatio: 0.9),
                      itemCount: itemsOfAPI.length,
                      itemBuilder: (context, index) => CustomWidget(
                        imageUrl: itemsOfAPI[index].images.first,
                        title: itemsOfAPI[index].title,
                        description: itemsOfAPI[index].brand,
                        cost: itemsOfAPI[index].price.toString(),
                        starRating: itemsOfAPI[index].rating.toString(),
                        itemTapped: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CustomWidgetItemDetails(
                                        watchprice:
                                            itemsOfAPI[index].price.toString(),
                                        rating:
                                            itemsOfAPI[index].rating.toString(),
                                        watchbrandNameSmall:
                                            itemsOfAPI[index].brand,
                                        watchname: itemsOfAPI[index].title,
                                        imageURL:
                                            itemsOfAPI[index].images.first,
                                        catagory: itemsOfAPI[index].category,
                                        description:
                                            itemsOfAPI[index].description,
                                        stock:
                                            itemsOfAPI[index].stock.toString(),
                                        tapped: () {
                                          int cartitems =
                                              itemsOfAPI[index].id - 1;
                                          print('${hivecall.itemscart}');
                                          print('${hivecall.totalcartPrice}');
                                          if (hivecall.itemscart
                                              .contains(cartitems)) {
                                            // Item is already in the cart
                                            return;
                                          }
                                          hivecall.totalcartPrice
                                              .add(itemsOfAPI[index].price);
                                          hivecall.itemCartAddindex(cartitems);
                                          hivecall.saveIntListCart(
                                              hivecall.itemscart,
                                              hivecall.totalcartPrice,
                                              hivecall.itemQTyList);
                                          hivecall.itemQTyList.add(1);
                                          print(
                                              'QTY LIst ${hivecall.itemQTyList}');
                                        },
                                        availability: dataProvider
                                            .productsofproduct[index].stock
                                            .toString(),
                                        discount: dataProvider
                                            .productsofproduct[index]
                                            .discountPercentage
                                            .toString(),
                                      )));
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {
                    // Handle the error case
                    return Text("Error: ${snapshot.error}");
                  } else {
                    // Show a loading indicator while waiting for the data
                    return const SizedBox(
                      height: 30,
                      width: 50,
                      child: LoadingIndicator(
                        indicatorType: Indicator.ballTrianglePath,
                        colors: kDefaultRainbowColors,
                      ),
                    );
                  }
                },
              ),
      ),
    );
  }
}
