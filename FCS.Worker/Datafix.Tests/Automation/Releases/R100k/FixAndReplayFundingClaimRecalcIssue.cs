namespace Datafix.Tests.Automation.Releases.R100k
{
    using System.Linq;
    using Datafix.Tests.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Services;
    using SFA.FCT.PerformanceManagementDomain.Common.Commands;
    using NServiceBus;

    public class FixAndReplayFundingClaimRecalcIssue : IApplyDataFix
    {
        public string Release => "R100k";

        public int StoryNumber => 34237;

        public string Name => "Recalculate funding claim reconciliation fails when triggered from CRM [34237]";

        public int Order => 1;

        public void ApplyDataFix()
        {
            const int missingDeliverableCode = 5;
            PerformanceManagementFundingClaimRepository.UpdateFundingClaimClaimTypeName(oldClaimTypeName: "YEAR END", newClaimTypeName: "YEAREND");

           var allocationsWithDeliverable5Missing = PerformanceManagementFundingClaimContractAllocationRepository.GetAllocationsWithMissingDeliverable(
                "AEBC-ASCL2021", missingDeliverableCode);

            allocationsWithDeliverable5Missing.ToList()
                .ForEach(a =>
                {
                    PerformanceManagementFundingClaimDeliverableRepository.InsertEmptyDeliverable(a.allocationId, missingDeliverableCode);
                });
            var recalculateFcrOnCappedClaimAdjustmentCommands =
                MessageDeserializer.GetMessagesFromFile<RecalculateFcrOnCappedClaimAdjustmentCommand>("Datafix.Tests",
                    "Resources.R100k.RecalculateFcrOnCappedClaimAdjustmentCommands.json");

            Assert.AreEqual(111, recalculateFcrOnCappedClaimAdjustmentCommands.Count, "Unexpected number of messages");

            var endpoint = EndpointBuilder.CreateSendOnlyEndpoint<RecalculateFcrOnCappedClaimAdjustmentCommand>();
            recalculateFcrOnCappedClaimAdjustmentCommands.ToList()
                .ForEach(command =>
                {
                    endpoint.Send(destination: "PerformanceManagementDomain.ReconciliationCalculation", command).Wait();
                });
        }
    }
}
