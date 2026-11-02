namespace FCT.Console.Config.Tests.Crm
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using Synchronizers.Writers;
    using Synchronizers.Writers.CRM;

    [TestClass]
    public class CrmFundingStreamWriterTests 
    {
        private readonly string _testFundingStreamCode = "TEST_FUNDINGSTREAMCODE";
        private string _testFundingStreamName = "TEST_FUNDINGSTREAMNAME";
        private string _testFundingStreamShortCode = "TEST_FUNDINGSTREAM_SHORTCODE";

        [TestInitialize, TestCleanup]
        public void CleanUp()
        {
            var fundingStreams = GetFundingStreams(_testFundingStreamCode);
            if (fundingStreams.Any())
            {
                foreach (var fundingStream in fundingStreams)
                {
                    CrmHelper.GetConnection().Delete(CrmEntityName.FundingStream, fundingStream.Id);
                }
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFundingStreamWriter_ShouldInsertNewRowIntoCrmWhenRowDoesNotExist()
        {
            IEnumerable<FundingStreamSheetType> rows = GetRows();
            
            // act
            new CrmFundingStreamWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            IEnumerable<sfa_fundingstream> fundingPeriods = GetFundingStreams(_testFundingStreamCode);
            Assert.AreEqual(1, fundingPeriods.Count());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFundingStreamWriter_ShouldUpdateExistingRowInCrmWhenRowExists()
        {
            // arrange
            var updatedValue = "UpdatedValue";
            IEnumerable<FundingStreamSheetType> rows = GetRows();
            new CrmFundingStreamWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);

            IReadOnlyCollection<FundingStreamSheetType> updateRows = GetRows();
            updateRows.ToList()[0].AgencyCode = updatedValue;

            // act
            new CrmFundingStreamWriter().WriteToCrmDatabase(updateRows, WriterBehaviour.AddOrUpdate);

            // assert
            IReadOnlyCollection<sfa_fundingstream> fundingStreams = GetFundingStreams(_testFundingStreamCode);
            Assert.AreEqual(1, fundingStreams.Count, "We have inserted a row when we wanted to do an insert");
            Assert.AreEqual(updatedValue, fundingStreams.First().sfa_AgencyCode, "The Agency code has not been updated");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFundingPeriodWriter_ShouldDeleteExistingRowInCrmWhenRowExistsAndPolicyStatusIsDeleted()
        {
            // arrange
            IEnumerable<FundingStreamSheetType> rows = GetRows();
            new CrmFundingStreamWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);

            IEnumerable<FundingStreamSheetType> updateRows = GetRows();
            updateRows.ToList()[0].PolicyStatus = PolicyStatus.Removed;

            // act
            new CrmFundingStreamWriter().WriteToCrmDatabase(updateRows, WriterBehaviour.Delete);

            // assert
            IEnumerable<sfa_fundingstream> fundingPeriods = GetFundingStreams(_testFundingStreamCode);
            Assert.AreEqual(0, fundingPeriods.Count(), "We have not deleted the row");
        }

        private IReadOnlyCollection<sfa_fundingstream> GetFundingStreams(string fundingStreamCode)
        {
            using (var crmContext = new XrmServiceContext(Synchronizers.Writers.CRM.CrmHelper.GetConnection()))
            {
                var fundingStreamQuery = from fs in crmContext.sfa_fundingstreamSet
                                         where fs.sfa_fundingstreamcode == fundingStreamCode
                                         select fs;
                return fundingStreamQuery.ToList();
            }
        }

        private IReadOnlyCollection<FundingStreamSheetType> GetRows()
        {
            // arrange
            return new List<FundingStreamSheetType>
            {
                new FundingStreamSheetType
                {
                    Code = _testFundingStreamCode,
                    Name = _testFundingStreamName,
                    AgencyCode = "RandomName",
                    StartDate = DateTime.Now.ToUniversalTime(),
                    EndDate = DateTime.Now.ToUniversalTime().AddYears(1),
                    FinanceShortCode = _testFundingStreamShortCode
                }
            };
        }
    }
}
