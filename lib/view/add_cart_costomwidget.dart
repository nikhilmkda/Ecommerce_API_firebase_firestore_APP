import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Custom_widget_cart extends StatelessWidget {
  final String itemName;
  final int quantityItem;
  final String discount;
  final String deliveryDate;
  final String freeDelivery;
  final String rating;
  final String itemPrice;
  final Function() qtyincrement;
  final Function() qtydecrement;

  final String imageURL;
  final Function() itemTapped;

  Custom_widget_cart(
      {required this.itemName,
      required this.itemTapped,
      required this.discount,
      required this.quantityItem,
      required this.qtyincrement,
      required this.qtydecrement,
      required this.deliveryDate,
      required this.freeDelivery,
      required this.rating,
      required this.itemPrice,
      required this.imageURL});

  @override
  Widget build(BuildContext context) {
    // final dataProvider = Provider.of<DataProvider>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    double calculatedHeight(int pixels) {
      return height * pixels / 851;
    }

    double calculatedWidth(int pixels) {
      return width * pixels / 393;
    }

    return InkWell(
      onTap: () {},
      child: Container(
        color: Colors.blue.shade50,
        height: 260,
        child: Stack(
          children: [
            Column(
              children: [
                Row(children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: height / 9,
                          width: width / 4,
                          decoration: BoxDecoration(
                            border: Border.all(width: 2),
                            borderRadius: BorderRadius.circular(2),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                imageURL,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            height: height / 18,
                            width: width / 4,
                            decoration:
                                BoxDecoration(border: Border.all(width: 2)),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Center(
                                  child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: qtyincrement,
                                    child: Text(
                                      '+',
                                      style: TextStyle(
                                        fontSize: height / 35,
                                      ),
                                    ),
                                  ),
                                  Text('Qty   $quantityItem'),
                                  InkWell(
                                      onTap: qtydecrement,
                                      child: Text('-',
                                          style: TextStyle(
                                              fontSize: height / 35))),
                                ],
                              )),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, top: 8, bottom: 5),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 20,
                              child: Text(
                                'Delivery by $deliveryDate',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: Text(
                          freeDelivery,
                          style: TextStyle(
                              fontSize: height / 65,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 0, left: 0),
                          child: Container(
                            height: height / 19,
                            width: width / 1.6,
                            child: Text(
                              itemName,
                              style: TextStyle(
                                  fontSize: height / 40,
                                  color: Color.fromARGB(166, 0, 0, 0),
                                  // overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            children: [
                              Icon(Icons.star,
                                  color: Colors.blue, size: height / 35),
                              Icon(Icons.star,
                                  color: Colors.blue, size: height / 35),
                              Icon(Icons.star,
                                  color: Colors.blue, size: height / 35),
                              Icon(Icons.star,
                                  color: Colors.blue, size: height / 35),
                              Icon(Icons.star_border,
                                  color: Colors.grey, size: height / 35),
                              SizedBox(width: 5),
                              Text(
                                rating,
                                style: TextStyle(
                                    fontSize: height / 45,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              )
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 80),
                                  child: Row(
                                    children: [
                                      Text(
                                        '\$ $itemPrice',
                                        style: TextStyle(
                                            fontSize: height / 33,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        ' $discount % off ',
                                        style: GoogleFonts.oswald(
                                            fontSize: height / 50,
                                            color:
                                                Color.fromARGB(255, 0, 153, 3),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ]),
                ]),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 0),
                  child: Container(
                    height: 3,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 150, right: 10, bottom: 45),
                child: InkWell(
                  onTap: itemTapped,
                  child: Container(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 50,
                        ),
                        Text('Remove',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.bold)),
                        Icon(
                          Icons.delete_forever,
                          size: 25,
                          color: Colors.grey.shade500,
                        ),
                      ],
                    ),
                    height: 35,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: Colors.grey.shade500,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
