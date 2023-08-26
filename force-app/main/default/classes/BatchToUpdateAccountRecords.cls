public class BatchToUpdateAccountRecords implements Database.Batchable<SObject>,Database.stateful{
    Integer count = 0;
    static string query = 'select id, Name from Account';
    public Database.QueryLocator start(Database.BatchableContext bc){
        System.debug('in start '+bc);
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc, List<Account> accountLst){
        count++;
        System.debug('Inexecute: '+bc);
        System.debug('count: '+count);
        List<Account> accountLstToUpdate = new List<Account>();
        for(Integer i=0; i<9999; i++){
        //for(Account accObj : accountLst){
            Account accObj = new Account();
            accObj.Name = 'Test Acc ';
            accountLstToUpdate.add(accObj);
        }
        System.debug('size: '+accountLstToUpdate.size());
        Insert accountLstToUpdate;
    }
    public void finish(Database.BatchableContext bc){
        System.debug('In Finish apex jobs....'+bc);
        System.debug('count in finish: '+count);
    }
}