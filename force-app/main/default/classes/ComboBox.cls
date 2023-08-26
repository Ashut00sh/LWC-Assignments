public class ComboBox {
    @auraenabled(cacheable = true)
    public static list<Account> getAccount(){
        list<Account> accountLst = [SELECT Id, Name FROM Account LIMIT 10];
        return accountLst;
    }

}