namespace FctServices.Test.ServiceTests
{
    using System.Collections.Generic;
    using Deds;
    using Deds.Entities;
    using global::DedsSearchService;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class ReportedActualTransformerTest
    {
        [TestMethod]
        public void ShouldTransformReportedActualToQueryResultWithFieldsSet()
        {
            IList<ReportedActual> reportedActuals = GetSomeActuals(2);

            QueryResults[] queryResults = EntityTransformer<ReportedActual>.TransformToQueryResults(reportedActuals);
            
            Assert.IsTrue(queryResults[0].FieldNames.Length > 0);
        }

        [TestMethod]
        public void ShouldTransformReportedActualToQueryResultWithValuesSet()
        {
            const int numActuals = 1;
            IList<ReportedActual> reportedActuals = GetSomeActuals(numActuals);

            QueryResults[] queryResults = EntityTransformer<ReportedActual>.TransformToQueryResults(reportedActuals);

            Assert.IsTrue(queryResults[0].Results.Length == numActuals);
        }

        private IList<ReportedActual> GetSomeActuals(int numActuals)
        {
            List<ReportedActual> reportedActuals = new List<ReportedActual>();
            for (int i = 0; i < numActuals; i++)
            {
                reportedActuals.Add(CreateReportedActual());    
            }

            return reportedActuals;
        }

        private ReportedActual CreateReportedActual()
        {
            return new ReportedActual
            {
                CollectionReturnCode = "EopR1",
                OrganisationId = "12345678",
                PeriodTypeCode = "CM",
                Period = "201408",
                FundingStreamPeriodCode = "24+ALLF1314",
                CollectionType = "24ALLF",
                ContractAllocationNumber = null,
                UoPCode = "0",
                DeliverableCode = "3",
                ActualVolume = 1000
            };
        }
    }
}
