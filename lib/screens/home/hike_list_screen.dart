import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mhike_app/database/database_helper.dart';
import 'package:mhike_app/models/hike_model.dart';
import 'package:mhike_app/screens/home/add_hike_screen.dart';
import 'package:intl/intl.dart';
import 'package:mhike_app/screens/home/hike_detail_screen.dart';
import 'package:mhike_app/screens/home/search_hike_screen.dart';

class HikeListScreen extends StatefulWidget {
  @override
  State<HikeListScreen> createState() => _HikeListScreenState();
}

class _HikeListScreenState extends State<HikeListScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    setState(() {});
  }

  void _searchHikes() async {
    String searchName = _searchController.text;
    List<Hike> searchResults = await DatabaseHelper().searchHikes(searchName);

    if (searchResults.isEmpty) {
      // Show a message that no hikes match the search criteria
      Get.snackbar('No Results', 'No hikes match the search criteria');
    } else {
      // Navigate to a new screen to display search results
      Get.to(() => SearchResultScreen(searchResults: searchResults));
    }
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Search Hike'),
          content: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Enter hike name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _searchHikes();
                Navigator.of(context).pop();
              },
              child: Text('Search'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hike List'),
        actions: [
          IconButton(
            onPressed: () {
              _showSearchDialog();
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              Get.to(() => AddHikeScreen());
            },
            icon: Icon(Icons.assignment_add),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Hike>>(
        future: DatabaseHelper().getHikes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No hikes available.');
          } else {
            // Hiển thị danh sách chuyến đi trong GridView
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Hike hike = snapshot.data![index];
                final dateFormat = DateFormat("HH:mm - dd/MM/yy");
                final formattedDate = dateFormat.format(hike.date);
                return GestureDetector(
                  onTap: () {
                    Get.to(() => HikeDetailScreen(name: hike.name));
                  },
                  child: Container(
                    color: Colors.grey[300],
                    height: 550,
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 8, top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          child: Text(
                            "Name hike: ${hike.name}",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 5, left: 10, right: 10),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 25,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                hike.location,
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 5, left: 10, right: 10),
                          child: Text(
                            "Start time:  ${formattedDate}",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 5, left: 10, right: 10),
                          child: Text(
                            "Accompany:  ${hike.partner}",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 5, left: 10, right: 10),
                          child: hike.parkingAvailable == true
                              ? Text(
                                  "Parking:  Available",
                                  style: TextStyle(fontSize: 18),
                                )
                              : Text(
                                  "Parking:  Not available",
                                  style: TextStyle(fontSize: 18),
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 5, left: 10, right: 10),
                          child: Text(
                            "Parking:  ${hike.length.toString()} km",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 5, left: 10, right: 10),
                          child: Text(
                            "Level of difficult:  ${hike.difficulty}",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        // Sử dụng Image.file để hiển thị ảnh từ local
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image.file(
                            File(hike.image), // Đường dẫn hình ảnh local
                            height: 280,
                            fit: BoxFit.cover,
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                DatabaseHelper().deleteHike(hike.name);
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 30,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
