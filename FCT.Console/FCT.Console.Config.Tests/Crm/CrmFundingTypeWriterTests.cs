namespace FCT.Console.Config.Tests.Crm
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Writers.CRM;
    using SFA.FCT.CrossDomain.Integration.Common.Crm;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Query;
    using Synchronizers.Writers;

    [TestClass]
    public class CrmFundingTypeWriterTests
    {
        private const string TestFundingTypeName = "AGE95-98";
        private const string TestFundingTypeCode = "AGE9598";
        private const string TestContractRefPrefix = "AGE";
        private const string FundingType = "sfa_fundingtype";
        private const string Name = "sfa_name";
        private const string DocumentationNotRequired = "sfa_documentationnotrequired";

        [TestInitialize, TestCleanup]
        public void CleanUp()
        {
            var fundingTypes = GetFundingType(TestFundingTypeName);
            if (fundingTypes.Any())
            {
                foreach (var fundingType in fundingTypes)
                {
                    CrmHelper.GetConnection().Delete(FundingType, fundingType.Id);
                }
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFundingTypeWriter_ShouldInsertNewRowIntoCrmWhenRowDoesNotExist()
        {
            // arrange
            IEnumerable<FundingTypeSheetType> rows = GetRows();

            // act
            new CrmFundingTypeWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            IEnumerable<Entity> fundingType = GetFundingType(rows.First().FundingTypeName);
            Assert.AreEqual(1, fundingType.Count());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFundingTypeWriter_ShouldUpdateExistingRowInCrmWhenRowExist()
        {
            // arrange
            IEnumerable<FundingTypeSheetType> rows = GetRows();
            new CrmFundingTypeWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);
            rows.First().DocumentationRequired = true;

            // act
            new CrmFundingTypeWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            IEnumerable<Entity> fundingType = GetFundingType(rows.First().FundingTypeName);
            Assert.AreEqual(1, fundingType.Count());
            Entity ftEntity = fundingType.Single();
            bool isDocumentationNotRequired = ftEntity.GetAttributeValue<bool>(DocumentationNotRequired);
            Assert.AreEqual(false, isDocumentationNotRequired);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFundingTypeWriter_ShouldDeleteExistingRowInCrmWhenRowExistsAndpolicyStatusIsDeleted()
        {
            // arrange
            IEnumerable<FundingTypeSheetType> rows = GetRows();
            new CrmFundingTypeWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);
            rows.First().PolicyStatus = PolicyStatus.Removed;

            // act
            new CrmFundingTypeWriter().WriteToCrmDatabase(rows, WriterBehaviour.Delete);

            // assert
            IEnumerable<Entity> fundingType = GetFundingType(rows.First().FundingTypeName);
            Assert.AreEqual(0, fundingType.Count());
        }

        private IReadOnlyCollection<FundingTypeSheetType> GetRows()
        {
            // arrange
            return new List<FundingTypeSheetType>
                    {
                        new FundingTypeSheetType
                        {
                            FundingTypeName = TestFundingTypeName,
                            FundingTypeCode = TestFundingTypeCode,
                            AgencyCode = 1,
                            AllowMultipleContracts = true,
                            ContractReferencePrefix = TestContractRefPrefix,
                            DocumentationRequired = false
                        }
                    };
        }

        private IReadOnlyCollection<Entity> GetFundingType(string fundingTypeName)
        {
            var columnValues = new List<ColumnValueCriteria>
                    {
                        new ColumnValueCriteria(Name, ConditionOperator.Equal, fundingTypeName)
                    };

            CrmLookupCriteria lookupCriteria = new CrmLookupCriteria { EntityName = FundingType, LookupCriteria = columnValues };
            return CrmManager.GetCrmEntities(lookupCriteria, CrmHelper.GetConnection()).ToList();
        }
    }
}