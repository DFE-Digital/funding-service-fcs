namespace ContractCreateDomain.IncrementContractVersionEndpoint.Tests.Repositories
{
    using System;
    using System.Linq;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using Dapper;
    using Extensions;
    using IncrementContractVersionEndpoint.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Optional;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class CreatedContractRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void CreatedContractRepository_ShouldAdd()
        {
            // arrange
            const string contractNumber = "Test CN1";
            const int version = 1;
            const int subVersion = 2;
            ClearCreatedContract(contractNumber);
            CreatedContractRepository createdContractRepository = new CreatedContractRepository();

            // act
            using (var context = new ContractManagementDbContext())
            {
                createdContractRepository.Add(new CreatedContract(contractNumber, version, subVersion, null),
                    new ConnectionInfo(null, context.Database.Connection)).Wait();
            }

            using (var context = new ContractManagementDbContext())
            {
                // assert
                var contract = context.CreatedContracts.SingleOrDefault(c => c.ContractNumber == contractNumber);
                Assert.IsNotNull(contract);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CreatedContractRepository_GetLatestCreatedDateForNonNotificationApprovedContract_ShouldReturnNoneWhenThereIsNoMatchingRow()
        {
            // arrange
            const string contractNumber = "Test CN2";
            ClearCreatedContract(contractNumber);
            ClearApprovedContract(contractNumber);
            CreatedContractRepository createdContractRepository = new CreatedContractRepository();

            using (var context = new ContractManagementDbContext())
            {
                // act
                Option<DateTime?> mostRecentOptional = createdContractRepository.GetLatestCreatedDateForNonNotificationApprovedContract(contractNumber, new ConnectionInfo(null, context.Database.Connection)).Result;
                
                Assert.IsFalse(mostRecentOptional.HasValue);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CreatedContractRepository_GetLatestCreatedDateForNonNotificationApprovedContract_ShouldReturnSomeWhenThereIsAMatchingRow()
        {
            // arrange
            const string contractNumber = "Test CN3";
            
            DateTime now = DateTime.Now.ToDateTimeWithoutMinutes();
            ClearCreatedContract(contractNumber);
            ClearApprovedContract(contractNumber);
            InsertApprovedContract(contractNumber, 2, 1);
            InsertCreatedContract(contractNumber, 1, 0, now.AddDays(-10));
            InsertCreatedContract(contractNumber, 2, 0, now.AddDays(-1));
            InsertCreatedContract(contractNumber, 2, 1, now);

            CreatedContractRepository createdContractRepository = new CreatedContractRepository();

            
            using (var context = new ContractManagementDbContext())
            {
                // act
                Option<DateTime?> mostRecentOptional = createdContractRepository.GetLatestCreatedDateForNonNotificationApprovedContract(contractNumber, new ConnectionInfo(null, context.Database.Connection)).Result;
                
                // assert
                Assert.IsTrue(mostRecentOptional.HasValue, "we should have returned a date");
                mostRecentOptional.MatchSome(d =>
                {
                    Assert.AreEqual(now, d.Value.ToDateTimeWithoutMinutes(), "The dates are not equal");
                });
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CreatedContractRepository_GetLatestCreatedDateForNonNotificationApprovedContract_ShouldReturnCorrectCreatedDateWhenLaterNotificationApprovedContractExists()
        {
            // arrange
            const string contractNumber = "Test CN4";

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

            var createdContractRepository = new CreatedContractRepository();


            using (var context = new ContractManagementDbContext())
            {
                // act
                Option<DateTime?> mostRecentOptional = createdContractRepository.GetLatestCreatedDateForNonNotificationApprovedContract(contractNumber, new ConnectionInfo(null, context.Database.Connection)).Result;

                // assert
                Assert.IsTrue(mostRecentOptional.HasValue, "we should have returned a date");
                mostRecentOptional.MatchSome(d =>
                {
                    Assert.AreEqual(now.AddDays(-1), d.Value.ToDateTimeWithoutMinutes(), "The dates are not equal");
                });
            }
        }

        private void ClearCreatedContract(string contractMNumber)
        {
            using (var context = new ContractManagementDbContext())
            {
                context.CreatedContracts.Where(c => c.ContractNumber == contractMNumber)
                    .ToList()
                    .ForEach(c => context.CreatedContracts.Remove(c));

                context.SaveChanges();
            }
        }

        private void InsertCreatedContract(string contractNumber, int contractVersionNumber, int contractSubVersionNumber, DateTime createdDate)
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

        private void InsertApprovedContract(string contractNumber, int contractVersionNumber, int contractSubVersionNumber)
        {

            using (var context = new ContractManagementDbContext())
            {
                const string sql = @"INSERT INTO [ContractManagement].[ApprovedContract]
                                                ([ContractNumber] , [ContractVersionNumber], [ContractSubVersionNumber], [Ukprn], [OrganisationId])
                                         VALUES (@contractNumber, @contractVersionNumber, @contractSubVersionNumber, 1, 1)";

                context.Database.Connection.Execute(sql, new { contractNumber, contractVersionNumber, contractSubVersionNumber });
            }
        }

        private void ClearApprovedContract(string contractMNumber)
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
