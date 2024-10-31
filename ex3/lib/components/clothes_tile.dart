import 'package:ex3/data/clothes.dart';
import 'package:flutter/material.dart';

// class ClothesTile extends StatefulWidget{
//   @override
//   State<StatefulWidget> createState() => ClothesTileState();
//
// }
//
// class ClothesTileState extends State<ClothesTile>{
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
//
// }

class ClothesTile extends StatelessWidget{
  final Clothes clothes;
  final void Function()? onTap;
  const ClothesTile({super.key, required this.clothes, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20),
      // padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      width: 300,

      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [

          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.asset(
              clothes.imagePath,
              fit: BoxFit.cover,

            ),
          ),
          Text(clothes.name),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Expanded(
                child: Text(
                  clothes.price,
                  textAlign: TextAlign.center, // Canh trái cho phù hợp
                  style: const TextStyle(fontSize: 16),
                ),
              ),

              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12)
                    ),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          )

        ],
      ),
    );
  }

}