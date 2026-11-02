namespace PerformanceManagementDomain.Tests.ReconciliationCalculationEndpoint.Repositories
{
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using System.Data.Entity;
    using UnitTests.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories;

    [TestClass]
    public class ClaimTypeRepositoryTests
    {
        private List<ClaimType> _claimTypeList;

        [TestCleanup]
        public void TestCleanup()
        {
            using (var context = new PerformanceManagementDbContext())
            {
                _claimTypeList.ForEach(claimType =>
                {
                    context.ClaimTypes.RemoveByKey(claimType.ClaimTypeCode);
                });

                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimTypeRepositoryWorker_WhenFindIsCalled_WithPrimaryKey_CorrectRecordIsReturned()
        {
            // Arrange
            const string claimTypeName = "testName3";
            _claimTypeList = CreateEntities(new ClaimType("test", "testName"), 5);
            AddClaimTypesToDb(_claimTypeList);

            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                ConnectionInfo connectionInfo = new ConnectionInfo(context.Database.CurrentTransaction?.UnderlyingTransaction, context.Database.Connection);

                // Act
                var repository = new ClaimTypeRepository();

                var assertClaimTypeName = repository.FindByName(claimTypeName, connectionInfo).Result;

                // Assert
                Assert.IsNotNull(claimTypeName);
                Assert.AreEqual(claimTypeName, assertClaimTypeName.Name);
            }
        }

        private void AddClaimTypesToDb(List<ClaimType> claimTypeList)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                ((DbSet<ClaimType>)context.ClaimTypes).AddRange(claimTypeList);

                context.SaveChanges();
            }
        }

        private List<ClaimType> CreateEntities(ClaimType exampleClaimType, int noOfEntitiesToCreate)
        {
            var claimTypeList = new List<ClaimType>();

            for (int i = 1; i <= noOfEntitiesToCreate; i++)
            {
                claimTypeList.Add(new ClaimType(exampleClaimType.ClaimTypeCode + i, exampleClaimType.Name + i));
            }

            return claimTypeList;
        }
    }
}