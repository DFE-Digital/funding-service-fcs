namespace FCT.Console.Config.Tests.Crm
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using Synchronizers.Writers;
    using Synchronizers.Writers.CRM;
    using sfa_fundingtype = SFA.FCT.CrossDomain.Integration.Entities.Xrm.sfa_fundingtype;

    [TestClass]
    public class CrmFundingTypeFundingPeriodWriterTests
    {
        private const string ManualApprovalType = "Manual";
        private const string ElectronicApprovalType = "Electronic";
        private const string TestFundingTypeName = "Test_FT";
        private const string TestFundingTypeCode = "Test_FTCode";
        private const string TestFundingPeriodName = "AY1516";
        private const string TestTemplateName = "Test_TN";

        [TestInitialize, TestCleanup]
        public void CleanUp()
        {
            // delete test parent
            foreach (var entity in GetMatchingFundingTypeFundingPeriods(TestFundingPeriodName, TestFundingTypeCode))
            {
                CrmHelper.GetConnection().Delete(sfa_fundingtypefundingperiod.EntityLogicalName, entity.Id);
            }
            
            // delete child entities
            foreach (var entity in GetMatchingFundingTypes(TestFundingTypeCode))
            {
                CrmHelper.GetConnection().Delete(sfa_fundingtype.EntityLogicalName, entity.Id);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFundingTypeFundingPeriodWriter_ShouldInsertNewRowIntoCrmWhenRowDoesNotExist()
        {
            // arrange
            CreateFundingTypeEntity();
            
            IEnumerable<FundingTypePeriodSheetType> rows = GetRows();

            // act
            new CrmFundingTypeFundingPeriodWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            IEnumerable<Entity> fundingTypePeriod = GetMatchingFundingTypeFundingPeriods(TestFundingPeriodName, TestFundingTypeCode);
            Assert.AreEqual(1, fundingTypePeriod.Count());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFundingTypeFundingPeriodWriter_ShouldUpdateExistingRowInCrmWhenRowExist()
        {
            // arrange
            CreateFundingTypeFundingPeriodEntity();

            IEnumerable<FundingTypePeriodSheetType> rows = GetRows();
            rows.First().ApprovalType = ElectronicApprovalType;

            // act
            new CrmFundingTypeFundingPeriodWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            IEnumerable<sfa_fundingtypefundingperiod> fundingtypefundingperiods = GetMatchingFundingTypeFundingPeriods(TestFundingPeriodName, TestFundingTypeCode);
            Assert.AreEqual(1, fundingtypefundingperiods.Count());

            var fundingtypefundingperiod = fundingtypefundingperiods.Single();

            Assert.AreEqual(sfa_approvaltype.Electronic, fundingtypefundingperiod.sfa_ApprovalTypeEnum, "The sfa_ApprovalTypeEnum has not been set");
            Assert.AreEqual(true, fundingtypefundingperiod.sfa_skipdocumentmerge, "The sfa_skipdocumentmerge has not been set");
            Assert.AreEqual(true, fundingtypefundingperiod.sfa_generatecontractdocumentation, "The sfa_generatecontractdocumentation has not been set");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFundingTypeFundingPeriodWriter_ShouldDeleteExistingRowInCrmWhenRowExistsAndpolicyStatusIsDeleted()
        {
            // arrange
            CreateFundingTypeFundingPeriodEntity();

            IEnumerable<FundingTypePeriodSheetType> rows = GetRows();
            rows.First().PolicyStatus = PolicyStatus.Removed;

            // act
            new CrmFundingTypeFundingPeriodWriter().WriteToCrmDatabase(rows, WriterBehaviour.Delete);

            // assert
            IEnumerable<Entity> fundingType = GetMatchingFundingTypeFundingPeriods(TestFundingPeriodName, TestFundingTypeCode);
            Assert.AreEqual(0, fundingType.Count());
        }
        
        private void CreateFundingTypeFundingPeriodEntity()
        {
            var fundingtypefundingperiod = new sfa_fundingtypefundingperiod
            {
                sfa_name = TestFundingTypeName + TestFundingPeriodName,
                sfa_FundingPeriodId = GetFundingPeriodEntity().ToEntityReference(),
                sfa_FundingTypeId = CreateFundingTypeEntity(),
                sfa_ApprovalTypeEnum = (sfa_approvaltype) Enum.Parse(typeof(sfa_approvaltype), "Manual")
            };

            CrmHelper.GetConnection().Create(fundingtypefundingperiod);
        }

        private IReadOnlyCollection<FundingTypePeriodSheetType> GetRows()
        {
            return new List<FundingTypePeriodSheetType>
            {
                new FundingTypePeriodSheetType
                {
                    FundingTypeName = TestFundingTypeName,
                    FundingTypeCode = TestFundingTypeCode,
                    FundingPeriod = TestFundingPeriodName,
                    ApprovalType = ManualApprovalType,
                    PolicyStatus = PolicyStatus.Approved,
                    TemplateName = TestTemplateName,
                    SkipDocumentMerge = true,
                    DocumentsRequired = true
                }
            };
        }

        private sfa_period GetFundingPeriodEntity()
        {
            using (var crmContext = new XrmServiceContext(Synchronizers.Writers.CRM.CrmHelper.GetConnection()))
            {
                return (from p in crmContext.sfa_periodSet
                    where p.sfa_periodname == TestFundingPeriodName
                    select p).Single();
            }
        }

        private IQueryable<sfa_fundingtypefundingperiod> GetMatchingFundingTypeFundingPeriods(string fundingPeriodName, string fundingTypeCode)
        {
            using (var crmContext = new XrmServiceContext(Synchronizers.Writers.CRM.CrmHelper.GetConnection()))
            {
                return from ftfp in crmContext.sfa_fundingtypefundingperiodSet
                join ft in crmContext.sfa_fundingtypeSet on ftfp.sfa_FundingTypeId.Id equals ft.sfa_fundingtypeId
                join fp in crmContext.sfa_periodSet on ftfp.sfa_FundingPeriodId.Id equals fp.sfa_periodId
                where ft.sfa_fundingtypecode == fundingTypeCode
                && fp.sfa_periodname == fundingPeriodName
                select ftfp;
            }
        }

        private EntityReference CreateFundingTypeEntity()
        {
            var agencyEntityRef = GetAgencyEntityReference(1);
            
            var fundingtype = new sfa_fundingtype
            {
                sfa_name = TestFundingTypeName,
                sfa_fundingtypecode = TestFundingTypeCode,
                sfa_AgencyId = agencyEntityRef,
                sfa_ContractReferencePrefix = "Test"
            };

            return new EntityReference(sfa_fundingtype.EntityLogicalName, CrmHelper.GetConnection().Create(fundingtype));
        }

        private EntityReference GetAgencyEntityReference(int agencyCode)
        {
            using (var crmContext = new XrmServiceContext(CrmHelper.GetConnection()))
            {
                var entityQuery = from fp in crmContext.sfa_agencySet
                                  where fp.sfa_agencycode == agencyCode.ToString()
                                  select fp;
                return entityQuery.Single().ToEntityReference();
            }
        }

        private IQueryable<sfa_fundingtype> GetMatchingFundingTypes(string fundingTypeCode)
        {
            using (var crmContext = new XrmServiceContext(Synchronizers.Writers.CRM.CrmHelper.GetConnection()))
            {
                return from ft in crmContext.sfa_fundingtypeSet 
                       where ft.sfa_fundingtypecode == fundingTypeCode
                       select ft;
            }
        }
    }
}
