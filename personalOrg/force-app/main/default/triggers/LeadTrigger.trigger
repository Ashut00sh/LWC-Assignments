trigger LeadTrigger on Lead (after update) {
if ( trigger.isAfter && trigger.isUpdate) {
    System.debug('afterUpdate:: '+trigger.NewMap);
    System.debug('afterUpdate:: '+trigger.New);
    List<Lead> leadLst = new List<Lead>();
    // for(lead leadObj : trigger.New){
    //     System.debug('leadName1: '+leadObj.Name);
    //     leadLst.add(trigger.newMap.get(leadObj.Id));
    // }
    List<Database.LeadConvert> leadToConvertLst = new List<Database.LeadConvert>();
    for(Lead leadObj : trigger.New){
        System.debug('LeadName2:: '+leadObj.Name);
        System.debug('old Status:: '+ trigger.oldmap.get(leadObj.Id).Status);
        if(leadObj.Status == 'Processed' && leadObj.Status != trigger.oldmap.get(leadObj.Id).Status){
            Database.LeadConvert leadConvertObj = new database.LeadConvert();
            leadConvertObj.setLeadId(leadObj.Id);
            leadConvertObj.setDoNotCreateOpportunity(false);
            leadConvertObj.setOpportunityName(leadObj.FirstName+' '+leadObj.LastName+' ' + 'Opportunity');
            leadConvertObj.setConvertedStatus('Closed - Converted');
            leadToConvertLst.add(leadConvertObj);
        }
        if(leadObj.status == 'Working - Contacted'){
            System.debug('status new:: '+leadObj.status);
            Database.LeadConvert leadConvertObj = new Database.LeadConvert();
            leadConvertObj.setLeadId(leadObj.Id);
            leadConvertObj.setDoNotCreateOpportunity(false);
            leadConvertObj.setOpportunityName(leadObj.FirstName+' '+leadObj.LastName+' ');
            leadConvertObj.setConvertedStatus('Closed - Converted');
            leadToConvertLst.add(leadConvertObj);
        }
    }
    if(leadToConvertLst != null && !leadToConvertLst.isEmpty()){
        System.debug('lead lstLL '+ leadToConvertLst);
        dataBase.leadConvertResult[] lcr = database.convertLead(leadToConvertLst, false);
        System.debug('convert lead Result:: '+ lcr);
    }
}
}