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
    public class CrmFundingPeriodWriterTests
    {
        private readonly string TestPeriod = "TEST_PERIOD";
        private string TestFundingPeriod = "XXX_TEST";
        private readonly DateTime _now = DateTime.UtcNow.Date;

        [TestInitialize, TestCleanup]
        public void CleanUp()
        {
            IReadOnlyCollection<sfa_period> fundingPeriods = GetFundingPeriods(TestPeriod).ToList();
            if (fundingPeriods.Any())
            {
                foreach (var fundingPeriod in fundingPeriods)
                {
                    CrmHelper.GetConnection().Delete(CrmEntityName.FundingPeriod, fundingPeriod.Id);
                }
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFundingPeriodWriter_ShouldInsertNewRowIntoCrmWhenRowDoesNotExist()
        {
            // arrange
            IEnumerable<FundingPeriodSheetType> rows = new List<FundingPeriodSheetType>
            {
                new FundingPeriodSheetType
                {
                    PolicyStatus = PolicyStatus.Approved,
                    PeriodTypeCode = "AY",
                    Period = TestPeriod,
                    StartDate = DateTime.Now,
                    EndDate = DateTime.Now.AddYears(1),
                    FundingPeriod = TestFundingPeriod
                }
            };


            // act
            new CrmFundingPeriodWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            IEnumerable<sfa_period> fundingPeriods = GetFundingPeriods(TestPeriod);
            Assert.AreEqual(1, fundingPeriods.Count());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFundingPeriodWriter_ShouldUpdateExistingRowInCrmWhenRowExists()
        {
            // arrange
            IEnumerable<FundingPeriodSheetType> rows = new List<FundingPeriodSheetType>
            {
                new FundingPeriodSheetType
                {
                    PolicyStatus = PolicyStatus.Approved,
                    PeriodTypeCode = "AY",
                    Period = TestPeriod,
                    StartDate = DateTime.Now,
                    EndDate = DateTime.Now.AddYears(1),
                    FundingPeriod = TestFundingPeriod
                }
            };
            new CrmFundingPeriodWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);

            IEnumerable<FundingPeriodSheetType> updateRows = new List<FundingPeriodSheetType>
            {
                new FundingPeriodSheetType
                {
                    PolicyStatus = PolicyStatus.Approved,
                    PeriodTypeCode = "AY",
                    Period = TestPeriod,
                    StartDate = _now,
                    EndDate = _now.AddYears(1),
                    FundingPeriod = TestFundingPeriod
                }
            };

            // act
            new CrmFundingPeriodWriter().WriteToCrmDatabase(updateRows, WriterBehaviour.AddOrUpdate);

            // assert
            IReadOnlyCollection<sfa_period> fundingPeriods = GetFundingPeriods(TestPeriod).ToList();
            Assert.AreEqual(1, fundingPeriods.Count, "We have inserted a row when we wanted to do an insert");
            Assert.AreEqual(_now, fundingPeriods.First().sfa_StartDate.Value, "The Start date has not been updated");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFundingPeriodWriter_ShouldDeleteExistingRowInCrmWhenRowExistsAndPolicyStatusIsDeleted()
        {
            // arrange
            IEnumerable<FundingPeriodSheetType> rows = new List<FundingPeriodSheetType>
            {
                new FundingPeriodSheetType
                {
                    PolicyStatus = PolicyStatus.Approved,
                    PeriodTypeCode = "AY",
                    Period = TestPeriod,
                    StartDate = DateTime.Now,
                    EndDate = DateTime.Now.AddYears(1),
                    FundingPeriod = TestFundingPeriod
                }
            };
            new CrmFundingPeriodWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);

            IEnumerable<FundingPeriodSheetType> updateRows = new List<FundingPeriodSheetType>
            {
                new FundingPeriodSheetType
                {
                    PolicyStatus = PolicyStatus.Removed,
                    PeriodTypeCode = "AY",
                    Period = TestPeriod,
                    StartDate = DateTime.Now,
                    EndDate = DateTime.Now.AddYears(1),
                    FundingPeriod = TestFundingPeriod
                }
            };

            // act
            new CrmFundingPeriodWriter().WriteToCrmDatabase(updateRows, WriterBehaviour.Delete);

            // assert
            IEnumerable<sfa_period> fundingPeriods = GetFundingPeriods(TestPeriod);
            Assert.AreEqual(0, fundingPeriods.Count(), "We have not deleted the row");
        }

        private IEnumerable<sfa_period> GetFundingPeriods(string period)
        {
            using (var crmContext = new XrmServiceContext(Synchronizers.Writers.CRM.CrmHelper.GetConnection()))
            {
                var fundingPeriodQuery = from fp in crmContext.sfa_periodSet
                                         where fp.sfa_Period == period
                                         select fp;
                return fundingPeriodQuery.AsEnumerable();
            }
        }
    }
}
