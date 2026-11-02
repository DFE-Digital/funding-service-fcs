namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using Extensions;
    using MoreLinq;
    using CrossDomain.Integration.Messages.Commands;
    using Infrastructure.Repositories;
    using Infrastructure.Repositories.CrmReplicaRepo;
    using Infrastructure.Services;
    using NUnit.Framework;
    using TechTalk.SpecFlow;
    using Utilities;
    using System.Linq;

    [Binding]
    public class DuplicateContractSteps
    {
        [When(@"the Duplicate Contract monitoring job is run")]
        public void WhenTheDuplicateContractMonitoringJobIsRun()
        {
            MessageSendingBus.Send("Operations.IntegrityCheckers", new CheckForDuplicateContractsCommand());
        }

        [Then(@"there are no duplicate contracts in CRM")]
        public void ThenThereAreNoDuplicateContractsInCRM()
        {
            var thereAreNoDuplicates = false;

            var poller = new CheckResultPoller(() =>
            {
                thereAreNoDuplicates = DuplicateContractRepository.ThereAreNoDuplicates();

                return thereAreNoDuplicates;
            }, maxNumChecks: 30, waitIntervalSeconds: 4);

            poller.CheckResultAndWaitTillCompleteOrOutOfTime();

            Assert.True(thereAreNoDuplicates, "Duplicate contract(s) found in CRM");
        }

        [Then(@"there are '(.*)' duplicate contracts in CRM as follows")]
        [Then(@"there is '(.*)' duplicate contract in CRM as follows")]
        public void ThenThereAreDuplicateContractsInCRMAsFollows(int p0, TransformedTable table)
        {
            table.Rows.ForEach(r =>
            {
                var contractNumber = r["ContractNumber"];
                var versionNumber = int.Parse(r["ContractVersionNumber"]);
                var subVersionNumber = int.Parse(r["ContractSubVersion"]);
                var duplicateContractExists = false;

                var poller = new CheckResultPoller(() =>
                {
                    duplicateContractExists = DuplicateContractRepository.DuplicateContractExists(contractNumber, versionNumber, subVersionNumber);

                    return duplicateContractExists;
                }, maxNumChecks: 30, waitIntervalSeconds: 4);

                poller.CheckResultAndWaitTillCompleteOrOutOfTime();

                Assert.IsTrue(duplicateContractExists,
                    $"Duplicate contract not found for ContractNumber {contractNumber}, ContractVersionNumber {versionNumber},  ContractSubVersion {subVersionNumber}");
            });
        }

        [Then(@"there are '(.*)' duplicate contracts in the replicated CRM database as follows")]
        [Then(@"there is '(.*)' duplicate contract in the replicated CRM database as follows")]
        public void ThenThereAreDuplicateContractsInReplicatedCRMDatabaseAsFollows(int p0, Table table)
        {
            table.Rows.ForEach(r =>
            {
                var contractNumber = r["ContractNumber"];
                var versionNumber = int.Parse(r["ContractVersionNumber"]);
                var subVersionNumber = int.Parse(r["ContractSubVersion"]);
                var duplicateContractExists = false;

                var poller = new CheckResultPoller(() =>
                {
                    duplicateContractExists = CrmReplicatedDuplicateContractRepository.DuplicateContractExists(contractNumber, versionNumber, subVersionNumber);

                    return duplicateContractExists;
                }, maxNumChecks: 30, waitIntervalSeconds: 4);

                poller.CheckResultAndWaitTillCompleteOrOutOfTime();

                Assert.IsTrue(duplicateContractExists,
                    $"Duplicate CRM Contract does not exist in the CRM replicated database. ContractNumber {contractNumber}, ContractVersionNumber {versionNumber},  ContractSubVersion {subVersionNumber}");
            });
        }

        [Then(@"there are no duplicate contracts in the replicated CRM database")]
        public void ThenThereAreNoDuplicateContractsInTheReplicatedCRMDatabase()
        {
            var noDuplicateContractExists = false;

            var poller = new CheckResultPoller(() =>
            {
                noDuplicateContractExists = CrmReplicatedDuplicateContractRepository.NoDuplicateContractExists();

                return noDuplicateContractExists;
            }, maxNumChecks: 30, waitIntervalSeconds: 4);

            poller.CheckResultAndWaitTillCompleteOrOutOfTime();

            Assert.IsTrue(noDuplicateContractExists, $"Duplicate CRM Contracts found in the CRM replicated database");
        }

        [When(@"Clear down Deletion Synchronization Failure for contract")]
        public void WhenClearDownDeletionSynchronizationFailureForContract(Table table)
        {
            table.Rows.Select(r => new
            {
                contractNumber = r["ContractNumber"],
                version = r.ParseInt("ContractVersionNumber"),
                subVersionNumber = r.ParseInt("ContractSubVersion")
            }).ForEach(c => CrmReplicatedDuplicateContractRepository.ClearDownSyncFailureContract(c.contractNumber, c.version, c.subVersionNumber));
        }

        [When(@"Create Deletion Synchronization Failure for contract \(and children\)")]
        public void WhenCreateDeletionSynchronizationFailureForContractAndChildren(Table table)
        {
            table.Rows.Select(r => new
            {
                contractNumber = r["ContractNumber"],
                version = r.ParseInt("ContractVersionNumber"),
                subVersionNumber = r.ParseInt("ContractSubVersion")
            }).ForEach(c => CrmReplicatedDuplicateContractRepository.SetupSyncFailureForContractAndChildren(c.contractNumber,c.version, c.subVersionNumber));
        }

        [Given(@"there is no data in the Operations\.DuplicateContract table")]
        public void GivenThereIsNoDataInTheOperations_DuplicateContractTable()
        {
            DuplicateContractRepository.ClearDownDuplicateContractTable();
        }
    }
}