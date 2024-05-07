import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jollibee_commerce/components/constants.dart';
import 'package:jollibee_commerce/components/widgets.dart';
import 'package:jollibee_commerce/models/class_models.dart';
import 'package:jollibee_commerce/services/firebase_auth.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<String> categories = ['Items', 'History'];
  int current = 0;

  void _showBackDialog() {
    showCupertinoDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Confirm Logout?'),
        content: const Text('Leaving this page will log you out'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel')),
          TextButton(
              onPressed: () async {
                await Firebase().signOut();
                if (mounted) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              },
              child: const Text('Log Out'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        _showBackDialog();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          foregroundColor: jSecondaryColor,
          backgroundColor: jPrimaryColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox.square(
                dimension: 50,
                child: Image.asset(jollibeeLogo),
              ),
              Stack(
                children: [
                  Text(
                    'Jolly Admin',
                    style: TextStyle(
                        fontFamily: 'Jellee',
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 2
                          ..color = jTertiaryColor),
                  ),
                  const Text(
                    'Jolly Admin',
                    style: TextStyle(
                      fontFamily: 'Jellee',
                      color: jSecondaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: JollyBackground(
            child: Container(
          width: MediaQuery.of(context).size.width - 100,
          height: double.infinity,
          decoration: const BoxDecoration(
              color: jSecondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(4))),
          padding: const EdgeInsets.all(defaultPadding),
          margin: const EdgeInsets.all(defaultPadding),
          child: StreamBuilder(
            stream: null,
            builder: (context, snapshot) {
              return Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        current = index;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: defaultPadding),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            categories[index],
                                            style: TextStyle(
                                              fontWeight: current == index
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                              color: current == index
                                                  ? jPrimaryColor
                                                  : jTertiaryColor,
                                            ),
                                          ),
                                          Icon(
                                            Icons.keyboard_arrow_right_rounded,
                                            color: current == index
                                                ? jPrimaryColor
                                                : jTertiaryColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                        ],
                      )),
                  Expanded(
                      flex: 6, child: current == 0 ? ItemsTab() : HistoryTab())
                ],
              );
            },
          ),
        )),
      ),
    );
  }
}

class ItemsTab extends StatefulWidget {
  const ItemsTab({super.key});

  @override
  State<ItemsTab> createState() => ItemsTabState();
}

class ItemsTabState extends State<ItemsTab> {
  Future<List<Item>> getItems() async {
    try {
      List<Item> items = [];
      QuerySnapshot querySnapshot = await db.collection('jollibee-menu').get();
      querySnapshot.docs.forEach((i) {
        items.add(Item(
          name: i['name'],
          category: i['category'],
          price: i['price'],
        ));
      });
      return items;
    } catch (e) {
      log('error getting list of items $e');
      return [];
    }
  }

  Future<void> pullDownRefresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Item>>(
        future: getItems(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: pullDownRefresh,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Text(snapshot.data![index].name);
                },
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: jPrimaryColor,
        foregroundColor: jSecondaryColor,
        onPressed: () {
          addItemDialog(context);
        },
        label: const Text('Add Item'),
        icon: const Icon(CupertinoIcons.add),
      ),
    );
  }
}

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key});

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
