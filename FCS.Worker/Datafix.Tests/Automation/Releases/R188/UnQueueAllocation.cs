using NServiceBus;
using SFA.FCT.CrossDomain.Integration.Messages.Commands;
using SFA.FCT.CrossDomain.Integration.Messages.Dtos;
using SFA.FCT.CrossDomain.Integration.Entities;
using Datafix.Tests.Services;
using System;
using System.Collections.Generic;

namespace Datafix.Tests.Automation.Releases.R188
{
    public class UnQueueAllocation :IApplyDataFix
    {
        public string Release => "R188f";
        public int StoryNumber => 51325;
        public string Name => "ReleasefromQueuedAllocation for 1619 Contracts";
        public int Order => 1;

        public void ApplyDataFix()
        {
            var endpoint = EndpointBuilder.CreateSendOnlyEndpoint<FundingAllocationReleaseGroupCommand>();


            SendReleaseGroupCommand(endpoint, "RG101164", new List<ContractIdentity>
                {
                    new ContractIdentity("EDSK-8228", 3, 3)
                });

        }

        private void SendReleaseGroupCommand(IEndpointInstance endpoint, string releaseGroupName, List<ContractIdentity> contractIdentities)
        {
            var command = new FundingAllocationReleaseGroupCommand
            {
                ReleaseGroupNames = new List<string> { releaseGroupName },
                OnlyQueuedFundingAllocations = true,
                IgnoreContractIdentitiesWhenConsideringIntent = true,
                EventSourceContractIdentities = contractIdentities,
                OverrideStatuses = new List<ContractAndStatus>()
            };

            endpoint.Send("FundingAllocation.ReleaseGroup", command).Wait();
        }

    }
}
