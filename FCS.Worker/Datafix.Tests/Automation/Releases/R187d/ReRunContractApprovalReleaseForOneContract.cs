using Datafix.Tests.Infrastructure;
using Datafix.Tests.Services;
using NServiceBus;
using SFA.FCT.ContractManagementService.Common;
using SFA.FCT.ContractManagementService.Common.Commands;
using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Datafix.Tests.Automation.Releases.R187d
{
    public class ReRunContractApprovalReleaseForOneContract : IApplyDataFix
    {
        public string Release => "R187F";

        public int StoryNumber => 50874;

        public string Name => "Rerun EDSK-8154 more contracts for approval";

        public int Order => 1;
        public void ApplyDataFix()
        {
            try
            {
                var approvalCommands = new List<InitiateContractApprovalCommand>
                {
                    new InitiateContractApprovalCommand
                    {
                        ContractNumber = "EDSK-8154",
                        MasterContractNumber = "DFE-27509",
                        ContractVersionNumber = 1,
                        RequestSource = ApprovalRequestSource.External
                    }
                 };

                var endpoint = EndpointBuilder.CreateSendOnlyEndpoint<InitiateContractApprovalCommand>();

                var sendTasks = approvalCommands.Select(c => endpoint.Send("ContractManagementDomain.InitiateContractApproval", c)).ToArray();
                Task.WaitAll(sendTasks);




                //Delete the version 2 feed and version 1 withdraw feed
                var connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

                using (var connection = new SqlConnectionWithRetry(connectionString))
                {
                    try
                    {
                        connection.Execute(@"DELETE FROM ContractManagement.AtomFeedItem WHERE BusinessKey IN(
                                            'EDSK-8424:2.0',
                                            'EDSK-8321:2.0',
                                            'EDSK-8078:2.0',
                                            'EDSK-8145:2.0',
                                            'EDSK-8150:2.0',
                                            'EDSK-8154:2.0',
                                            'EDSK-8114:2.0',
                                            'EDSK-8401:2.0',
                                            'EDSK-8377:2.0',
                                            'EDSK-8358:2.0',
                                            'EDSK-8199:2.0'
                                            )");

                        connection.Execute(@"DELETE FROM ContractManagement.AtomFeedItem WHERE BusinessKey IN(
                                            'EDSK-8424:1.0',
                                            'EDSK-8321:1.0',
                                            'EDSK-8078:1.0',
                                            'EDSK-8145:1.0',
                                            'EDSK-8150:1.0',
                                            'EDSK-8154:1.0',
                                            'EDSK-8114:1.0',
                                            'EDSK-8401:1.0',
                                            'EDSK-8377:1.0',
                                            'EDSK-8358:1.0',
                                            'EDSK-8199:1.0'
                                            ) and ItemType = 2
                                            ");                        
                         
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($"Error applying data fix: {ex.Message}");
                    }
                }
            }
            catch (Exception ex)
            {
            }
        }
    }
}
