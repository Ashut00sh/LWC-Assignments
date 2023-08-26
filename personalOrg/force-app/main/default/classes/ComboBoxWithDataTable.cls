public class ComboBoxWithDataTable {
    @AuraEnabled(Cacheable = true)
    public static List<Account> getAccounts(){
        List<Account> lstAccount = [select id, name from account];
        return lstAccount;
    }
    @AuraEnabled(Cacheable=true)
    public static List<Contact> getContactRec(String AccountId){
        try {
            List<Contact> contactLst = [select id, Name, Email From Contact where AccountId =: AccountId];
            return contactLst;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}