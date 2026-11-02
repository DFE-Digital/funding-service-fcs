namespace FCT.Console.Config.Tests.Crm
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using Synchronizers.Writers;
    using Synchronizers.Writers.CRM;
    
    [TestClass]
    public class CrmFspDeliverableWriterTests
    {
        private readonly string _testFundingStreamCode = "AGE";
        private readonly string _testFundingStreamPeriodCode = "AGE1516";
        private int _testDeliverableCode = 33;
        private string _testDeliverableName = "testDeliverableName";

        [TestInitialize, TestCleanup]
        public void CleanUp()
        {
            var fspDeliverables = GetFspDeliverables(_testFundingStreamPeriodCode, _testDeliverableCode);
            if (fspDeliverables.Any())
            {
                foreach (var fspDel in fspDeliverables)
                {
                    CrmHelper.GetConnection().Delete(CrmEntityName.FundingStreamPeriodDeliverable, fspDel.Id);
                }
            }

            var deliverables = GetDeliverables(_testFundingStreamCode, _testDeliverableCode);
            if (deliverables.Any())
            {
                foreach (var del in deliverables)
                {
                    CrmHelper.GetConnection().Delete(CrmEntityName.Deliverable, del.Id);
                }
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFspDeliverableWriter_ShouldInsertNewRowIntoCrmWhenRowDoesNotExist()
        {
            // arrange

            //create deliverables before creating fsp deliverables
            new CrmDeliverableWriter().WriteToCrmDatabase(GetDelRows(), WriterBehaviour.AddOrUpdate);

            IEnumerable<FundingStreamPeriodDeliverablesSheetType> rows = GetFspDelRows();
            Guid fundingStreamId = GetFundingStreamPeriod(_testFundingStreamPeriodCode).sfa_FundingStreamCodeId.Id;
            
            // act
            new CrmFspDeliverableWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            IEnumerable<sfa_fundingstreamperioddeliverable> fspDeliverables = GetFspDeliverables(_testFundingStreamPeriodCode, _testDeliverableCode);
            Assert.AreEqual(1, fspDeliverables.Count());
            Assert.AreEqual(true, fspDeliverables.First().sfa_setting_AllowCustomDeliverableDescription.Value, "The sfa_setting_AllowCustomDeliverableDescription has not been inserted");
            Assert.AreEqual(sfa_cappinggroup.OtherASB, (sfa_cappinggroup)fspDeliverables.First().sfa_PaymentCappingGroup.Value, "The sfa_PaymentCappingGroup has not been inserted");
            Assert.AreEqual(1, fspDeliverables.First().sfa_setting_displayorder.Value, "The sfa_setting_displayorder has not been inserted");
            Assert.AreEqual(fundingStreamId, fspDeliverables.First().sfa_FundingStreamId?.Id, "The sfa_FundingStreamId has not been inserted");
            Assert.AreEqual(true, fspDeliverables.First().sfa_setting_Mandatory.Value, "The sfa_setting_Mandatory has not been inserted");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFspDeliverableWriter_ShouldUpdateExistingRowInCrmWhenRowExists()
        {
            // arrange
            //create deliverables before creating fsp deliverables
            new CrmDeliverableWriter().WriteToCrmDatabase(GetDelRows(), WriterBehaviour.AddOrUpdate);

            var updatedValue = false;
            IEnumerable<FundingStreamPeriodDeliverablesSheetType> rows = GetFspDelRows();
            CrmFspDeliverableWriter crmFspDeliverableWriter = new CrmFspDeliverableWriter();
            crmFspDeliverableWriter.WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);

            const int updatedDisplayOrder = 2;
            IReadOnlyCollection<FundingStreamPeriodDeliverablesSheetType> updateRows = GetFspDelRows();
            updateRows.ToList()[0].AllowActuals = updatedValue;
            updateRows.ToList()[0].DeliverableCappingGroup = "Non Apprenticeships";
            updateRows.ToList()[0].AllowCustomDeliverableDesc = false;
            updateRows.ToList()[0].DisplayOrder = updatedDisplayOrder;
            updateRows.ToList()[0].Mandatory = "Optional";

            // act
            new CrmFspDeliverableWriter().WriteToCrmDatabase(updateRows, WriterBehaviour.AddOrUpdate);

            // assert
            IReadOnlyCollection<sfa_fundingstreamperioddeliverable> fspDeliverables = GetFspDeliverables(_testFundingStreamPeriodCode, _testDeliverableCode);
            Assert.AreEqual(1, fspDeliverables.Count, "We have inserted a row when we wanted to do an update");
            Assert.IsFalse(fspDeliverables.First().sfa_setting_AllowActuals.Value, "The Allow actuals setting has not been updated");
            Assert.AreEqual(false, fspDeliverables.First().sfa_setting_AllowCustomDeliverableDescription.Value, "The sfa_setting_AllowCustomDeliverableDescription has not been updated");
            Assert.AreEqual(sfa_cappinggroup.NonApprenticeships, (sfa_cappinggroup)fspDeliverables.First().sfa_PaymentCappingGroup.Value, "The sfa_PaymentCappingGroup has not been updated");
            Assert.AreEqual(updatedDisplayOrder, fspDeliverables.First().sfa_setting_displayorder.Value, "The sfa_setting_displayorder has not been updated");
            Assert.AreEqual(false, fspDeliverables.First().sfa_setting_Mandatory.Value, "The sfa_setting_Mandatory has not been updated");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFspDeliverableWriter_ShouldDeleteExistingRowInCrmWhenRowExistsAndPolicyStatusIsDeleted()
        {
            // arrange
            //create deliverables before creating fsp deliverables
            new CrmDeliverableWriter().WriteToCrmDatabase(GetDelRows(), WriterBehaviour.AddOrUpdate);

            IEnumerable<FundingStreamPeriodDeliverablesSheetType> rows = GetFspDelRows();
            new CrmFspDeliverableWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);

            IEnumerable<FundingStreamPeriodDeliverablesSheetType> updateRows = GetFspDelRows();
            updateRows.ToList()[0].PolicyStatus = PolicyStatus.Removed;

            // act
            new CrmFspDeliverableWriter().WriteToCrmDatabase(updateRows, WriterBehaviour.Delete);

            // assert
            IEnumerable<sfa_fundingstreamperioddeliverable> deliverables = GetFspDeliverables(_testFundingStreamPeriodCode, _testDeliverableCode);
            Assert.AreEqual(0, deliverables.Count(), "We have not deleted the row");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFspDeliverableWriter_ShouldNotErrorWhenAttemptingToDeleteRowWhenFspNoLongerPresentInCrm()
        {
            // arrange
            IEnumerable<FundingStreamPeriodDeliverablesSheetType> rows = GetFspDelRows();
            rows.ToList()[0].FundingStreamPeriodCode = "REMOVED-FSP";
            rows.ToList()[0].PolicyStatus = PolicyStatus.Removed;

            // act
            new CrmFspDeliverableWriter().WriteToCrmDatabase(rows, WriterBehaviour.Delete);
        }

        private sfa_fundingstreamperiod GetFundingStreamPeriod(string fundingStreamPeriodCode)
        {
            using (var crmContext = new XrmServiceContext(Synchronizers.Writers.CRM.CrmHelper.GetConnection()))
            {
                var fundingStreamPeriodQuery = from fsp in crmContext.sfa_fundingstreamperiodSet
                    where fsp.sfa_fundingstreamperiodcode == fundingStreamPeriodCode
                    select fsp;

                return fundingStreamPeriodQuery.Single();
            }
        }

        private IReadOnlyCollection<sfa_fundingstreamperioddeliverable> GetFspDeliverables(string fundingStreamPeriodCode, int deliverableCode)
        {
            using (var crmContext = new XrmServiceContext(CrmHelper.GetConnection()))
            {
                var fsp = GetFundingStreamPeriod(fundingStreamPeriodCode);
                var fspDeliverableQuery = from d in crmContext.sfa_fundingstreamperioddeliverableSet
                                         where d.sfa_FundingStreamPeriodId.Equals(fsp.ToEntityReference())
                                         && d.sfa_DeliverableCode == deliverableCode
                                         select d;

                return fspDeliverableQuery.ToList();
            }
        }

        private IReadOnlyCollection<sfa_deliverable> GetDeliverables(string fundingStreamCode, int deliverableCode)
        {
            using (var crmContext = new XrmServiceContext(CrmHelper.GetConnection()))
            {
                var fsp = GetFundingStream(fundingStreamCode);

                var deliverableQuery = from d in crmContext.sfa_deliverableSet
                                       where d.sfa_FundingStreamId.Equals(fsp.ToEntityReference())
                                       && d.sfa_DeliverableCode == deliverableCode
                                       select d;

                return deliverableQuery.ToList();
            }
        }

        private sfa_fundingstream GetFundingStream(string fundingStreamCode)
        {
            using (var crmContext = new XrmServiceContext(CrmHelper.GetConnection()))
            {
                var fundingStreamQuery = from fsp in crmContext.sfa_fundingstreamSet
                                         where fsp.sfa_fundingstreamcode == fundingStreamCode
                                         select fsp;

                return fundingStreamQuery.Single();
            }
        }

        private IReadOnlyCollection<FundingStreamPeriodDeliverablesSheetType> GetFspDelRows()
        {
            // arrange
            return new List<FundingStreamPeriodDeliverablesSheetType>
            {
                new FundingStreamPeriodDeliverablesSheetType
                {
                    PolicyStatus = PolicyStatus.Approved,
                    AllowActuals = true,
                    AllowPayment = true,
                    AllowProfile = false,
                    CreatedDate = DateTime.Now,
                    DeliverableCode = _testDeliverableCode,
                    DeliverableCappingGroup = "Other ASB",
                    DeliverableName = _testDeliverableName,
                    FundingStreamPeriodCode = _testFundingStreamPeriodCode,
                    IsPayable = true,
                    PlanningUnit = "Value", 
                    ParentDeliverableCode = 1,
                    DeliverableRelationshipType = "Aggregate",
                    PaymentSubnominalCodeCapping = "11111",
                    PaymentSubnominalCodeProfile = "22222",
                    PaymentSubnominalCodeReconciliation = "33333",
                    AllowCustomDeliverableDesc = true,
                    DisplayOrder = 1,
                    Mandatory = "Mandatory"
                }
            };
        }

        private IReadOnlyCollection<DeliverablesSheetType> GetDelRows()
        {
            // arrange
            return new List<DeliverablesSheetType>
            {
                new DeliverablesSheetType
                {
                    PolicyStatus = PolicyStatus.Approved,
                    DeliverableCode = _testDeliverableCode,
                    FundingStreamCode = _testFundingStreamCode,
                    DeliverableName = _testDeliverableName,
                    BusinessCode = string.Empty,
                    Status = "Active",
                    EffectiveDate = DateTime.Now
                }
            };
        }
    }
}
