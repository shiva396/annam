import 'package:flutter/material.dart';
import 'package:projrect_annam/utils/custom_text.dart';

import '../const/image_const.dart';

class RecentItemRow extends StatelessWidget {
  final Map rObj;
  final VoidCallback onTap;
  const RecentItemRow({super.key, required this.rObj, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                rObj["image"].toString(),
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 8,
            ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  
                 CustomText(text: 
                    rObj["name"],
                  
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomText(text: 
                        rObj["type"],
                       
                      ),
                      CustomText(text: 
                        " . ",
                      
                      ),
                      CustomText(text: 
                        rObj["food_type"],
                      
                      ),
                      
                    ],
                  ),
                    const SizedBox(
                    height: 4,
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
                        rObj["rate"],
                      
                      ),

                       const SizedBox(
                        width: 8,
                      ),

                      CustomText(text: 
                        "(${ rObj["rating"] } Ratings)",
                   
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
