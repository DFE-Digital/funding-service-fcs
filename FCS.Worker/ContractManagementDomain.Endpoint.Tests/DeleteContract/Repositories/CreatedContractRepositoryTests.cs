namespace ContractManagementDomain.Endpoint.Tests.DeleteContract.Repositories
{
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using Endpoint.DeleteContract.Repositories;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using UnitTests.Common;

    [TestClass]
    public class CreatedContractRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void CreatedContractRepository_ShouldRemoveAllSubVersionsForContractVersion()
        {
            const string contractNumber = "TEST-1234";

            // arrange
            using (var context = new ContractManagementDbContext())
            {
                context.CreatedContracts.RemoveWhere(c => c.ContractNumber == contractNumber);
                context.CreatedContracts.Add(new CreatedContract(contractNumber, 1, 0, null));
                context.CreatedContracts.Add(new CreatedContract(contractNumber, 2, 0, null));
                context.CreatedContracts.Add(new CreatedContract(contractNumber, 2, 1, null));
                context.CreatedContracts.Add(new CreatedContract(contractNumber, 2, 2, null));
                context.SaveChanges();
            }

            var repository = new CreatedContractRepository();
            var connectionInfo = new ConnectionInfo(null, new SqlConnection(ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString));

            // act
            repository.RemoveAllForContractVersion(contractNumber, 2, connectionInfo).Wait();

            // assert
            using (var context = new ContractManagementDbContext())
            {
                CreatedContract[] storedEntitiesForContract = context.CreatedContracts.Where(c => c.ContractNumber == contractNumber).ToArray();
                Assert.AreEqual(1, storedEntitiesForContract.Length, "Unexpected number of entities remain in storage");
                Assert.AreEqual(1, storedEntitiesForContract.Single().ContractVersionNumber, "Incorrect entity remaining in storage");
            }
        }
        
        [TestMethod, TestCategory("IntegrationTest")]
        public void CreatedContractRepository_ShouldNotRemoveUnrelatedContractWithSameVersionNumber()
        {
            const string contractNumber = "TEST-1234";
            const string unrelatedContractNumber = "TEST-5678";

            // arrange
            using (var context = new ContractManagementDbContext())
            {
                context.CreatedContracts.RemoveWhere(c => c.ContractNumber == contractNumber);
                context.CreatedContracts.RemoveWhere(c => c.ContractNumber == unrelatedContractNumber);
                context.CreatedContracts.Add(new CreatedContract(contractNumber, 1, 0, null));
                context.CreatedContracts.Add(new CreatedContract(unrelatedContractNumber, 1, 0, null));
                context.SaveChanges();
            }

            var repository = new CreatedContractRepository();
            var connectionInfo = new ConnectionInfo(null, new SqlConnection(ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString));

            // act
            repository.RemoveAllForContractVersion(contractNumber, 1, connectionInfo).Wait();

            // assert
            using (var context = new ContractManagementDbContext())
            {
                CreatedContract unrelatedContract = context.CreatedContracts.SingleOrDefault(c => c.ContractNumber == unrelatedContractNumber);
                Assert.IsNotNull(unrelatedContract, "Unrelated entity was deleted in error");
            }
        }


        [TestMethod, TestCategory("IntegrationTest")]
        public void CreatedContractRepository_GetAllContractsForVersion_ShouldRetrieveTheContractsVersions()
        {
            // Arrange
            var expectedContractNumber = "expectedContractNumber";
            var expectedContractVersionNumber = 33;
            var expectedContractSubversionNumber1 = 55;
            var expectedContractSubversionNumber2 = 77;

            using (var context = new ContractManagementDbContext())
            {
                context.CreatedContracts.RemoveWhere(c => c.ContractNumber == expectedContractNumber);
                context.CreatedContracts.Add(new CreatedContract(expectedContractNumber, expectedContractVersionNumber, expectedContractSubversionNumber1, null));
                context.CreatedContracts.Add(new CreatedContract(expectedContractNumber, expectedContractVersionNumber, expectedContractSubversionNumber2, null));
                context.SaveChanges();
            }

            var target = new CreatedContractRepository();
            var connectionInfo = new ConnectionInfo(null, new SqlConnection(ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString));

            // Act
            var actualContractIdentifiers = target.GetAllContractsForVersion(expectedContractNumber, expectedContractVersionNumber, connectionInfo).Result.ToList();

            // Assert
            actualContractIdentifiers.Should().Contain(info =>
                info.ContractNumber == expectedContractNumber &&
                info.VersionNumber == expectedContractVersionNumber &&
                info.SubVersionNumber == expectedContractSubversionNumber2);

            actualContractIdentifiers.Should().Contain(info =>
                info.ContractNumber == expectedContractNumber &&
                info.VersionNumber == expectedContractVersionNumber &&
                info.SubVersionNumber == expectedContractSubversionNumber1);
        }
    }
}
