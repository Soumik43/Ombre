import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/cupertino_flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/model/mockdata.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  FirebaseFirestore firestore;
  // Created a model named MockData for easier and cleaner use of the date from firestore
  MockData mockData;
  bool loading = true;
  // Getting the mock data from firestore
  void getMockData() {
    firestore = FirebaseFirestore.instance;
    firestore.collection('mock').doc('data').get().then(
      (value) {
        setState(() {
          mockData = MockData.fromJson(value.data());
          for (var ele in mockData.value) {
            tosuggestSubtitles.add(ele.subtitle);
            tosuggest.add(ele.title);
          }
        });
      },
    );
  }

  // Here i am storing the values to display, where "tosuggest" is the list where the titles are going to be stored and the genre's are going to stored in the list "tosuggestSubtitles"
  List<String> tosuggest = [];
  List<String> tosuggestSubtitles = [];

  // This is the function to get the suggestions according to what the user has typed
  getSuggestions(String pattern) {
    List<String> suggestions = [];
    List<String> subtitlesuggestions = [];
    for (var name in mockData.value) {
      if (name.title.toLowerCase().contains(pattern.toLowerCase())) {
        suggestions.add(name.title);
        subtitlesuggestions.add(name.subtitle);
      }
    }
    setState(() {
      tosuggest = suggestions;
      tosuggestSubtitles = subtitlesuggestions;
    });
    return suggestions;
  }

  int _bottomNavIndex = 0;
  TextEditingController _typeAheadController;

  @override
  void initState() {
    super.initState();
    _typeAheadController = TextEditingController();
    getMockData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0D111A),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffFD4B78),
        onPressed: () {},
        child: Icon(
          Icons.search,
          size: 40,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        backgroundColor: Color(0xff263240),
        icons: [Icons.home, Icons.add, Icons.event_seat],
        iconSize: 26,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.end,
        notchSmoothness: NotchSmoothness.softEdge,
        onTap: (index) => setState(
          () => _bottomNavIndex = index,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: Container(
                      height: 50,
                      child: Container(
                        color: Color(0xff0D111A),
                        // Using a typeahead form in order to find the suggestions
                        child: CupertinoTypeAheadFormField(
                          getImmediateSuggestions: false,
                          autovalidateMode: AutovalidateMode.disabled,
                          animationDuration: Duration(milliseconds: 0),
                          itemBuilder: (BuildContext context, itemData) {
                            return Container(
                              color: Color(0xff0D111A),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            _typeAheadController.text = suggestion;
                          },
                          suggestionsCallback: (String pattern) {
                            return Future.delayed(
                              Duration(milliseconds: 200),
                              () {
                                return getSuggestions(pattern);
                              },
                            );
                          },
                          noItemsFoundBuilder: (context) {
                            return Container(
                              height: double.infinity,
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  'No Results Found',
                                  style: GoogleFonts.poppins(
                                    decoration: TextDecoration.none,
                                    fontSize: 20,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, o) {
                            return Container();
                          },
                          loadingBuilder: (c) {
                            return Container();
                          },
                          suggestionsBoxDecoration:
                              CupertinoSuggestionsBoxDecoration(
                            color: Color(0xff0D111A),
                            border: Border.all(
                              width: 0,
                            ),
                          ),
                          textFieldConfiguration:
                              CupertinoTextFieldConfiguration(
                            placeholder: 'Search for events, artists, or fans',
                            controller: _typeAheadController,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Color(0xff263240),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black38,
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 0.1,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff263240),
                    ),
                    child: IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                      },
                      icon: Icon(Icons.search),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: ListTile(
                        // Checking whether it is a user or a song
                        leading: tosuggestSubtitles[i] != 'User'
                            ? Container(
                                height: 80,
                                width: 80,
                                child: Image(
                                  image:
                                      AssetImage('assets/images/mockImage.jpg'),
                                ),
                              )
                            : Container(
                                width: 80,
                                height: 80,
                                child: CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/images/mockImage.jpg'),
                                ),
                              ),
                        title: Padding(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                tosuggestSubtitles[i],
                                style: TextStyle(
                                  color: Colors.pinkAccent,
                                  fontSize: 17,
                                ),
                              ),
                              Text(
                                tosuggest[i],
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.7,
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: tosuggest.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
