import 'bus_selection_screen.dart';
import 'bus_stand_screen.dart';
import 'menu_list.dart';
import 'signup_screen.dart';
import 'package:flutter/material.dart';
import 'chatbot.dart';

class BusSearchApp extends StatelessWidget {
  const BusSearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BusSearchScreen(),
    );
  }
}

class BusSearchScreen extends StatefulWidget {
  const BusSearchScreen({super.key});
  @override
  _BusSearchScreenState createState() => _BusSearchScreenState();
}

class _BusSearchScreenState extends State<BusSearchScreen> {
  List<Map<String, dynamic>> busList = [];

  TextEditingController destinationController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  List<String> recentSearches = [];

  final FocusNode _destinationFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Double Bell",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 118, 39),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // Change menu icon color to white
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 118, 39),
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 28),
              ),
            ),
            _buildDrawerItem("Review & Discussion", Icons.rate_review, context),
            _buildDrawerItem("Help, FAQs & Feedback", Icons.help, context),
            _buildDrawerItem("Settings", Icons.settings, context),
            _buildDrawerItem("Contact Us", Icons.contact_mail, context),
            _buildDrawerItem("About Us", Icons.info, context),
            _buildDrawerItem("Municipal Bus Stand Thodupuzha", Icons.directions_bus, context,),
            _buildDrawerItem("Operator's Dashboard", Icons.auto_graph, context),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color.fromARGB(255, 255, 118, 39), Color(0xFFF5A522)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    "Hey! Where do you want to go\nfrom Thodupuzha?",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFEEEEEE),),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BusSelectionScreen(),),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 255, 45, 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 60,
                        vertical: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 6,
                      shadowColor: Colors.black45,
                    ),
                    child: const Text(
                        "Search Buses",
                        style: TextStyle(fontSize: 25)
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Destinations reached by Thodupuzha buses",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: const [
                  ExpansionTile(
                    title: Text("Thommankuthu"),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          "Thommankuthu is a scenic seven-step waterfall and a popular eco-tourism spot. A great destination for nature lovers and trekkers.",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: Text("Malankara Dam"),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          "Malankara Dam is an irrigation dam offering picturesque views and boating. It’s an ideal place for picnics and relaxation.",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: Text("Thumbachi Kurishmala"),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          "Thumbachi Kurishmala is a hilltop pilgrimage site with a panoramic view and peaceful atmosphere. Often visited during Lent.",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromARGB(255, 255, 118, 39),
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        onTap: (index) {

          if (index == 2) {
            // Assuming Chatbot is the third item
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatbotScreen()),
            );
          }
          if (index == 3) {
            // Assuming Account is the fourth item
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignupScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_num),
            label: "Tickets",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chatbot"),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Account",
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(String title, IconData icon, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color.fromARGB(255, 255, 118, 39)),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        if (title == "Municipal Bus Stand Thodupuzha") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BusStandScreen()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MenuList(title: title)),
          );
        }
      },
    );
  }
}
