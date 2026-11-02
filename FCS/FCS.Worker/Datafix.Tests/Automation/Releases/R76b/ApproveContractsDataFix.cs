namespace Datafix.Tests.Automation.Releases.R76b
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using NServiceBus;
    using Services;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    public class ApproveContractsDataFix : IApplyDataFix
    {
        public string Release => "R76b";
        public int StoryNumber => 28558;
        public string Name => "Re-enable activity for 16-19 Funding 17/18";
        public int Order => 1;
        public void ApplyDataFix()
        {
            var approvalCommands = new List<InitiateContractApprovalCommand>
            {
                new InitiateContractApprovalCommand
                {
                    ContractNumber = "1619F-2209",
                    MasterContractNumber = "ESFA-10421",
                    ContractVersionNumber = 3,
                    RequestSource = ApprovalRequestSource.External
                },
                new InitiateContractApprovalCommand
                {
                    ContractNumber = "1619F-2920",
                    MasterContractNumber = "ESFA-11164",
                    ContractVersionNumber = 1,
                    RequestSource = ApprovalRequestSource.External
                }
            };

            IEndpointInstance endpoint = EndpointBuilder.CreateSendOnlyEndpoint<InitiateContractApprovalCommand>();

            var sendTasks = approvalCommands.Select(c => endpoint.Send("ContractManagementDomain.InitiateContractApproval", c)).ToArray();
            Task.WaitAll(sendTasks);
        }
    }
}
