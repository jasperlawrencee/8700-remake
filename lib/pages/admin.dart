// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
                      flex: 6,
                      child:
                          current == 0 ? const ItemsTab() : const HistoryTab())
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
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(snapshot.data![index].category.toUpperCase()),
                          const SizedBox(width: defaultPadding),
                          Text(snapshot.data![index].name),
                          const SizedBox(width: defaultPadding),
                          Text(
                            "PHP ${snapshot.data![index].price}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: jPrimaryColor),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          TextButton(onPressed: () {}, child: Text('Edit')),
                          TextButton(onPressed: () {}, child: Text('Delete')),
                        ],
                      )
                    ],
                  );
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
          Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const AddItem(),
              ));
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
  Future<List<OrderItem>> getOrderHistory() async {
    try {
      List<OrderItem> history = [];
      QuerySnapshot querySnapshot =
          await db.collection('users').doc(adminUid).collection('orders').get();
      querySnapshot.docs.forEach((h) {
        List<Map<String, dynamic>> orderList = [];
        List<dynamic> orderData = h['order'];
        orderData.forEach((element) {
          orderList.add(Map<String, dynamic>.from(element));
        });
        history.add(OrderItem(
            email: h['email'],
            orderDateTime: h['orderDateTime'].toDate(),
            reference: h['reference'],
            totalPrice: h['totalPrice'],
            order: orderList));
      });
      return history;
    } catch (e) {
      print('error getting order history $e');
      return [];
    }
  }

  Future<void> pullDownRefresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getOrderHistory(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            return RefreshIndicator(
              onRefresh: pullDownRefresh,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return OrderCard(
                      email: data[index].email,
                      reference: data[index].reference,
                      price: data[index].totalPrice,
                      dateTime: data[index].orderDateTime);
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
    );
  }

  Widget OrderCard({
    required String email,
    required String reference,
    required num price,
    required DateTime dateTime,
  }) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      width: double.infinity,
      height: 250,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Email $email"),
              Text("ref: $reference"),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Price: ${price.toStringAsFixed(2)}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('$dateTime'),
            ],
          ),
        ],
      ),
    );
  }
}

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  String dropdownValue = mealCategories.first;
  final TextEditingController itemController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  File? pickedImage;
  Uint8List webImage = Uint8List(8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        padding: const EdgeInsets.all(defaultPadding),
        margin: const EdgeInsets.all(defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Add Item',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Jellee',
                color: jPrimaryColor,
              ),
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(defaultPadding),
                  decoration: BoxDecoration(
                      border: Border.all(color: jPrimaryColor),
                      borderRadius: const BorderRadius.all(Radius.circular(4))),
                  child: DropdownButton(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_drop_down),
                    underline: Container(
                      height: 2,
                      color: jPrimaryColor,
                    ),
                    items: mealCategories
                        .map<DropdownMenuItem<String>>((String e) =>
                            DropdownMenuItem<String>(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: defaultPadding),
                Container(
                    padding: const EdgeInsets.all(defaultPadding),
                    decoration: BoxDecoration(
                        border: Border.all(color: jPrimaryColor),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4))),
                    width: 500,
                    child: textFormFieldWithIcon(
                      controller: itemController,
                      hint: 'Item Name',
                      icon: const Icon(CupertinoIcons.add),
                      isPassword: false,
                    )),
              ],
            ),
            const SizedBox(height: defaultPadding),
            Container(
                padding: const EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(
                    border: Border.all(color: jPrimaryColor),
                    borderRadius: const BorderRadius.all(Radius.circular(4))),
                width: 500,
                child: textFormFieldWithIcon(
                  controller: priceController,
                  hint: 'Price',
                  icon: const Icon(CupertinoIcons.money_dollar),
                  isPassword: false,
                )),
            const SizedBox(height: defaultPadding),
            DottedBorder(
              color: jPrimaryColor,
              strokeWidth: 1,
              child: InkWell(
                onTap: pickImage,
                child: Container(
                  padding: const EdgeInsets.all(defaultPadding),
                  width: 500,
                  height: 500,
                  child: pickedImage == null
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(CupertinoIcons.cloud_upload),
                              Text('Upload Image'),
                            ],
                          ),
                        )
                      : kIsWeb
                          ? Image.memory(webImage, fit: BoxFit.fill)
                          : Image.file(
                              pickedImage!,
                              fit: BoxFit.fill,
                            ),
                ),
              ),
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(jSecondaryColor),
                          foregroundColor:
                              MaterialStatePropertyAll(jPrimaryColor)),
                      onPressed: clearForm,
                      child: const Text('Clear Form')),
                ),
                const SizedBox(width: defaultPadding),
                SizedBox(
                    width: 200,
                    child: ElevatedButton(
                        onPressed: showItemDialog,
                        child: const Text('Add Item'))),
              ],
            ),
          ],
        ),
      )),
    );
  }

  bool isNumberOnly(String input) {
    final numericRegex = RegExp(r'^[0-9]+$');
    return numericRegex.hasMatch(input);
  }

  Future<void> showItemDialog() async {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Confirm Add Item?'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back')),
          TextButton(onPressed: addItem, child: const Text('Add')),
        ],
      ),
    );
  }

  Future<void> clearForm() async {
    try {
      itemController.clear();
      priceController.clear();
      webImage.clear();
    } catch (e) {
      log('?? $e');
    }
  }

  Future<void> addItem() async {
    try {
      if (itemController.text.isEmpty &&
          priceController.text.isEmpty &&
          isNumberOnly(priceController.text)) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(bottomSnackbar('Empty Fields'));
      } else {
        await db.collection('jollibee-menu').add({
          'category': dropdownValue.toLowerCase(),
          'name': itemController.text,
          'price': num.parse(priceController.text),
          'image': '',
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(bottomSnackbar("${itemController.text} is added!"));
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(bottomSnackbar("$e"));
      log('error adding item $e');
    }
  }

  Future<void> pickImage() async {
    try {
      if (kIsWeb) {
        final returnImage =
            await ImagePicker().pickImage(source: ImageSource.gallery);

        if (returnImage == null) return;
        var f = await returnImage.readAsBytes();
        setState(() {
          webImage = f;
          pickedImage = File('a');
        });
      } else {
        log('???');
      }
    } catch (e) {
      log('error picking image');
    }
  }
}
