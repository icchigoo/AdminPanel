// ignore_for_file: prefer_const_constructors, deprecated_member_use, dead_code

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum Page { dashboard, manage }

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  Page _selectedPage = Page.dashboard;
  MaterialColor active = Colors.red;
  MaterialColor notActive = Colors.grey;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Expanded(
                child: FlatButton.icon(
                  onPressed: () {
                    setState(() => _selectedPage = Page.dashboard);
                  },
                  icon: Icon(
                    Icons.dashboard,
                    color: _selectedPage == Page.dashboard ? active : notActive,
                  ),
                  label: const Text('Dashboard'),
                ),
              ),
              Expanded(
                child: FlatButton.icon(
                  onPressed: () {
                    setState(() => _selectedPage = Page.manage);
                  },
                  icon: Icon(
                    Icons.dashboard,
                    color: _selectedPage == Page.dashboard ? active : notActive,
                  ),
                  label: const Text('Manage'),
                ),
              ),
            ],
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: _loadScreen());
  }

  Widget _loadScreen() {
    switch (_selectedPage) {
      case Page.dashboard:
        return Column(
          children: [
            ListTile(
              subtitle: FlatButton.icon(
                onPressed: null,
                icon: Icon(
                  Icons.attach_money,
                  size: 30.0,
                  color: Colors.green,
                ),
                label: Text(
                  '12,000',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30.0, color: Colors.green),
                ),
              ),
              title: Text(
                'Revenue',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0, color: Colors.grey),
              ),
            ),
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Card(
                      child: ListTile(
                        title: FlatButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.people_outline),
                          label: Text("users"),
                        ),
                        subtitle: Text(
                          '7',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: active, fontSize: 60.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Card(
                      child: ListTile(
                        title: FlatButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.category),
                          label: Text("users"),
                        ),
                        subtitle: Text(
                          '23',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: active, fontSize: 60.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      child: ListTile(
                        title: FlatButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.track_changes),
                          label: Text("Products"),
                        ),
                        subtitle: Text(
                          '21',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: active, fontSize: 60.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Card(
                      child: ListTile(
                        title: FlatButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.tag_faces),
                          label: Text("Sold"),
                        ),
                        subtitle: Text(
                          '13',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: active, fontSize: 60.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Card(
                      child: ListTile(
                        title: FlatButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.shopping_cart),
                          label: Text("Orders"),
                        ),
                        subtitle: Text(
                          '5',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: active, fontSize: 60.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Card(
                      child: ListTile(
                        title: FlatButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.people_outline),
                          label: Text("Return"),
                        ),
                        subtitle: Text(
                          '0',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: active, fontSize: 60.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
        break;
      case Page.manage:
        return ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Add product"),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.change_history),
              title: Text("Products list"),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add_circle),
              title: Text("Add category"),
              onTap: () {
                ;
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.category),
              title: Text("Category list"),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add_circle_outline),
              title: Text("Add brand"),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.library_books),
              title: Text("brand list"),
              onTap: () {},
            ),
            Divider(),
          ],
        );
        break;
      default:
        return Container();
    }
  }
}
