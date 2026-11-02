namespace AllocationDeliveryDomain.DedsClient.Test
{
    using System.Collections.Generic;
    using System.Linq;
    using DedsSearchService;
    using Dtos;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class QueryResultTransformerTest
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ShouldTransformQueryResultToReportedActualsWithFieldsSet()
        {
            IList<QueryResults> results = GetSomeQueryResults();

            IEnumerable<ReportedActual> reportedActuals = QueryResultTransformer.TransformToReportedActuals(results);

            Assert.IsTrue(reportedActuals.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldTransformQueryResultToReportedActualToWithValuesSet()
        {
            IList<QueryResults> results = GetSomeQueryResults();
            IEnumerable<ReportedActual> reportedActuals = QueryResultTransformer.TransformToReportedActuals(results);
            Assert.IsTrue(reportedActuals.Count() == 5);
        }

        private IList<QueryResults> GetSomeQueryResults()
        {
            IList<QueryResults> queryResult = new List<QueryResults>();
            queryResult.Add(CreateQueryResults());
            return queryResult;
        }

        private QueryResults CreateQueryResults()
        {
            string[] fieldNames = {
                "CollectionReturnCode",
                "OrganisationId",
                "PeriodTypeCode",
                "Period",
                "FundingStreamPeriodCode",
                "CollectionType",
                "ContractAllocationNumber",
                "UoPCode",
                "DeliverableCode",
                "ActualVolume",
                "ActualValue"
            };

            string[][] results = {
                    new[] {"EopR1", "10000020", "CM","201403","24+ALLF1415","24ALLF","","0","3","13928","0.00"},
                    new[] {"EopR1", "10000021", "CM","201403","24+ALLF1415","24ALLF","","0","3","13928","0.00"},
                    new[] {"EopR1", "10000022", "CM","201403","24+ALLF1415","24ALLF","","0","3","13928","0.00"},
                    new[] {"EopR1", "10000023", "CM","201403","24+ALLF1415","24ALLF","","0","3","13928","0.00"},
                    new[] {"EopR1", "10000024", "CM","201403","24+ALLF1415","24ALLF","","0","3","13928","0.00"},
                };

            return new QueryResults { FieldNames = fieldNames, Results = results };
        }
    }
}
