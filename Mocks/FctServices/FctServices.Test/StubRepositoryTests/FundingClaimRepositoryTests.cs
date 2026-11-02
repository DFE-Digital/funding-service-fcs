namespace FctServices.Test.StubRepositoryTests
{
    using Deds;
    using Deds.Entities;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Storage;

    [TestClass]
    public class FundingClaimRepositoryTests
    {
        private IFundingClaimRepository _fundingClaimRepository;
        private IAzureTableStore _azureTableStore;
        private IEnvironmentContext _environmentContext;
        private const string TableName = "FundingClaimStub";
        private const string Period = "1516";
        private const string FinalClaimType = "Final";
        private const string YearEndClaimType = "Year End";

        [TestInitialize]
        public void Setup()
        {
            _azureTableStore = new AzureTableStore();
            _environmentContext = new EnvironmentContext();
            _fundingClaimRepository = new FundingClaimRepository(_azureTableStore, _environmentContext);
        }

        [TestCleanup]
        public void CleanUp()
        {
            DeleteFundingClaimForPartitionKey(FundingClaim.CreatePartitionKey(Period, YearEndClaimType));
            DeleteFundingClaimForPartitionKey(FundingClaim.CreatePartitionKey(Period, FinalClaimType));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaimRepository_CallGetCompletedClaimTypePeriods_Returns2Records()
        {
            SetupRows(Period, YearEndClaimType, 5);
            SetupRows(Period, FinalClaimType, 5);

            var claimTypePeriods = _fundingClaimRepository.GetCompletedClaimTypePeriods();

            Assert.AreEqual(2, claimTypePeriods.Count);
            Assert.AreEqual(FundingClaim.CreatePartitionKey(Period, YearEndClaimType), claimTypePeriods[1]);
            Assert.AreEqual(FundingClaim.CreatePartitionKey(Period, FinalClaimType), claimTypePeriods[0]);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaimRepository_CallGetTotal_ReturnsCorrectCountsForPeriodClaimTypeCombination()
        {
            SetupRows(Period, YearEndClaimType, 10);
            SetupRows(Period, FinalClaimType, 15);

            var yearEndTotalCount = _fundingClaimRepository.GetTotal(Period, YearEndClaimType);
            var finalTotalCount = _fundingClaimRepository.GetTotal(Period, FinalClaimType);

            Assert.AreEqual(10, yearEndTotalCount);
            Assert.AreEqual(15, finalTotalCount);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaimRepository_CallGetRows_ReturnsRowsForPeriodClaimTypeCombinationSinglePage()
        {
            SetupRows(Period, YearEndClaimType, 4);
            SetupRows(Period, FinalClaimType, 3);

            var yearEndFundingClaimRecords = _fundingClaimRepository.GetRows(1, 10, Period, YearEndClaimType);
            var finalFundingClaimRecords = _fundingClaimRepository.GetRows(1, 10, Period, FinalClaimType);

            Assert.AreEqual(4, yearEndFundingClaimRecords.Count);
            Assert.AreEqual(3, finalFundingClaimRecords.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaimRepository_CallGetRows_ReturnsRowsForPeriodClaimTypeCombinationMultiplePages_GetPagedResults()
        {
            SetupRows(Period, YearEndClaimType, 15);

            var yearEndFundingClaimRecordsPage1 = _fundingClaimRepository.GetRows(1, 10, Period, YearEndClaimType);
            Assert.AreEqual(10, yearEndFundingClaimRecordsPage1.Count);

            var yearEndFundingClaimRecordsPage2 = _fundingClaimRepository.GetRows(2, 10, Period, YearEndClaimType);
            Assert.AreEqual(5, yearEndFundingClaimRecordsPage2.Count);
        }

        private int rowCount;

        private void SetupRows(string period, string claimType, int count)
        {
            for (int i = 0; i < count; i++)
            {
                rowCount += 1;
                AddFundingClaim(new FundingClaim($"funding Claim xml {rowCount}", period, claimType), rowCount);
            }
        }

        private void AddFundingClaim(FundingClaim fundingClaim, int rowKey)
        {
            fundingClaim.RowKey = rowKey.ToString("D8");
            _azureTableStore.CreateRow(CreateContextualTableName(), fundingClaim);
        }

        private void DeleteFundingClaimForPartitionKey(string partitionKey)
        {
            _azureTableStore.DeleteRows(CreateContextualTableName(), partitionKey);
        }

        private string CreateContextualTableName()
        {
            return TableName + _environmentContext.StorageTableSuffix;
        }
    }
}
