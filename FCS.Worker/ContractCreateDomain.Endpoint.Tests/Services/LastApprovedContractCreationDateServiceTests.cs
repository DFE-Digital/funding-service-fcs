namespace ContractCreateDomain.Endpoint.Tests.Services
{
    using System;
    using System.Configuration;
    using System.Data.SqlClient;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using Endpoint.Services;
    using Infrastructure.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using System.Linq;
    using Extensions;
    using Dapper;

    [TestClass]
    public class LastApprovedContractCreationDateServiceTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void LastApprovedContractCreationDateService_GetLatestCreatedDateForNonNotificationApprovedContract_ShouldReturnCreationDateOfLastApprovedContract()
        {
            const string contractNumber = "EDSK-1234";
            DateTime v1Point0CreationDate = DateTime.Parse("2020-08-01 14:00");
            DateTime v2Point0CreationDate = v1Point0CreationDate.AddDays(1);
            DateTime v2Point1CreationDate = v2Point0CreationDate.AddDays(1); // last approved contract
            DateTime v3Point0CreationDate = v2Point1CreationDate.AddDays(1);

            // arrange
            using (var context = new ContractManagementDbContext())
            {
                context.ApprovedContracts.RemoveWhere(ac => ac.ContractNumber == contractNumber);
                context.CreatedContracts.RemoveWhere(cc => cc.ContractNumber == contractNumber);

                context.ApprovedContracts.Add(new ApprovedContract(
                    contractNumber,
                    2,
                    1,
                    "EDSK",
                    "AY2021",
                    12345,
                    "ORG12345",
                    "ESFA-1234",
                    DateTime.Parse("2020-08-01"),
                    DateTime.Parse("2021-07-31")));

                context.SaveChanges();

                context.Database.ExecuteSqlCommand($"INSERT INTO ContractManagement.CreatedContract (ContractNumber, ContractVersionNumber, ContractSubVersionNumber, CreatedDate) VALUES ('{contractNumber}', 1, 0, '{v1Point0CreationDate:yyyy-MM-dd HH:mm}')");
                context.Database.ExecuteSqlCommand($"INSERT INTO ContractManagement.CreatedContract (ContractNumber, ContractVersionNumber, ContractSubVersionNumber, CreatedDate) VALUES ('{contractNumber}', 2, 0, '{v2Point0CreationDate:yyyy-MM-dd HH:mm}')");
                context.Database.ExecuteSqlCommand($"INSERT INTO ContractManagement.CreatedContract (ContractNumber, ContractVersionNumber, ContractSubVersionNumber, CreatedDate) VALUES ('{contractNumber}', 2, 1, '{v2Point1CreationDate:yyyy-MM-dd HH:mm}')");
                context.Database.ExecuteSqlCommand($"INSERT INTO ContractManagement.CreatedContract (ContractNumber, ContractVersionNumber, ContractSubVersionNumber, CreatedDate) VALUES ('{contractNumber}', 3, 0, '{v3Point0CreationDate:yyyy-MM-dd HH:mm}')");
            }

            var service = new LastApprovedContractCreationDateService();
            var connectionInfo = new ConnectionInfo(null, new SqlConnection(ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString));

            // act
            DateTime? lastApprovedContractCreationDate = service.GetLatestCreatedDateForNonNotificationApprovedContract(contractNumber, connectionInfo).Result;

            // assert
            Assert.IsNotNull(v2Point1CreationDate, "Unexpected null value returned");
            Assert.AreEqual(v2Point1CreationDate, lastApprovedContractCreationDate, "Incorrect date returned");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void LastApprovedContractCreationDateService_GetLatestCreatedDateForNonNotificationApprovedContract_ShouldReturnNullWhenNoApprovedContractExists()
        {
            const string contractNumber = "EDSK-1234";
            DateTime v1Point0CreationDate = DateTime.Parse("2020-08-01 14:00");
            DateTime v1Point1CreationDate = v1Point0CreationDate.AddDays(1);

            // arrange
            using (var context = new ContractManagementDbContext())
            {
                context.ApprovedContracts.RemoveWhere(ac => ac.ContractNumber == contractNumber);
                context.CreatedContracts.RemoveWhere(cc => cc.ContractNumber == contractNumber);

                context.SaveChanges();

                context.Database.ExecuteSqlCommand($"INSERT INTO ContractManagement.CreatedContract (ContractNumber, ContractVersionNumber, ContractSubVersionNumber, CreatedDate) VALUES ('{contractNumber}', 1, 0, '{v1Point0CreationDate:yyyy-MM-dd HH:mm}')");
                context.Database.ExecuteSqlCommand($"INSERT INTO ContractManagement.CreatedContract (ContractNumber, ContractVersionNumber, ContractSubVersionNumber, CreatedDate) VALUES ('{contractNumber}', 1, 1, '{v1Point1CreationDate:yyyy-MM-dd HH:mm}')");
            }

            var service = new LastApprovedContractCreationDateService();
            var connectionInfo = new ConnectionInfo(null, new SqlConnection(ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString));

            // act
            DateTime? lastApprovedContractCreationDate = service.GetLatestCreatedDateForNonNotificationApprovedContract(contractNumber, connectionInfo).Result;

            // assert
            Assert.IsNull(lastApprovedContractCreationDate, "Unexpected non-null value returned");
        }
        
        [TestMethod, TestCategory("IntegrationTest")]
        public void LastApprovedContractCreationDateService_GetLatestCreatedDateForNonNotificationApprovedContract_ShouldReturnCorrectCreatedDateWhenLaterNotificationApprovedContractExists()
        {
            // arrange
            const string contractNumber = "EDSK-1234";

            DateTime now = DateTime.Now.ToDateTimeWithoutMinutes();
            ClearCreatedContract(contractNumber);
            ClearApprovedContract(contractNumber);
            InsertApprovedContract(contractNumber, 1, 0);
            InsertApprovedContract(contractNumber, 2, 0);
            InsertApprovedContract(contractNumber, 2, 1);
            InsertCreatedContract(contractNumber, 1, 0, now.AddDays(-20));
            InsertCreatedContract(contractNumber, 2, 0, now.AddDays(-10));
            InsertCreatedContract(contractNumber, 2, 1, now.AddDays(-1));
            InsertCreatedContractWithAmendmentType(contractNumber, 2, 2, now, AmendmentType.Notification);

            var service = new LastApprovedContractCreationDateService();

            using (var context = new ContractManagementDbContext())
            {
                // act
                var lastApprovedContractCreationDate = service.GetLatestCreatedDateForNonNotificationApprovedContract(contractNumber, new ConnectionInfo(null, context.Database.Connection)).Result;

                // assert
                Assert.IsNotNull(lastApprovedContractCreationDate, "Unexpected null value returned");
                Assert.AreEqual(now.AddDays(-1), lastApprovedContractCreationDate, "The date is incorrect");
            }
        }

        private static void ClearCreatedContract(string contractMNumber)
        {
            using (var context = new ContractManagementDbContext())
            {
                context.CreatedContracts.Where(c => c.ContractNumber == contractMNumber)
                    .ToList()
                    .ForEach(c => context.CreatedContracts.Remove(c));

                context.SaveChanges();
            }
        }
        
        private static void InsertCreatedContract(string contractNumber, int contractVersionNumber, int contractSubVersionNumber, DateTime createdDate)
        {

            using (var context = new ContractManagementDbContext())
            {
                const string sql = @"INSERT INTO [ContractManagement].[CreatedContract]
                                                ([ContractNumber] , [ContractVersionNumber], [ContractSubVersionNumber], [CreatedDate])
                                         VALUES (@contractNumber, @contractVersionNumber, @contractSubVersionNumber, @createdDate)";

                context.Database.Connection.Execute(sql, new { contractNumber, contractVersionNumber, contractSubVersionNumber, createdDate });
            }
        }

        private static void InsertCreatedContractWithAmendmentType(string contractNumber, int contractVersionNumber,
            int contractSubVersionNumber, DateTime createdDate, AmendmentType amendmentType)
        {
            using (var context = new ContractManagementDbContext())
            {
                const string sql = @"INSERT INTO [ContractManagement].[CreatedContract]
                                                ([ContractNumber] , [ContractVersionNumber], [ContractSubVersionNumber], [CreatedDate], AmendmentType)
                                         VALUES (@contractNumber, @contractVersionNumber, @contractSubVersionNumber, @createdDate, @amendmentType)";

                context.Database.Connection.Execute(sql, new { contractNumber, contractVersionNumber, contractSubVersionNumber, createdDate, amendmentType });
            }
        }

        private static void InsertApprovedContract(string contractNumber, int contractVersionNumber, int contractSubVersionNumber)
        {

            using (var context = new ContractManagementDbContext())
            {
                const string sql = @"INSERT INTO [ContractManagement].[ApprovedContract]
                                                ([ContractNumber] , [ContractVersionNumber], [ContractSubVersionNumber], [Ukprn], [OrganisationId])
                                         VALUES (@contractNumber, @contractVersionNumber, @contractSubVersionNumber, 1, 1)";

                context.Database.Connection.Execute(sql, new { contractNumber, contractVersionNumber, contractSubVersionNumber });
            }
        }

        private static void ClearApprovedContract(string contractMNumber)
        {
            using (var context = new ContractManagementDbContext())
            {
                context.ApprovedContracts.Where(c => c.ContractNumber == contractMNumber)
                    .ToList()
                    .ForEach(c => context.ApprovedContracts.Remove(c));

                context.SaveChanges();
            }
        }
    }
}
