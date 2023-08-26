public class WireDemoClass {
    @AuraEnabled(Cacheable=true)
    public static List<Account> getAccountRec(){
        List<Account> accountLst = [SELECT Id, Name FROM Account ORDER BY Name ASC LIMIT 5];
        return accountLst;
    }

}