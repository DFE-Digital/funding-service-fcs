using Datafix.Tests.Services;
using NServiceBus;
using SFA.FCT.ContractManagementService.Common.Commands;
using SFA.FCT.ContractManagementService.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Datafix.Tests.Automation.Releases.R140
{
    public class RerunContractApprovalCommand : IApplyDataFix
    {
        public string Release => "R140";

        public int StoryNumber => 38980;

        public string Name => "Rerun contract for approval";

        public int Order => 2;
        public void ApplyDataFix()
        {
            var approvalCommands = new List<InitiateContractApprovalCommand>
            {
                new InitiateContractApprovalCommand
                {
                    ContractNumber = "FERCA-1112",
                    MasterContractNumber = "ESFA-23467",
                    ContractVersionNumber = 2,
                    RequestSource = ApprovalRequestSource.External
                },
                new InitiateContractApprovalCommand
                {
                    ContractNumber = "EDSK-4755",
                    MasterContractNumber = "ESFA-22120",
                    ContractVersionNumber = 5,
                    RequestSource = ApprovalRequestSource.External
                },
                new InitiateContractApprovalCommand
                {
                    ContractNumber = "NLAP-1077",
                    MasterContractNumber = "ESFA-11557",
                    ContractVersionNumber = 17,
                    RequestSource = ApprovalRequestSource.External
                }
            };

            IEndpointInstance endpoint = EndpointBuilder.CreateSendOnlyEndpoint<InitiateContractApprovalCommand>();

            var sendTasks = approvalCommands.Select(c => endpoint.Send("ContractManagementDomain.InitiateContractApproval", c)).ToArray();
            Task.WaitAll(sendTasks);
        }
    }
}
