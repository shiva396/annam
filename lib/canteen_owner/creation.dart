import 'package:flutter/material.dart';

class Creation extends StatefulWidget {
  const Creation({super.key});

  @override
  State<Creation> createState() => _CreationState();
}

class _CreationState extends State<Creation> {
  PageController pageController = PageController();
  List<String> tabs = [
    "Breakfast",
    "Lunch",
    "Chocolates",
    "Drinks",
    "Sandwiches"
  ];
  int current = 0;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFFE6E6E6),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              color: Color(0xFFE6E6E6),
              height: height * 0.01,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                ],
              ),
            ),
            Container(
              child: Text(
                "Welcome to,\nProducts gallery",
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: height * 0.03),
            SizedBox(
              width: width,
              height: 70,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: tabs.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            current = index;
                          });
                          pageController.animateToPage(
                            current,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.ease,
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.all(5),
                          width: 100,
                          height: 30,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  tabs[index],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: current == index ? 16 : 12,
                                    color: current == index
                                        ? Colors.black
                                        : Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: current == index,
                        child: Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
                              color: Colors.deepPurpleAccent,
                              shape: BoxShape.circle),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: ListsWithCards(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListsWithCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Sample data for five lists
    List<String> listData = ['Item A', 'Item B', 'Item C', 'Item D'];

    return Card(
      color: Color(0xFFE6E6E6),
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: [
          ListView.builder(
            itemCount: listData.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(listData[index]),
              );
            },
          ),
        ],
      ),
    );
  }
}
