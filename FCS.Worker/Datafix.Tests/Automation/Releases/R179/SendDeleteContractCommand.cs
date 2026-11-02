using NServiceBus;
using SFA.FCT.CrossDomain.Integration.Messages.Commands;
using System.Collections.Generic;
using SFA.FCT.CrossDomain.Integration.Messages.Dtos;
using Datafix.Tests.Services;

namespace Datafix.Tests.Automation.Releases.R178b
{
    public class SendDeleteContractCommand : IApplyDataFix
    {
        public string Release => "R179";
        public int StoryNumber => 47241;
        public string Name => "SendDeleteContractCommand for EDSK-7616";
        public int Order => 2;

        public void ApplyDataFix()
        {
            var endpoint = EndpointBuilder.CreateSendOnlyEndpoint<FundingAllocationReleaseGroupCommand>();
            endpoint.Send("FundingAllocation.ReleaseGroup", new FundingAllocationReleaseGroupCommand
            {
                ReleaseGroupNames = new List<string> { "RG100912" },
                OnlyQueuedFundingAllocations = true,
                IgnoreContractIdentitiesWhenConsideringIntent = true,
                EventSourceContractIdentities = new List<SFA.FCT.CrossDomain.Integration.Entities.ContractIdentity> { new SFA.FCT.CrossDomain.Integration.Entities.ContractIdentity("EDSK-7616", 2, 0) },
                OverrideStatuses = new List<ContractAndStatus> { }
            }).Wait();
        }

    }
}
