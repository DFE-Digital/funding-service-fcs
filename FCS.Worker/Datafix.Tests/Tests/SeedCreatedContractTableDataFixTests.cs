namespace Datafix.Tests.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using Automation.Releases.R86;
    using ContractManagement.DataStore.Model;
    using Datafix.Tests.Repositories;
    using Dtos;
    using Extensions;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    [TestClass]
    public class SeedCreatedContractTableDataFixTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void SeedCreatedContractTable_ShouldInsertRowsIntoPaaSTableThatAreReturnedFromCrm()
        {
            // arrange
            const string contractNumber = "test - cn1";
            const int version = 2;
            const int subVersion = 3;
            const int amendmentType = (int)sfa_amendmenttype.Notification;
            DateTime now = DateTime.Now;
            RemovedRowsFromCreatedContractTable(contractNumber: contractNumber);
            Mock<ICrmContractInformationRepository> crmContractInformationRepositoryMock = new Mock<ICrmContractInformationRepository>();
            crmContractInformationRepositoryMock.Setup(r => r.GetLastApprovedAndLatestVersionContractsWithoutDuplicates()).Returns(new HashSet<ContractInfo>
            {
                new ContractInfo(contractNumber, version, subVersion, now, amendmentType)
            });

            // act
            new ReseedCreatedContractTableWithAmendmentType(crmContractInformationRepositoryMock.Object).ApplyDataFix();

            // assert
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            using (var connection = new SqlConnectionWithRetry(connectionString))
            {
                string sql = @"select * from ContractManagement.CreatedContract where ContractNumber = @contractNumber";

                var contracts = connection.Query<dynamic>(sql, param: new { contractNumber }).ToList();
                Assert.AreEqual(1, contracts.Count, "The number of contracts is not correct");
                Assert.AreEqual(contractNumber, contracts.First().ContractNumber, "The contract number is not correct");
                Assert.AreEqual(version, contracts.First().ContractVersionNumber, "The version number is not correct");
                Assert.AreEqual(subVersion, contracts.First().ContractSubVersionNumber, "The sub version number is not correct");
                Assert.AreEqual((int)AmendmentType.Notification, contracts.First().AmendmentType, "The amendment type is not correct");
                DateTime retrievedContractCreatedDate = contracts.First().CreatedDate;

                Assert.AreEqual(now.ToDateTimeWithoutMilliseconds(), retrievedContractCreatedDate.ToDateTimeWithoutMilliseconds(), "The created date is not correct");
            }
        }

        public void RemovedRowsFromCreatedContractTable(string contractNumber)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            using (var connection = new SqlConnectionWithRetry(connectionString))
            {
                string sql = @"delete from ContractManagement.CreatedContract where ContractNumber = @contractNumber";

                connection.Execute(sql, param: new { contractNumber });
            }
        }
    }
}
