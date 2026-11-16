using NServiceBus;
using SFA.FCT.CrossDomain.Integration.Messages.Commands;
using SFA.FCT.CrossDomain.Integration.Messages.Dtos;
using SFA.FCT.CrossDomain.Integration.Entities;
using Datafix.Tests.Services;
using System;
using System.Collections.Generic;

namespace Datafix.Tests.Automation.Releases.R179a
{
    public class ReleasefromQueuedAllocation : IApplyDataFix
    {
        public string Release => "R179a";
        public int StoryNumber => 48303;
        public string Name => "ReleasefromQueuedAllocation for DADA Contracts";
        public int Order => 1;

        public void ApplyDataFix()
        {
            var endpoint = EndpointBuilder.CreateSendOnlyEndpoint<FundingAllocationReleaseGroupCommand>();

            
                SendReleaseGroupCommand(endpoint, "RG100937", new List<ContractIdentity>
                {
                    new ContractIdentity("DADAS-1003", 3, 0),
                    new ContractIdentity("DADAS-1015", 2, 0),
                    new ContractIdentity("DADAS-1002", 3, 0)
                });
           
        }

        private void SendReleaseGroupCommand(EndpointBuilder endpoint, string releaseGroupName, List<ContractIdentity> contractIdentities)
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
