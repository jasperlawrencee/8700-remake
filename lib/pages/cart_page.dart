import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jollibee_commerce/components/constants.dart';
import 'package:jollibee_commerce/components/widgets.dart';
import 'package:jollibee_commerce/pages/menu_page.dart';

class CartPage extends StatefulWidget {
  List<Map<String, dynamic>> cart = [];
  CartPage({
    super.key,
    required this.cart,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Future<void> subtractItem(int index) async {
    setState(() {
      widget.cart[index]['amount']--;
      if (widget.cart[index]['amount'] == 0) {
        showDeleteDialog(index);
      }
    });
  }

  Future<void> addItem(int index) async {
    setState(() {
      widget.cart[index]['amount']++;
    });
  }

  Future<void> showDeleteDialog(int index) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Confirm Delete?'),
          content: const Text(
              'Are you sure you want to remove this item from the cart?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    widget.cart[index]['amount']++;
                  });
                },
                child: const Text('Cancel')),
            TextButton(
                onPressed: () {
                  setState(() {
                    widget.cart.removeAt(index);
                  });
                  Navigator.pop(context);
                },
                child: const Text('Delete')),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: jSecondaryColor,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Cart'),
            widget.cart.isEmpty
                ? const Expanded(
                    child: Center(
                    child: Text('Your cart is empty'),
                  ))
                : Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.cart.length + 1,
                      itemBuilder: (context, index) {
                        if (index == widget.cart.length) {
                          List<num> cartAmount = [];
                          widget.cart.forEach((element) {
                            cartAmount
                                .add((element['price'] * element['amount']));
                          });
                          num total = cartAmount.reduce((a, b) => a + b);
                          return Column(
                            children: [
                              const Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Amount"),
                                  Text("PHP ${total.toStringAsFixed(2)}")
                                ],
                              )
                            ],
                          );
                        } else if (widget.cart.isNotEmpty) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${widget.cart[index]['amount']}"),
                                      const SizedBox(width: defaultPadding),
                                      InkWell(
                                        onTap: () {
                                          subtractItem(index);
                                        },
                                        child: const Icon(CupertinoIcons.minus,
                                            size: 16, color: jPrimaryColor),
                                      ),
                                      const SizedBox(width: defaultPadding / 2),
                                      InkWell(
                                        onTap: () {
                                          addItem(index);
                                        },
                                        child: const Icon(CupertinoIcons.add,
                                            size: 16, color: jPrimaryColor),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: defaultPadding),
                                  Text(widget.cart[index]['name']),
                                ],
                              ),
                              Text(
                                  "PHP ${widget.cart[index]['price'].toStringAsFixed(2)}"),
                            ],
                          );
                        }
                      },
                    ),
                  )
          ],
        ),
      )),
    );
  }
}
