namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Services
{
    using System.Linq;
    using ContractManagement.DataStore.Model;
    using ContractManagementService.Common.Commands;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Repositories;
    using Utilities;

    public static class ContractPublisher
    {
        public static void PublishLatestContractAndWaitForAtomItemToBePresent(string contractNumber, string masterContractNumber)
        {
            ConfirmPublicationToProviderCommand command = new ConfirmPublicationToProviderCommand
            {
                ContractNumber = contractNumber,
                MasterContractNumber = masterContractNumber,
            };

            MessageSendingBus.Send("ContractManagementDomain.ConfirmPublicationToProvider", command);

            CheckResultPoller poller = new CheckResultPoller(checkResult: () =>
                {
                    var atomFeedItems = ContractAtomFeedItemRepository.GetAtomFeedItemsByContractNumber(contractNumber);

                    return atomFeedItems.Any(a => a.ItemType == AtomItemType.DraftContract);
                },
                maxNumChecks: 15,
                waitIntervalSeconds:4
            );

            bool atomItemCreated = poller.CheckResultAndWaitTillCompleteOrOutOfTime();

            Assert.IsTrue(atomItemCreated, $"The contract: {contractNumber} does not appear in the [ContractManagement].[AtomFeedItem] table");
        }
    }
}
