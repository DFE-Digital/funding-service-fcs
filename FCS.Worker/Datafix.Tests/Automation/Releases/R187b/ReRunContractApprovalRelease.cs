using Datafix.Tests.Services;
using NServiceBus;
using SFA.FCT.ContractManagementService.Common;
using SFA.FCT.ContractManagementService.Common.Commands;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Datafix.Tests.Automation.Releases.R187b
{
    public class ReRunContractApprovalRelease : IApplyDataFix
    {
        public string Release => "R187E";

        public int StoryNumber => 50752;

        public string Name => "Rerun 1 more contracts for approval";

        public int Order => 1;
        public void ApplyDataFix()
        {
            try
            {
            var approvalCommands = new List<InitiateContractApprovalCommand>
            {
                new InitiateContractApprovalCommand
                {
                    ContractNumber = "EDSK-8424",
                    MasterContractNumber = "DFE-27779",
                    ContractVersionNumber = 1,
                    RequestSource = ApprovalRequestSource.External
                }
                //new InitiateContractApprovalCommand
                //{
                //    ContractNumber = "EDSK-8321",
                //    MasterContractNumber = "DFE-27677",
                //    ContractVersionNumber = 1,
                //    RequestSource = ApprovalRequestSource.External
                //}
                //new InitiateContractApprovalCommand
                //{
                //    ContractNumber = "EDSK-8145",
                //    MasterContractNumber = "DFE-27501",
                //    ContractVersionNumber = 1,
                //    RequestSource = ApprovalRequestSource.External
                //},
                //new InitiateContractApprovalCommand
                //{
                //    ContractNumber = "EDSK-8401",
                //    MasterContractNumber = "DFE-27757",
                //    ContractVersionNumber = 1,
                //    RequestSource = ApprovalRequestSource.External
                //},
                //  new InitiateContractApprovalCommand
                //{
                //    ContractNumber = "EDSK-8199",
                //    MasterContractNumber = "DFE-27555",
                //    ContractVersionNumber = 1,
                //    RequestSource = ApprovalRequestSource.External
                //},
                //new InitiateContractApprovalCommand
                //{
                //    ContractNumber = "EDSK-8358",
                //    MasterContractNumber = "DFE-27714",
                //    ContractVersionNumber = 1,
                //    RequestSource = ApprovalRequestSource.External
                //},
                //new InitiateContractApprovalCommand
                //{
                //    ContractNumber = "EDSK-8377",
                //    MasterContractNumber = "DFE-27733",
                //    ContractVersionNumber = 1,
                //    RequestSource = ApprovalRequestSource.External
                //},  new InitiateContractApprovalCommand
                //{
                //    ContractNumber = "EDSK-8078",
                //    MasterContractNumber = "DFE-27433",
                //    ContractVersionNumber = 1,
                //    RequestSource = ApprovalRequestSource.External
                //},
                //new InitiateContractApprovalCommand
                //{
                //    ContractNumber = "EDSK-8114",
                //    MasterContractNumber = "DFE-27470",
                //    ContractVersionNumber = 1,
                //    RequestSource = ApprovalRequestSource.External
                //},
                //new InitiateContractApprovalCommand
                //{
                //    ContractNumber = "EDSK-8150",
                //    MasterContractNumber = "DFE-27505",
                //    ContractVersionNumber = 1,
                //    RequestSource = ApprovalRequestSource.External
                //}
            };

                var endpoint = EndpointBuilder.CreateSendOnlyEndpoint<InitiateContractApprovalCommand>();

                var sendTasks = approvalCommands.Select(c => endpoint.Send("ContractManagementDomain.InitiateContractApproval", c)).ToArray();
                Task.WaitAll(sendTasks);
            }
            catch (Exception ex) { 
            }
        }
    }
}
