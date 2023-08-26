public class StringArrayTest {
    public static String[] generateStringArray(Integer num){
        List<String> lstStr = new List<String>();
        for(Integer i=0; i<num; i++){
            lstStr.add('Test '+i);
        }
        system.debug('lst='+lstStr);
        return lstStr;
    }

}