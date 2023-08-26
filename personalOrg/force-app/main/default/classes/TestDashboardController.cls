@isTest
private class TestDashboardController {
    @isTest
    static void testDashboardDataFetching() {
        // Create test data
        List<Custom_Object__c> testRecords = new List<Custom_Object__c>{
            new Custom_Object__c(Name = 'Record 1', Value__c = 10),
            new Custom_Object__c(Name = 'Record 2', Value__c = 20),
            new Custom_Object__c(Name = 'Record 3', Value__c = 30)
        };
        insert testRecords;

        // Create a dashboard component
        DashboardComponent__c dashboardComponent = new DashboardComponent__c(Name = 'Test Component');
        insert dashboardComponent;

        // Set up the controller with test data
        DashboardController controller = new DashboardController(dashboardComponent.Id);

        // Call the method to fetch data
        List<Custom_Object__c> fetchedData = controller.fetchDashboardData();

        // Assert that the fetched data matches the expected data
        System.assertEquals(testRecords.size(), fetchedData.size(), 'Fetched data size does not match.');

        for (Integer i = 0; i < testRecords.size(); i++) {
            System.assertEquals(testRecords[i].Name, fetchedData[i].Name, 'Record name does not match.');
            System.assertEquals(testRecords[i].Value__c, fetchedData[i].Value__c, 'Record value does not match.');
        }
    }
}
