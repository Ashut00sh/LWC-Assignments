@isTest
private class TestReportGenerator {
    @isTest
    static void testReportGeneration() {
        List<Integer> testData = new List<Integer>{10, 20, 30, 40, 50};
        
        ReportGenerator reportGenerator = new ReportGenerator(testData);
        String generatedReport = reportGenerator.generateReport();
        
        String expectedReport = 'Sample Report:\nTotal: 150\nAverage: 30.0\n';
        
        System.assertEquals(expectedReport, generatedReport, 'Report generation test failed!');
    }
}
