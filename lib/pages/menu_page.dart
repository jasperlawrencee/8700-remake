// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jollibee_commerce/components/constants.dart';
import 'package:jollibee_commerce/components/widgets.dart';
import 'package:jollibee_commerce/models/class_models.dart';
import 'package:badges/badges.dart' as badges;
import 'package:jollibee_commerce/pages/cart_page.dart';
import 'package:jollibee_commerce/services/firebase_auth.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

List<Map<String, dynamic>> cart = [];

class _MenuPageState extends State<MenuPage> {
  int itemCount = 1;
  int categoryIndex = 0;

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
          foregroundColor: jSecondaryColor,
          actions: [
            FutureBuilder<int>(
                future: cartCount(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return badges.Badge(
                      position: badges.BadgePosition.topEnd(top: -2, end: 2),
                      badgeStyle:
                          const badges.BadgeStyle(badgeColor: jSecondaryColor),
                      badgeContent: Text("${snapshot.data}"),
                      child: IconButton(
                          onPressed: viewCart,
                          icon: const Icon(
                            Icons.shopping_basket_outlined,
                            color: jSecondaryColor,
                            size: h2,
                          )),
                    );
                  } else {
                    return Container();
                  }
                })
          ],
          backgroundColor: jPrimaryColor,
          title: Row(
            children: [
              SizedBox.square(
                dimension: 50,
                child: Image.asset(jollibeeLogo),
              ),
              Stack(
                children: [
                  Text(
                    'Jollibee',
                    style: TextStyle(
                        fontFamily: 'Jellee',
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 2
                          ..color = jTertiaryColor),
                  ),
                  const Text(
                    'Jollibee',
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
          child: FutureBuilder<List<String>>(
              future: getCategories(),
              builder: (context, categories) {
                if (categories.hasData) {
                  return Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: categories.data!.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            categoryIndex = index;
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
                                                capitalize(
                                                    categories.data![index]),
                                                style: TextStyle(
                                                  fontWeight:
                                                      categoryIndex == index
                                                          ? FontWeight.bold
                                                          : FontWeight.normal,
                                                  color: categoryIndex == index
                                                      ? jPrimaryColor
                                                      : jTertiaryColor,
                                                ),
                                              ),
                                              Icon(
                                                Icons
                                                    .keyboard_arrow_right_rounded,
                                                color: categoryIndex == index
                                                    ? jPrimaryColor
                                                    : jTertiaryColor,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Divider()
                                    ],
                                  );
                                },
                              ),
                            ],
                          )),
                      Expanded(
                          flex: 6,
                          child: StreamBuilder<List<Item>>(
                              stream: Stream.fromFuture(getMenuItems(
                                  categories.data![categoryIndex])),
                              builder: (context, menuitems) {
                                if (menuitems.hasData) {
                                  return Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4))),
                                    margin: const EdgeInsets.only(
                                        left: defaultPadding),
                                    padding:
                                        const EdgeInsets.all(defaultPadding),
                                    child: GridView.builder(
                                      itemCount: menuitems.data!.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3),
                                      itemBuilder: (context, index) {
                                        return MenuContainer(
                                            price: menuitems.data![index].price,
                                            name: menuitems.data![index].name,
                                            function: () {
                                              setState(() => itemCount = 1);
                                              addToCart(menuitems.data![index]);
                                              setState(() {});
                                            },
                                            menuCount: menuitems.data!.length);
                                      },
                                    ),
                                  );
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator(
                                          color: jPrimaryColor));
                                }
                              }))
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(color: jPrimaryColor),
                  );
                }
              }),
        )),
        bottomNavigationBar: const BottomAppBar(
          color: jPrimaryColor,
          padding: EdgeInsets.all(defaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '8-700 Jalibi Remake XD',
                style: TextStyle(fontFamily: 'Jellee', color: jSecondaryColor),
              ),
              Text(
                'No Rights Reserved © 2024 | Jasper Lawrence Caballero',
                style: TextStyle(color: jSecondaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addToCart(Item item) async {
    try {
      Map<String, dynamic> meal = {
        "name": item.name,
        "price": item.price,
        "amount": itemCount,
      };
      itemCount = await showItemDialog(item) ?? -1;
      if (itemCount != -1) {
        int existingItem = cart.indexWhere((m) => m['name'] == item.name);
        if (existingItem != -1) {
          cart[existingItem]['amount'] += itemCount;
        } else {
          cart.add(meal);
        }
      }
      log("$cart");
    } catch (e) {
      log("error adding to cart $e");
    }
  }

  Future<void> viewCart() async {
    if (cart.isEmpty) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Cart is Empty'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('BACK'))
          ],
        ),
      );
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CartPage(),
          ));
    }
  }

  Future<int?> showItemDialog(Item item) async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return CupertinoAlertDialog(
            title: Text(item.name),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: () {
                      if (itemCount > 1) {
                        setState(() {
                          itemCount--;
                        });
                      }
                    },
                    icon: const Icon(CupertinoIcons.minus)),
                Text("$itemCount"),
                IconButton(
                    onPressed: () {
                      setState(() {
                        itemCount++;
                      });
                    },
                    icon: const Icon(CupertinoIcons.add)),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(-1);
                  },
                  child: const Text('BACK')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(itemCount);
                  },
                  child: const Text('ADD')),
            ],
          );
        });
      },
    );
  }

  Future<List<String>> getCategories() async {
    try {
      List<String> categories = [];
      QuerySnapshot querySnapshot = await db.collection(jbMenuCollection).get();
      querySnapshot.docs.forEach((element) {
        if (!categories.contains(element['category'])) {
          categories.add(element['category']);
        }
      });
      return categories;
    } catch (e) {
      log("error getting categories $e");
      return [];
    }
  }

  Future<List<Item>> getMenuItems(String category) async {
    try {
      List<Item> menuItems = [];
      QuerySnapshot querySnapshot = await db
          .collection(jbMenuCollection)
          .where('category', isEqualTo: category)
          .get();
      querySnapshot.docs.forEach((e) {
        menuItems.add(Item(
          name: e['name'],
          category: e['category'],
          price: e['price'],
        ));
      });
      return menuItems;
    } catch (e) {
      log("error getting menu items $e");
      return [];
    }
  }

  String capitalize(String input) {
    List<String> words = input.split(' ');
    List<String> capitalized = [];

    words.forEach((word) {
      if (word.isNotEmpty) {
        String capitalizedWord =
            word[0].toUpperCase() + word.substring(1).toLowerCase();
        capitalized.add(capitalizedWord);
      }
    });
    return capitalized.join(' ');
  }

  Future<int> cartCount() async {
    return cart.length;
  }
}
