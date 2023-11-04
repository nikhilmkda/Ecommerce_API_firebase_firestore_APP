import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../controller/api_call.dart';


class ItemListScreen extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String starRating;
  final String cost;
  final Function() itemTapped;

  const ItemListScreen(
      {super.key,
      required this.imageUrl,
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
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          //borderRadius: BorderRadius.circular(25),
        ),
        width: 190,
        height: 200,
        padding: const EdgeInsets.only(
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
            const SizedBox(height: 5),
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
                  const SizedBox(height: 5),
                  Text(
                    description,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.blue, size: 20),
                      const Icon(Icons.star, color: Colors.blue, size: 20),
                      const Icon(Icons.star, color: Colors.blue, size: 20),
                      const Icon(Icons.star, color: Colors.blue, size: 20),
                      const Icon(Icons.star_border,
                          color: Colors.grey, size: 20),
                      const SizedBox(width: 5),
                      Text(
                        starRating,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(' \$ $cost/-',
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 2,
              width: width,
              color: Colors.grey.shade100,
            ),
          ],
        ),
      ),
    );
  }
}