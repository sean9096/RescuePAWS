import 'package:flutter/material.dart';
import 'package:rescuepaws/widget/sidebar_widget.dart';


class LogoutPage extends StatefulWidget {
  const LogoutPage({Key? key}) : super(key: key);

  @override
  _LogoutPageState createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: SidebarWidget(),
        appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Home Page'),
        backgroundColor: Colors.green,
        ),
      body: _buildBody(),

      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textDirection: TextDirection.rtl,
          children: [
            IconButton(
              onPressed: ()  {},
              icon: Icon(
                Icons.arrow_forward_ios_outlined,
              ),
              iconSize: 40,
            ),

            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.clear,
              ),
              iconSize: 40,
            ),

            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.check,
              ),
              iconSize: 40,
            )

          ],
        ),
        color: Colors.green,
      ),
    );
  }

  Widget _buildBody() {
    final size = MediaQuery.of(context).size;
    return Center(
        child: Container(
          height: size.height * 0.75,
          width: size.width * 0.95,

          //displays pet image
          child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),

              child: Stack(
                //alignment: Alignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Contact Info:',
                          style: TextStyle(
                              fontSize: 45,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                          ),
                        ),

                        _buildContactInfo("Owner/Business Name"),
                        SizedBox(height: 15),
                        _buildContactInfo("contactPhone"),
                        SizedBox(height: 15),
                        _buildContactInfo("Other Contact Info"),

                      ],
                    ),
                  ],
        )
    ),
    ),
    );
  }

  Widget _buildContactInfo(String label) {
    return Text(
      '$label: ',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
      ),
    );
  }

}
