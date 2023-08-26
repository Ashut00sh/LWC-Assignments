public with sharing class StopRecurssionTrigger {
   private static boolean stopRecurssion = true;
   public static boolean runOnce(){
      if(stopRecurssion){
         stopRecurssion = false;
         return true;
      }else{
         return stopRecurssion;
      }
   }
}