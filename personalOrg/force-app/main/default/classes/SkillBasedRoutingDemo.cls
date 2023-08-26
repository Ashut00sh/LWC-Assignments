public class SkillBasedRoutingDemo {
    @InvocableMethod
    public static void routingCasesToAgents(List<String> caseIds){
        //create PSR
        //add skills to request for the case 
        //push it to  queue
        List<Skill> allSkillIds = new List<Skill>([SELECT Id, MasterLabel FROM Skill]);
		List<Case> caseInserted = [SELECT Id, Subject FROM Case WHERE ID IN: caseIds];
        List<ServiceChannel> serviceChannelId = new List<ServiceChannel>([SELECT Id, DeveloperName FROM ServiceChannel WHERE DeveloperName = 'Case_Channel']);
        Id serviceId;
        for(ServiceChannel Ids : serviceChannelId){
            serviceId = Ids.Id;
        }
        for(Case caseRec : caseInserted){
            PendingServiceRouting psr = new PendingServiceRouting();
            psr.workItemId = caseRec.Id;
            psr.RoutingType = 'SkillsBased';
            psr.RoutingPriority = 1; 
            psr.CapacityWeight = 1;
            psr.ServiceChannelId = serviceId;
            psr.RoutingModel = 'MostAvailable';
            psr.IsReadyForRouting = FALSE;
            Insert psr;
            //Finds  out the skills required for a given case based on its subject
            //List<Skill> masterLabel = new List<Skill>();
            List<String> matchingSkillsIds = new List<string>();
            for(Skill skillRec : allSkillIds){
                if(caseRec.Subject.contains(skillRec.MasterLabel)){
                    matchingSkillsIds.add(skillRec.Id);
                }
            }
            //Associate matching skills with psr request
            List<SkillRequirement> skillReqsToInsert = new List<SkillRequirement>();
            for(String matchingSkillsId : matchingSkillsIds){
                SkillRequirement skillReq = new SkillRequirement();
                skillReq.SkillId = matchingSkillsId;
                skillReq.RelatedRecordId = psr.Id;
                skillReq.SkillLevel = 7;
                skillReqsToInsert.add(skillReq);
            }
            insert skillReqsToInsert;
            //push psr request in to queue
            psr.IsReadyForRouting = TRUE;
            update psr;
        } 
    }
}