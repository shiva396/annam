import 'package:flutter/material.dart';
import 'package:projrect_annam/utils/custom_text.dart';

import '../const/image_const.dart';

class PopularRestaurantRow extends StatelessWidget {
  final Map pObj;
  final VoidCallback onTap;
  const PopularRestaurantRow({super.key, required this.pObj, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Image.asset(
                pObj["image"].toString(),
                width: double.maxFinite,
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(
              width: 8,
            ),

             const SizedBox(
              height: 12,
            ),

             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 20),
               child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text: 
                      pObj["name"],
                      
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        Image.asset(
                        ImageConst.ratingsImage,
                        width: 10,
                        height: 10,
                        fit: BoxFit.cover,
                      ),

                      const SizedBox(
                        width: 4,
                      ),

                      CustomText(text: 
                        pObj["rate"],
                       
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      CustomText(text: 
                        "(${pObj["rating"]} Ratings)",
                       
                      
                      ),

                      const SizedBox(
                        width: 8,
                      ),

                        CustomText(text: 
                          pObj["type"],
                       
                        ),
                        CustomText(text: 
                          " . ",
                       
                        ),
                        CustomText(text: 
                          pObj["food_type"],
                         
                        ),
                      ],
                    ),
                    
                  ],
                ),
             ),
            
          ],
        ),
      ),
    );
  }
}
