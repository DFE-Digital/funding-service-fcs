namespace FCT.Console.Config.Tests.Crm
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using Synchronizers.Writers;
    using Synchronizers.Writers.CRM;
    using System;
    using Microsoft.Xrm.Sdk;
    using System.Globalization;

    [TestClass]
    public class CrmPaymentTimeTableWriterTests
    {
        const string TestFspCode = "TestFSPCode";
        const string TestFSCode = "AGE";
        
        [TestInitialize, TestCleanup]
        public void CleanUp()
        {
            var crmFSP = GetFundingStreamPeriodFromCrm(_testFSP.First().FundingStreamPeriodCode);

            if (!crmFSP.Any()) return;

            PaymentTimetablesSheetType sheetRecord = _testpaymentTimeTableEntry.First();

            var crmPaymentTimeTable = GetPaymentTimeTableFromCRM(sheetRecord.FundingStreamPeriodCode, sheetRecord.CalendarPeriod, sheetRecord.CalendarPeriodType);
            if (crmPaymentTimeTable.Any())
            {
                foreach (var crmPaymentTimeTableRecord in crmPaymentTimeTable)
                {
                    CrmHelper.GetConnection().Delete("sfa_paymenttimetable", crmPaymentTimeTableRecord.Id);
                }
            }
            
            foreach (var crmFSPRecord in crmFSP)
            {
                CrmHelper.GetConnection().Delete("sfa_fundingstreamperiod", crmFSPRecord.Id);
            }
            
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmPaymentTimeTableWriter_ShouldInsertNewRowIntoCrmWhenRowDoesNotExist()
        {
            PaymentTimetablesSheetType sheetRecord = _testpaymentTimeTableEntry.First();

            CreateFundingStreamPeriodEntity();

            // act
            new CrmPaymentTimeTableWriter().WriteToCrmDatabase(_testpaymentTimeTableEntry, WriterBehaviour.AddOrUpdate);

            // assert
            IEnumerable<sfa_paymenttimetable> paymentTTRecord = GetPaymentTimeTableFromCRM(sheetRecord.FundingStreamPeriodCode,sheetRecord.CalendarPeriod, sheetRecord.CalendarPeriodType);
            Assert.AreEqual(1, paymentTTRecord.Count());
        }



        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmPaymentTimeTableWriter_ShouldUpdateExistingRowInCrmWhenRowExists()
        {
            PaymentTimetablesSheetType sheetRecord = _testpaymentTimeTableEntry.First();

            CreateFundingStreamPeriodEntity();

            // arrange
            DateTime updateDueDate = DateTime.ParseExact("15/01/2017", "dd/MM/yyyy", CultureInfo.InvariantCulture);
            new CrmPaymentTimeTableWriter().WriteToCrmDatabase(_testpaymentTimeTableEntry, WriterBehaviour.AddOrUpdate);

            _testpaymentTimeTableEntry.First().DueDate = updateDueDate;

            // act
            new CrmPaymentTimeTableWriter().WriteToCrmDatabase(_testpaymentTimeTableEntry, WriterBehaviour.AddOrUpdate);

            // assert
            IReadOnlyCollection<sfa_paymenttimetable> paymentTTRecord = GetPaymentTimeTableFromCRM(sheetRecord.FundingStreamPeriodCode, sheetRecord.CalendarPeriod, sheetRecord.CalendarPeriodType);
            Assert.AreEqual(1, paymentTTRecord.Count, "We have inserted a row when we wanted to do an insert");
            Assert.AreEqual(updateDueDate, paymentTTRecord.First().sfa_paymentduedate, "The payment due date has not been updated");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmPaymentTimeTableWriter_ShouldDeleteExistingRowInCrmWhenRowExistsAndPolicyStatusIsDeleted()
        {
            PaymentTimetablesSheetType sheetRecord = _testpaymentTimeTableEntry.First();

            CreateFundingStreamPeriodEntity();

            // arrange
            new CrmPaymentTimeTableWriter().WriteToCrmDatabase(_testpaymentTimeTableEntry, WriterBehaviour.AddOrUpdate);

            _testpaymentTimeTableEntry.First().PolicyStatus = PolicyStatus.Removed;

            // act
            new CrmPaymentTimeTableWriter().WriteToCrmDatabase(_testpaymentTimeTableEntry, WriterBehaviour.Delete);

            // assert
            IEnumerable<sfa_paymenttimetable> paymentTTRecord = GetPaymentTimeTableFromCRM(sheetRecord.FundingStreamPeriodCode, sheetRecord.CalendarPeriod, sheetRecord.CalendarPeriodType);
            Assert.AreEqual(0, paymentTTRecord.Count(), "We have not deleted the row");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmPaymentTimeTableWriter_ShouldNotErrorWhenAttemptingToDeleteRowWhenFundingStreamPeriodNoLongerPresentInCrm()
        {
            // arrange
            _testpaymentTimeTableEntry.First().PolicyStatus = PolicyStatus.Removed;

            // act
            new CrmPaymentTimeTableWriter().WriteToCrmDatabase(_testpaymentTimeTableEntry, WriterBehaviour.Delete);
        }

        private IReadOnlyCollection<sfa_paymenttimetable> GetPaymentTimeTableFromCRM(string fspCode,string calendarPeriod, string calendarType)
        {
            using (var crmContext = new XrmServiceContext(Synchronizers.Writers.CRM.CrmHelper.GetConnection()))
            {
                return (from ct in crmContext.sfa_paymenttimetableSet
                        where ct.sfa_fundingstreamperiod.Id == GetFundingStreamPeriodFromCrm(fspCode).Single().ToEntityReference().Id
                        && ct.sfa_calendarperiod == Convert.ToInt32(calendarPeriod)
                        && ct.sfa_calendarperiodtype == calendarType
                        select ct).ToList();
            }
        }
        private IReadOnlyCollection<sfa_fundingstreamperiod> GetFundingStreamPeriodFromCrm(string fundingStreamPeriodCode)
        {
            using (var crmContext = new XrmServiceContext(CrmHelper.GetConnection()))
            {
                return (from fsp in crmContext.sfa_fundingstreamperiodSet
                        where fsp.sfa_fundingstreamperiodcode == fundingStreamPeriodCode
                        select fsp).ToList();
            }

        }
        private EntityReference GetFundingStreamFromCRM(string fundingstreamCode)
        {
            using (var crmContext = new XrmServiceContext(CrmHelper.GetConnection()))
            {
                return (from fs in crmContext.sfa_fundingstreamSet
                        where fs.sfa_fundingstreamcode == fundingstreamCode
                        select fs).Single().ToEntityReference();
            }

        }

        private void CreateFundingStreamPeriodEntity()
        {
            sfa_fundingstreamperiod fsp = new sfa_fundingstreamperiod
            {
                sfa_fundingstreamperiodcode = TestFspCode,
                sfa_FundingStreamCodeId = GetFundingStreamFromCRM(TestFSCode),
            };

            CrmHelper.GetConnection().Create(fsp);
        }

        private IEnumerable<PaymentTimetablesSheetType> _testpaymentTimeTableEntry = new List<PaymentTimetablesSheetType>()
        {
            new PaymentTimetablesSheetType()
            {
               FundingStreamPeriodCode = TestFspCode,
               CalendarPeriod = "201701",
               CalendarPeriodType = "CM",
               CensusEndDate = DateTime.ParseExact("09/01/2017 22:00:00","dd/MM/yyyy HH:mm:ss",CultureInfo.InvariantCulture),
               DueDate = DateTime.ParseExact("13/01/2017", "dd/MM/yyyy",CultureInfo.InvariantCulture),
               FinancialPeriod = "201705",
               FinancialPeriodType ="FP",
               LinkCodeSuffix = "A",
               PeriodStartDate = DateTime.ParseExact("01/01/2017", "dd/MM/yyyy",CultureInfo.InvariantCulture),
               PeriodEndDate = DateTime.ParseExact("31/01/2017", "dd/MM/yyyy",CultureInfo.InvariantCulture),
                PolicyStatus = PolicyStatus.Approved
            }
        };

        private IEnumerable<FundingStreamPeriodSheetType> _testFSP = new List<FundingStreamPeriodSheetType>()
        {
            new FundingStreamPeriodSheetType()
            {
               FundingStreamPeriodCode = TestFspCode,
               PolicyStatus = PolicyStatus.Approved
            }
        };
        
    }
}
