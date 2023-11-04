import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the notification message and display it on the screen
    final message =
        ModalRoute.of(context)!.settings.arguments as RemoteMessage?;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Notifications',
          style: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
          ),
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
      ),
      body: message != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications,
                            color: Colors.amber,
                            size: 30, // Customize icon color
                          ),
                          SizedBox(
                              width: 8), // Add spacing between icon and title
                          Expanded(
                            child: Text(
                              message.notification!.title.toString(),
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color:
                                    Colors.black, // Customize title text color
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        message.notification!.body.toString(),
                        style: GoogleFonts.openSans(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.black, // Customize title text color
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          message.data.toString(),
                          style: TextStyle(
                            fontSize: 18, // Customize data text size
                            fontWeight: FontWeight.bold,
                            color: Colors.blue, // Customize data text color
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.notifications,
                    size: 45,
                    color: Colors.grey[300], // Light grey shade
                  ),
                  SizedBox(
                      height: 10), // Add some spacing between the icon and text
                  Text(
                    'No Notifications',
                    style: GoogleFonts.openSans(
                      fontSize: 30,
                      color:
                          Colors.grey[300], // Same light grey shade as the icon
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
