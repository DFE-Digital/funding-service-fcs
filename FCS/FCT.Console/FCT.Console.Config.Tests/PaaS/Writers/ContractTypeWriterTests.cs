namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System.Collections.Generic;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;

    [TestClass]
    public class ContractTypeWriterTests
    {
        private const string TestContractType = "TestContractType";

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractTypeWriter_ShouldInsertNewRowToPaas()
        {
            // Arrange
            CleanUp();
            IList<ContractTypeSheetType> contractTypeSheet = new List<ContractTypeSheetType>()
            {
                CreateSheet(PolicyStatus.Approved)
            };

            // Act
            ContractTypeWriter.WriteToPaaSDatabase(contractTypeSheet, WriterBehaviour.AddOrUpdate);

            // Assert
            using (var context = new ContractManagementDbContext())
            {
                var foundContractType = context.ContractTypes.Find(TestContractType);
                Assert.IsNotNull(foundContractType);
            }
            CleanUp();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractTypeWriter_ShouldUpdateRowWhenKeyAlreadyExists()
        {
            // Arrange
            CleanUp();
            CreateContractType();
            IList<ContractTypeSheetType> contractTypeSheet = new List<ContractTypeSheetType>()
            {
                CreateSheet(PolicyStatus.Approved)
            };

            // Act
            ContractTypeWriter.WriteToPaaSDatabase(contractTypeSheet, WriterBehaviour.AddOrUpdate);

            // Assert
            using (var context = new ContractManagementDbContext())
            {
                var foundContractType = context.ContractTypes.Find(TestContractType);
                Assert.IsNotNull(foundContractType);
                Assert.AreEqual(TestContractType, foundContractType.ContractTypeName);
            }
            CleanUp();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractTypeWriter_ShouldDeleteForGivenKey()
        {
            // Arrange
            CleanUp();
            CreateContractType();

            // Act
            IList<ContractTypeSheetType> contractTypeSheet = new List<ContractTypeSheetType>()
            {
                CreateSheet(PolicyStatus.Removed)
            };
            ContractTypeWriter.WriteToPaaSDatabase(contractTypeSheet, WriterBehaviour.Delete);

            // Assert
            using (var context = new ContractManagementDbContext())
            {
                var foundContractType = context.ContractTypes.Find(TestContractType);
                Assert.IsNull(foundContractType);
            }
        }

        private void CleanUp()
        {
            using (var context = new ContractManagementDbContext())
            {
                ContractType foundContractType = context.ContractTypes.Find(TestContractType);
                if (foundContractType != null)
                {
                    context.ContractTypes.Remove(foundContractType);
                    context.SaveChanges();
                }
            }
        }

        private ContractTypeSheetType CreateSheet(PolicyStatus policyStatus)
        {
            ContractTypeSheetType contractTypeSheetType = new ContractTypeSheetType()
            {
                ContractType = TestContractType,
                PolicyStatus = policyStatus
            };
            return contractTypeSheetType;
        }

        private void CreateContractType()
        {
            using (var context = new ContractManagementDbContext())
            {
                context.ContractTypes.Add(new ContractType(TestContractType));
                context.SaveChanges();
            }
        }
    }
}
