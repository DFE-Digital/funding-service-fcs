namespace FCT.Console.Config.Tests.Crm
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using Synchronizers.Writers;
    using Synchronizers.Writers.CRM;

    [TestClass]
    public class CrmFundingStreamPeriodWriterTests
    {
        private readonly string TestFundingStreamPeriodCode = "TEST_FSP";

        [TestInitialize, TestCleanup]
        public void CleanUp()
        {
            var fundingStreamPeriods = GetFundingStreamPeriods(TestFundingStreamPeriodCode);
            if (fundingStreamPeriods.Any())
            {
                foreach (var fundingStreamPeriod in fundingStreamPeriods)
                {
                    CrmHelper.GetConnection().Delete("sfa_fundingstreamperiod", fundingStreamPeriod.Id);
                }
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFundingStreamPeriodWriter_ShouldInsertNewRowIntoCrmWhenRowDoesNotExist()
        {
            // arrange
            IEnumerable<FundingStreamPeriodSheetType> rows = new List<FundingStreamPeriodSheetType>
            {
                new FundingStreamPeriodSheetType
                {
                    PolicyStatus = PolicyStatus.Approved,
                    PeriodTypeCode = "AY",
                    Period = "1516",
                    StartDate = DateTime.Now,
                    EndDate = DateTime.Now.AddYears(1),
                    PaymentMethod = "Pay On Actuals",
 
                    FundingStreamCode = "16-18 APPS",
                    FundingStreamPeriodCode = TestFundingStreamPeriodCode,
                    Name = "Test FSP Name"
                }
            };

            // act
            new CrmFundingStreamPeriodWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            IEnumerable<sfa_fundingstreamperiod> fundingStreamPeriods = GetFundingStreamPeriods(TestFundingStreamPeriodCode);
            Assert.AreEqual(1, fundingStreamPeriods.Count());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFundingStreamPeriodWriter_ShouldInsertNewRowIntoCrmWhenRowDoesNotExist_WithPayOnInstruction()
        {
            // arrange
            IEnumerable<FundingStreamPeriodSheetType> rows = new List<FundingStreamPeriodSheetType>
            {
                new FundingStreamPeriodSheetType
                {
                    PolicyStatus = PolicyStatus.Approved,
                    PeriodTypeCode = "AY",
                    Period = "1516",
                    StartDate = DateTime.Now,
                    EndDate = DateTime.Now.AddYears(1),
                    PaymentMethod = "Pay On Instruction",

                    FundingStreamCode = "16-18 APPS",
                    FundingStreamPeriodCode = TestFundingStreamPeriodCode,
                    Name = "Test FSP Name"
                }
            };

            // act
            new CrmFundingStreamPeriodWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            IList<sfa_fundingstreamperiod> fundingStreamPeriods = GetFundingStreamPeriods(TestFundingStreamPeriodCode).ToList();
            Assert.AreEqual(1, fundingStreamPeriods.Count);
            Assert.AreEqual(sfa_fundingstreampaymenttype.PayOnInstruction, (sfa_fundingstreampaymenttype)fundingStreamPeriods[0].sfa_PaymentType.Value);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFundingStreamPeriodWriter_ShouldUpdateRowInCrmWhenRowDoesExist()
        {
            // arrange
            IEnumerable<FundingStreamPeriodSheetType> rows = new List<FundingStreamPeriodSheetType>
            {
                new FundingStreamPeriodSheetType
                {
                    PolicyStatus = PolicyStatus.Approved,
                    PeriodTypeCode = "AY",
                    Period = "1516",
                    StartDate = DateTime.Now,
                    EndDate = DateTime.Now.AddYears(1),
                    PaymentMethod = "Pay On Actuals",

                    FundingStreamCode = "16-18 APPS",
                    FundingStreamPeriodCode = TestFundingStreamPeriodCode,
                    Name = "Test FSP Name"
                }
            };

            new CrmFundingStreamPeriodWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);

            IEnumerable<FundingStreamPeriodSheetType> updateRows = new List<FundingStreamPeriodSheetType>
            {
                new FundingStreamPeriodSheetType
                {
                    PolicyStatus = PolicyStatus.Approved,
                    PeriodTypeCode = "AY",
                    Period = "1516",
                    StartDate = DateTime.Now,
                    EndDate = DateTime.Now.AddYears(1),
                    PaymentMethod = "Pay On Profile",
                    PaymentCappingLevel = "Deliverable Group",
                    FundingStreamCode = "16-18 APPS",
                    FundingStreamPeriodCode = TestFundingStreamPeriodCode,
                     Name = "Test FSP Name Updated"
                }
            };

            // act
            new CrmFundingStreamPeriodWriter().WriteToCrmDatabase(updateRows, WriterBehaviour.AddOrUpdate);

            // assert
            IEnumerable<sfa_fundingstreamperiod> fundingStreamPeriods = GetFundingStreamPeriods(TestFundingStreamPeriodCode);
            var fundingStreamPeriodUpdated = fundingStreamPeriods.First();
            Assert.AreEqual(sfa_paymentcappinglevel.Group, (sfa_paymentcappinglevel)fundingStreamPeriodUpdated.sfa_PaymentCappingLevel.Value);
            Assert.AreEqual(sfa_fundingstreampaymenttype.PayOnProfile, (sfa_fundingstreampaymenttype)fundingStreamPeriodUpdated.sfa_PaymentType.Value);
            Assert.AreEqual("Test FSP Name Updated", fundingStreamPeriodUpdated.sfa_fundingstreamperiodname);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFundingStreamPeriodWriter_ShouldDeleteExistingRowInCrmWhenRowExistsAndPolicyStatusIsDeleted()
        {
            // arrange
            IEnumerable<FundingStreamPeriodSheetType> rows = new List<FundingStreamPeriodSheetType>
            {
                new FundingStreamPeriodSheetType
                {
                    PolicyStatus = PolicyStatus.Approved,
                    PeriodTypeCode = "AY",
                    Period = "1516",
                    StartDate = DateTime.Now,
                    EndDate = DateTime.Now.AddYears(1),
                    PaymentMethod = "Pay On Actuals",

                    FundingStreamCode = "16-18 APPS",
                    FundingStreamPeriodCode = TestFundingStreamPeriodCode,
                    Procurement =  "NCS",
                    Name = "Test FSP Name"
                }
            };

            new CrmFundingStreamPeriodWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);

            IEnumerable<FundingStreamPeriodSheetType> rowsToDelete = new List<FundingStreamPeriodSheetType>
            {
                new FundingStreamPeriodSheetType
                {
                    PolicyStatus = PolicyStatus.Removed,
                    PeriodTypeCode = "AY",
                    Period = "1516",
                    StartDate = DateTime.Now,
                    EndDate = DateTime.Now.AddYears(1),
                    PaymentMethod = "Pay On Actuals",

                    FundingStreamCode = "16-18 APPS",
                    FundingStreamPeriodCode = TestFundingStreamPeriodCode,
                    Procurement =  "NCS",
                    Name = "Test FSP Name"
                }
            };

            new CrmFundingStreamPeriodWriter().WriteToCrmDatabase(rowsToDelete, WriterBehaviour.Delete);

            IEnumerable<sfa_fundingstreamperiod> fundingStreamPeriods = GetFundingStreamPeriods(TestFundingStreamPeriodCode);
            
            Assert.AreEqual(0, fundingStreamPeriods.Count());
        }

        private IEnumerable<sfa_fundingstreamperiod> GetFundingStreamPeriods(string fundingStreamPeriodCode)
        {
            using (var crmContext = new XrmServiceContext(Synchronizers.Writers.CRM.CrmHelper.GetConnection()))
            {
                return from fsp in crmContext.sfa_fundingstreamperiodSet
                    where fsp.sfa_fundingstreamperiodcode == fundingStreamPeriodCode
                       select fsp;
            }
        }
    }
}
