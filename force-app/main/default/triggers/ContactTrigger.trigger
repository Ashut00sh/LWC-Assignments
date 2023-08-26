trigger ContactTrigger on Contact (before insert, after Insert) {
    if(trigger.isBefore && trigger.isInsert){
        Set<String> phoneSet = new Set<String>();
        Set<String> emailSet = new Set<String>();
        Set<String> exstingPhoneSet = new Set<String>();
        Set<String> existingEmailSet = new Set<String>();
        for(Contact contactObj : trigger.new){
            phoneSet.add(contactObj.Phone);
            emailSet.add(contactObj.Email);
        }
        for(Contact contactObj : [SELECT Id, Phone, Email FROM Contact WHERE Phone IN: phoneSet OR Email IN: emailSet]){
            exstingPhoneSet.add(String.valueof(contactObj.Phone));
            existingEmailSet.add(String.valueof(contactObj.Email));
        }
        for(Contact contactObj : trigger.new){
            if((!existingEmailSet.isEmpty() && existingEmailSet.contains(contactObj.Email)) ||
            (!exstingPhoneSet.isEmpty() && exstingPhoneSet.contains(contactObj.Phone))){
                //contactObj.addError('You can not insert duplicate contact');
            }
        }
    }
    if(trigger.isAfter && trigger.isInsert){
        System.debug('after insert contact');
        List<Account> accountLstToInsert = new List<Account>();
        Map<String, Contact> accNameVsContactmap = new Map<String, Contact>();
        for(Contact contactObj : trigger.new){
            string accName = contactObj.FirstName + ' '+ contactObj.LastName;
            accNameVsContactmap.put(accName, contactObj);
            System.debug('contact trigger new:: '+contactObj);
            Account accountObj = new Account();
            accountObj.Name = accName;
            accountObj.Billing_State__c = 'Tripura';
            accountObj.Id = contactObj.AccountId;
            accountLstToInsert.add(accountObj);
        }
        if(!accountLstToInsert.isEmpty() && StopRecurssionTrigger.runOnce()){
            Insert accountLstToInsert;
        }
        for(Account accountObj : accountLstToInsert){
            // if(accNameVsContactmap.containsKey(accountObj.Name)){
            //     accNameVsContactmap.get(accountObj.Name).AccountId = accountObj.Id;
            //     Update accNameVsContactmap.Values();
            // }
            System.debug('accNameVsContactmap.Values(): '+accNameVsContactmap.Values());
        }
    }
}