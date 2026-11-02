namespace ContractCreateDomain.Endpoint.Tests.Services.Repositories
{
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using Endpoint.Services.Repositories;
    using Infrastructure.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class CreatedContractRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void CreatedContractRepository_ShouldAddToStorage()
        {
            const string contractNumber = "TEST-1234";
            const int contractVersionNumber = 2;
            const int contractSubVersionNumber = 1;

            // arrange
            using (var context = new ContractManagementDbContext())
            {
                context.CreatedContracts.RemoveWhere(c => c.ContractNumber == contractNumber);
                context.SaveChanges();
            }

            var repository = new CreatedContractRepository();
            var entity = new CreatedContract(contractNumber, contractVersionNumber, contractSubVersionNumber, null);
            var connectionInfo = new ConnectionInfo(null, new SqlConnection(ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString));
            
            // act
            repository.Add(entity, connectionInfo).Wait();

            // assert
            using (var context = new ContractManagementDbContext())
            {
                CreatedContract storedEntity = context.CreatedContracts.SingleOrDefault(c =>
                    c.ContractNumber == contractNumber && c.ContractVersionNumber == contractVersionNumber && c.ContractSubVersionNumber == contractSubVersionNumber);

                Assert.IsNotNull(storedEntity, "Contract not added to storage");
            }
        }
    }
}
