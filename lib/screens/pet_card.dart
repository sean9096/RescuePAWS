import 'package:flutter/material.dart';
import 'package:rescuepaws/widget/sidebar_widget.dart';

class PetCard extends StatefulWidget {
  const PetCard({Key? key}) : super(key: key);

  @override
  _PetCardState createState() => _PetCardState();
}

class _PetCardState extends State<PetCard> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      endDrawer: SidebarWidget(),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Home Page'),
        backgroundColor: Colors.green,
        //backgroundColor: Colors.tealAccent[700],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            textDirection: TextDirection.rtl,
            children: [
              IconButton(
                  onPressed: () {},
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
        //padding: EdgeInsets.only(bottom: 20),
        height: size.height * 0.75,
        width: size.width * 0.95,
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),

          child: Stack(
            alignment: Alignment.center,
            children: [
              Ink.image(image: AssetImage('assets/pet_lucas.jpg'), fit: BoxFit.fill),
            ],
          )
        ),
      ),
    );
  }
}
