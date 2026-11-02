namespace FCT.Console.Config.Tests.Crm
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using Synchronizers.Writers.CRM;
    using SFA.FCT.CrossDomain.Integration.Common.Crm;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Query;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using Synchronizers.Writers;

    [TestClass]
    public class CrmFundingStreamPeriodCappingGroupsWriterTests
    { 
        private const string TestFundingStreamPeriodCode = "AGE1516";
        private const string TestDeliverableCappingGroup = "Apprenticeships";
        private const string CappinggroupsEntityName = "sfa_cappinggroups";
        private const string AllowoverdeliverytobeoffsetColumnName = "sfa_allowoverdeliverytobeoffset";

        [TestInitialize, TestCleanup]
        public void CleanUp()
        {
            var cappingGroups = GetFundingStreamPeriodCappingGroup(TestFundingStreamPeriodCode, TestDeliverableCappingGroup);
            if (cappingGroups.Any())
            {
                foreach (var cappingGroup in cappingGroups)
                {
                    CrmHelper.GetConnection().Delete(CappinggroupsEntityName, cappingGroup.Id);
                }
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFundingStreamPeriodCappingGroupsWriter_ShouldInsertNewRowIntoCrmWhenRowDoesNotExist()
        {
            // arrange
            IEnumerable<FundingStreamPeriodCappingGroupSheetType> rows = GetRows();

            // act
            new CrmFundingStreamPeriodCappingGroupWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            IEnumerable<Entity> fundingStreamPeriodCappingGroup = GetFundingStreamPeriodCappingGroup(rows.First().FundingStreamPeriod, rows.First().CappingGroupName);
            Assert.AreEqual(1, fundingStreamPeriodCappingGroup.Count());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFundingStreamPeriodCappingGroupsWriter_ShouldUpdateExistingRowInCrmWhenRowExist()
        {
            // arrange
            IEnumerable<FundingStreamPeriodCappingGroupSheetType> rows = GetRows();
            new CrmFundingStreamPeriodCappingGroupWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);
            rows.First().AllowOverDeliveryToBeOffset = true;

            // act
            new CrmFundingStreamPeriodCappingGroupWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            IEnumerable<Entity> fundingStreamPeriodCappingGroup = GetFundingStreamPeriodCappingGroup(rows.First().FundingStreamPeriod, rows.First().CappingGroupName);
            Assert.AreEqual(1, fundingStreamPeriodCappingGroup.Count());
            Entity fspcgEntity = fundingStreamPeriodCappingGroup.Single();
            bool val = fspcgEntity.GetAttributeValue<bool>(AllowoverdeliverytobeoffsetColumnName);
            Assert.AreEqual(val, true);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFundingStreamPeriodCappingGroupsWriter_ShouldDeleteExistingRowInCrmWhenRowExistsAndPolicyStatusIsDeleted()
        {
            // arrange
            IEnumerable<FundingStreamPeriodCappingGroupSheetType> rows = GetRows();
            new CrmFundingStreamPeriodCappingGroupWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);
            rows.First().PolicyStatus = PolicyStatus.Removed;

            // act
            new CrmFundingStreamPeriodCappingGroupWriter().WriteToCrmDatabase(rows, WriterBehaviour.Delete);

            // assert
            IEnumerable<Entity> fundingStreamPeriodCappingGroup = GetFundingStreamPeriodCappingGroup(rows.First().FundingStreamPeriod, rows.First().CappingGroupName);
            Assert.AreEqual(0, fundingStreamPeriodCappingGroup.Count());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFundingStreamPeriodCappingGroupsWriter_ShouldNotExceptionWhenRowDoesNotExistAndPolicyStatusIsDeleted()
        {
            // arrange
            IEnumerable<FundingStreamPeriodCappingGroupSheetType> rows = GetRows();
            rows.First().PolicyStatus = PolicyStatus.Removed;

            // act
            new CrmFundingStreamPeriodCappingGroupWriter().WriteToCrmDatabase(rows, WriterBehaviour.Delete);
        }

        private IReadOnlyCollection<Entity> GetFundingStreamPeriodCappingGroup(string fundingStreamPeriodCode, string deliverableCappingGroup)
        {
            var columnValues = new List<ColumnValueCriteria>()
            {
                new ColumnValueCriteria("sfa_fundingstreamperiod", ConditionOperator.Equal, GetFundingStreamPeriodEntityReference(fundingStreamPeriodCode).Id),
                new ColumnValueCriteria("sfa_deliverablecappinggroup", ConditionOperator.Equal, CrmOptionSetFactory.CreateCappingGroupFromString(deliverableCappingGroup).Value)
            };

            CrmLookupCriteria lookupCriteria = new CrmLookupCriteria() { EntityName = CappinggroupsEntityName, LookupCriteria = columnValues };
            return CrmManager.GetCrmEntities(lookupCriteria, CrmHelper.GetConnection()).ToList();
        }

        private IReadOnlyCollection<FundingStreamPeriodCappingGroupSheetType> GetRows()
        {
            // arrange
            return new List<FundingStreamPeriodCappingGroupSheetType>
            {
                new FundingStreamPeriodCappingGroupSheetType
                {
                    FundingStreamPeriod = TestFundingStreamPeriodCode,
                    CappingGroupName = TestDeliverableCappingGroup,
                    AllowUnderDeliveryToBeReUsed = true,
                    AllowOverDeliveryToBeOffset = false,
                    PolicyStatus = PolicyStatus.Approved
                }
            };
        }

        private EntityReference GetFundingStreamPeriodEntityReference(string fundingStreamPeriodCode)
        {
            using (var crmContext = new XrmServiceContext(Synchronizers.Writers.CRM.CrmHelper.GetConnection()))
            {
                var entityQuery = from fp in crmContext.sfa_fundingstreamperiodSet
                                  where fp.sfa_fundingstreamperiodcode == fundingStreamPeriodCode
                                  select fp;
                return entityQuery.Single().ToEntityReference();
            }
        }
    }
}