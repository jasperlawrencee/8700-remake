import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jollibee_commerce/components/constants.dart';
import 'package:jollibee_commerce/components/widgets.dart';
import 'package:jollibee_commerce/pages/menu_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
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
            ListView.builder(
              shrinkWrap: true,
              itemCount: cart.length + 1,
              itemBuilder: (context, index) {
                if (index == cart.length) {
                  List<num> cartAmount = [];
                  cart.forEach((element) {
                    cartAmount.add((element['price'] * element['amount']));
                  });
                  num total = cartAmount.reduce((a, b) => a + b);
                  return Column(
                    children: [
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Amount"),
                          Text("PHP ${total.toStringAsFixed(2)}")
                        ],
                      )
                    ],
                  );
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${cart[index]['amount']}"),
                              const SizedBox(width: defaultPadding),
                              InkWell(
                                onTap: () {},
                                child: const Icon(CupertinoIcons.minus,
                                    size: 16, color: jPrimaryColor),
                              ),
                              const SizedBox(width: defaultPadding / 2),
                              InkWell(
                                onTap: () {},
                                child: const Icon(CupertinoIcons.add,
                                    size: 16, color: jPrimaryColor),
                              ),
                            ],
                          ),
                          const SizedBox(width: defaultPadding),
                          Text(cart[index]['name']),
                        ],
                      ),
                      Text("PHP ${cart[index]['price'].toStringAsFixed(2)}"),
                    ],
                  );
                }
              },
            )
          ],
        ),
      )),
    );
  }
}
