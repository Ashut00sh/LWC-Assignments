@RestResource(urlMapping = '/getContactInfo/*')
global class WebServiseOrg2 {
    @HttpPost
    global static String getContact(){
        System.debug('IN getContact Info....');
        String requestBody = RestContext.request.requestBody.toString();
        system.debug('requestBody = '+requestBody);
        Contact objCon = (Contact)JSON.deserialize(requestBody,Contact.class);
        System.debug('objCon : '+objCon.LastName);
 		system.debug('deserialize objcon');
        system.debug(objCon);
      	insert objCon;
        return objCon.Id;
    }
    
}