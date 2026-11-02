namespace FCT.Console.Config.Tests.Crm
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Query;
    using SFA.FCT.CrossDomain.Integration.Common.Crm;
    using Synchronizers.Writers;
    using Synchronizers.Writers.CRM;

    [TestClass]
    public class CrmContractTypeWriterTests
    {
        private const string TestContractTypeName = "TestContractType";
        private const string Name = "sfa_name";
        private const string ContractTypeCrmTableName = "sfa_contracttype";

        [TestInitialize, TestCleanup]
        public void CleanUp()
        {
            var contractTypes = GetContractType(TestContractTypeName);
            if (contractTypes.Any())
            {
                foreach (var contractType in contractTypes)
                {
                    CrmHelper.GetConnection().Delete(ContractTypeCrmTableName, contractType.Id);
                }
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractTypeWriter_ShouldInsertNewRowIntoCrmWhenRowDoesNotExist()
        {
            // arrange
            IReadOnlyCollection<ContractTypeSheetType> rows = GetRows(TestContractTypeName);

            // act
            new CrmContractTypeWriter().WriteToCrmDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            IEnumerable<Entity> contractType = GetContractType(rows.First().ContractType);
            Assert.AreEqual(1, contractType.Count());
        }

        private IReadOnlyCollection<ContractTypeSheetType> GetRows(string testContractTypeName)
        {
            IReadOnlyCollection<ContractTypeSheetType> contractTypeSheetTypes = new List<ContractTypeSheetType>
            {
                new ContractTypeSheetType()
                {
                    ContractType = testContractTypeName,
                    PolicyStatus = PolicyStatus.Approved
                }
            };

            return contractTypeSheetTypes;
        }

        private IReadOnlyCollection<Entity> GetContractType(string testContractTypeName)
        {
            var columnValues = new List<ColumnValueCriteria>
                    {
                        new ColumnValueCriteria(Name, ConditionOperator.Equal, testContractTypeName)
                    };

            CrmLookupCriteria lookupCriteria = new CrmLookupCriteria { EntityName = ContractTypeCrmTableName, LookupCriteria = columnValues };
            return CrmManager.GetCrmEntities(lookupCriteria, CrmHelper.GetConnection()).ToList();
        }
    }
}