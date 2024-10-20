import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:palette_generator/palette_generator.dart';

class Swiper extends StatefulWidget {
  const Swiper({super.key});

  @override
  State<Swiper> createState() => _SwiperState();
}

class _SwiperState extends State<Swiper> {

  int currentindex=0;

  List images=[
    'assets/genres_icons/accion.png','assets/genres_icons/animacion.png',
    'assets/genres_icons/aventura.png','assets/genres_icons/comedia.png',
    'assets/genres_icons/crimen.png','assets/genres_icons/documental.png',
    'assets/genres_icons/drama.png','assets/genres_icons/familia.png',
  ];

  PaletteGenerator? paletteGenerator;



  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor:Color.fromRGBO(34, 9, 44, 1),
      
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        height: 300,
        child: CardSwiper(
          
          cardsCount: 8,

          cardBuilder: (context,index,x,y){
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(images[index],fit: BoxFit.cover,),
            );
          }, 
          
          
          allowedSwipeDirection: AllowedSwipeDirection.only(left: true, right: true),
          
          numberOfCardsDisplayed: 2,
          
          isLoop: true,

          backCardOffset: Offset(0,0),

          onSwipe: (prevoius,current,direction){

            currentindex=current!;
            if(direction==CardSwiperDirection.right){
              Fluttertoast.showToast(msg: 'Te ha gustado',backgroundColor: Colors.white,fontSize: 28);
            }
            else if (direction==CardSwiperDirection.left){
              Fluttertoast.showToast(msg: 'No te ha gustado',backgroundColor: Colors.white,fontSize: 28);
            }
            return true;

          },

          ),
      ),
    );
  }
}

