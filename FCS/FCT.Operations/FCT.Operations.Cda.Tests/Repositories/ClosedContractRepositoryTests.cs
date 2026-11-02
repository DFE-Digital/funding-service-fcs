namespace FCT.Operations.Cda.Tests.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using Cda.Repositories;
    using Dapper;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class ClosedContractRepositoryTests
    {
        private const int ClosedAtomItemType = 3;
        private const int TerminatedAtomItemType = 6;

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClosedContractRepository_ShouldGetEmptyClosedContractsListFromLastYearWhenContractNotClosed()
        {
            // arrange
            const string contractNumber = "CN1";
            const string allocationNumber = "AN1";
            const string fspCode = "16-18TRN2021";
            ClearApprovedContracts(contractNumber);
            InsertContractAndAllocation(contractNumber, allocationNumber, fspCode);
            ClearAtomItems(contractNumber);

            ClosedContractRepository repository = new ClosedContractRepository();
            // act
            var closedContracts = repository.GetContractNumbersClosedInPreviousYears(new List<string> { fspCode }, 2021, ConnectionInfo).Result;

            // assert
            closedContracts.Should().BeEmpty();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClosedContractRepository_ShouldGetEmptyClosedContractsListFromLastYearWhenContractClosedThisYear()
        {
            // arrange
            const string contractNumber = "CN1";
            const string allocationNumber = "AN1";
            const string fspCode = "16-18TRN2021";
            ClearApprovedContracts(contractNumber);
            ClearAtomItems(contractNumber);
            InsertContractAndAllocation(contractNumber, allocationNumber, fspCode);
            InsertAtomItem(contractNumber, ClosedAtomItemType, 2022);

            ClosedContractRepository repository = new ClosedContractRepository();
            // act
            var closedContracts = repository.GetContractNumbersClosedInPreviousYears(new List<string> { fspCode }, 2021, ConnectionInfo).Result;

            // assert
            closedContracts.Should().BeEmpty();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClosedContractRepository_ShouldGetClosedContractsListFromLastYearWhenContractClosedLastYear()
        {
            // arrange
            const string contractNumber = "CN1";
            const string allocationNumber = "AN1";
            const string fspCode = "16-18TRN2021";
            const int currentYear = 2022;
            ClearApprovedContracts(contractNumber);
            ClearAtomItems(contractNumber);
            InsertContractAndAllocation(contractNumber, allocationNumber, fspCode);
            InsertAtomItem(contractNumber, ClosedAtomItemType, currentYear - 1);

            ClosedContractRepository repository = new ClosedContractRepository();
            // act
            var closedContracts = repository.GetContractNumbersClosedInPreviousYears(new List<string> { fspCode }, 2021, ConnectionInfo).Result;

            // assert
            closedContracts.Any().Should().BeTrue();
            closedContracts.Single().contractNumber.Should().Be(contractNumber);
            closedContracts.Single().year.Should().Be(2021);
        }


        [TestMethod, TestCategory("IntegrationTest")]
        public void ClosedContractRepository_ShouldGetClosedContractsListFromLastYearWhenContractTerminatedLastYear()
        {
            // arrange
            const string contractNumber = "CN1";
            const string allocationNumber = "AN1";
            const string fspCode = "16-18TRN2021";
            const int currentYear = 2022;
            ClearApprovedContracts(contractNumber);
            ClearAtomItems(contractNumber);
            InsertContractAndAllocation(contractNumber, allocationNumber, fspCode);
            InsertAtomItem(contractNumber, TerminatedAtomItemType, currentYear - 1);

            ClosedContractRepository repository = new ClosedContractRepository();
            // act
            var closedContracts = repository.GetContractNumbersClosedInPreviousYears(new List<string> { fspCode }, 2021, ConnectionInfo).Result;

            // assert
            closedContracts.Any().Should().BeTrue();
            closedContracts.Single().contractNumber.Should().Be(contractNumber);
            closedContracts.Single().year.Should().Be(2021);
        }

        private void InsertContractAndAllocation(string contractNumber, string allocationNumber, string fspCode)
        {
            const string sql =
                "insert into [ContractManagement].[ApprovedContract] (contractNumber, contractVersionNumber, contractSubVersionNumber, ukprn, organisationId) OUTPUT Inserted.ApprovedContractId values (" +
                "@contractNumber, 1, 0, 12345678, 'ORG1')";

            var contractId = GetDbConnection.ExecuteScalar(sql, param: new { contractNumber });

            const string sqlForAllocInsert =
                "insert into [ContractManagement].[ApprovedContractAllocation] (contractAllocationNumber, approvedContractId, totalPlannedValue, fundingStreamPeriodCode) values (" +
                "@allocationNumber, @contractId, 0, @fspCode)";

            GetDbConnection.Execute(sqlForAllocInsert, param: new { contractId, allocationNumber, fspCode });
        }

        private void InsertAtomItem(string contractNumber, int atomItemType, int year)
        {
            const string sql =
                "insert into [ContractManagement].[AtomFeedItem] (identifier, itemType, businessKey, duplicateIdentifier, createdDate) values (" +
                "@id, @atomItemType, @businessKey, @duplicateId, @createdDate)";

            DateTime createdDate = new DateTime(year, 1, 1);
            string businessKey = $"{contractNumber}:1.0";
            Guid id = Guid.NewGuid();
            Guid duplicateId = Guid.NewGuid();
            GetDbConnection.Execute(sql, param: new { atomItemType, businessKey, createdDate, id, duplicateId });
        }

        private void ClearApprovedContracts(string contractNumber)
        {
            const string sql =
                "delete from  [ContractManagement].[ApprovedContract] where ContractNumber = @contractNumber";

            GetDbConnection.Execute(sql, param: new { contractNumber });
        }

        private void ClearAtomItems(string contractNumber)
        {
            const string sql =
                "delete from [ContractManagement].[AtomFeedItem] where BusinessKey like concat(@contractNumber, '%')";

            GetDbConnection.Execute(sql, param: new { contractNumber });
        }

        private ConnectionInfo ConnectionInfo => new ConnectionInfo(null, GetDbConnection);

        private SqlConnection GetDbConnection =>
            new SqlConnection(ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString);
    }
}
