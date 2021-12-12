import processing.sound.*; //sound library
class mySound{
  SoundFile sound;
  int played = 0;
  mySound( String path){
    
     sound = new SoundFile(project.this, path); //https://stackoverflow.com/questions/30882728/instantiating-a-soundfile-object-within-a-class-in-processing
     
  }
  
  void play(){
    if(toc - played < 10) return; //
    played = toc;
    sound.play();
  }
}
