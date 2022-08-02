import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_player/src/helpers/helpers.dart';
import 'package:music_player/src/models/audioplayer_model.dart';
import 'package:music_player/src/widget/custom_appbar.dart';
import 'package:provider/provider.dart';

class MusicPlayerPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[

          Background(),

          Column(
            children: <Widget>[
              CustomappBar(),

              ImagenDiscoDuracion(),

              TituloPlay(),

              Expanded(
                child: Lyrics()
              ),
            ]
          ),
        ],
      ),
    );
  }
}

class Background extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: screenSize.height * 0.8,

      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60)),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.center,
          colors: [
            Color(0xff33333E),
            Color(0xff201E28),
          ]
        )
      ),
    );
  }
}

class Lyrics extends StatelessWidget {

  final lyrics = getLyrics();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListWheelScrollView(
        physics: BouncingScrollPhysics(),
        itemExtent: 42, 
        diameterRatio: 1.5,
        children: lyrics.map(
          (linea) => Text(linea, style: TextStyle(fontSize: 20, color: Colors.white.withOpacity(0.6)))
        ).toList()
      ),
    );
  }
}

class TituloPlay extends StatefulWidget {


  @override
  State<TituloPlay> createState() => _TituloPlayState();
}

class _TituloPlayState extends State<TituloPlay> with SingleTickerProviderStateMixin {

  bool isPlaying = false;
  bool firstTime = false;
  late AnimationController playAnimation;


  final assetAudioPlayer = new AssetsAudioPlayer();
  
  @override
  void initState() {
    playAnimation = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    super.initState();
  }

  @override
  void dispose() {
    playAnimation.dispose();
    super.dispose();
  }

  void open() {
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context, listen: false);

    // assetAudioPlayer.open(
    //   Audio('assets/mi-despedida.mp3'),
    //   autoStart: false,
    //   showNotification: true
    // );
    
    AssetsAudioPlayer.newPlayer().open(
    Audio("assets/mi-despedida.mp3"),
    autoStart: false,
    showNotification: true,
);


    

    assetAudioPlayer.currentPosition.listen((duration) {
      audioPlayerModel.current = duration;
    });


    assetAudioPlayer.current.listen((playingAudio) {
      audioPlayerModel.songDuration = playingAudio!.audio.duration;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      margin: EdgeInsets.only(top: 40),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Text('Mi Despedida', style: TextStyle(fontSize: 30, color: Colors.white.withOpacity(0.8))),
              Text('Los de limit', style: TextStyle(fontSize: 15, color: Colors.grey)),
            ],
          ),

          Spacer(),

          FloatingActionButton(
            elevation: 0,
            highlightElevation: 0,
            backgroundColor: Color(0xffF8CB51),
            child: AnimatedIcon(
              icon: AnimatedIcons.play_pause, 
              progress: playAnimation,
            ),

            onPressed: (){
              final audioPlayerModel = Provider.of<AudioPlayerModel>(context, listen: false); 

              if(isPlaying){
                playAnimation.reverse();
                isPlaying = false;
                audioPlayerModel.controller.stop();
              }else{
                playAnimation.forward();
                isPlaying = true;
                audioPlayerModel.controller.repeat();
              }

              if(firstTime){
                this.open();
                firstTime = false;
              }else{
                assetAudioPlayer.playOrPause();
              }
            }
          )
        ],
      ),
    );
  }
}

class ImagenDiscoDuracion extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      margin: EdgeInsets.only(top: 70),
      child: Row(

        children: <Widget>[
          ImagenDisco(),
          SizedBox(width: 40),

          BarraProgreso(),
          SizedBox(width: 20),
        ],
      ),
    );
  }
}

class BarraProgreso extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final estilo = TextStyle(color: Colors.white.withOpacity(0.4));

    final audioPlayerModel = Provider.of<AudioPlayerModel>(context);

    final porcentaje = audioPlayerModel.porcentaje;

    return Container(
      child: Column(
        children: <Widget>[
          Text('${audioPlayerModel.songTotalDuration}', style: estilo),
          SizedBox(height: 10),

          Stack(
            children: <Widget>[
              Container(
                width: 3,
                height: 230,
                color: Colors.white.withOpacity(0.1),
              ),

              Positioned(
                bottom: 0,
                child: Container(
                  width: 3,
                  height: 230 * porcentaje,
                  color: Colors.white.withOpacity(0.8),
                ),
              )
            ],
          ),
          
          SizedBox(height: 10),
          Text('${audioPlayerModel.currentSecond}', style: estilo),
        ],
      ),
    );
  }
}

class ImagenDisco extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final audioPlayerModel = Provider.of<AudioPlayerModel>(context);
    final screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.all(20),
      width: screenSize.width * 0.58,
      height: 240,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child:  Stack(
          alignment: Alignment.center,
          children:   <Widget>[

            SpinPerfect(
              duration: Duration(seconds: 10),
              infinite: true,
              manualTrigger: true,
              controller: (animationController) => audioPlayerModel.controller = animationController,
              child: Image( image: AssetImage('assets/Screen.jpg'),)
            ),

            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.black38,
              ),
            ),

            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Color(0xff1C1C25),
              ),
            ),
          ],
        )
      ),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          colors: [
            Color(0xff484750),
            Color(0xff1E1C24)
          ]
        )
      ),
    );
  }
}