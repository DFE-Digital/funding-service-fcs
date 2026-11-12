using NServiceBus;
using SFA.FCT.CrossDomain.Integration.Messages.Commands;
using SFA.FCT.CrossDomain.Integration.Messages.Dtos;
using SFA.FCT.CrossDomain.Integration.Entities;
using Datafix.Tests.Services;
using System;
using System.Collections.Generic;
using Datafix.Tests.Infrastructure;
using System.Configuration;
using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;

namespace Datafix.Tests.Automation.Releases.R181
{
    public class ASFQueuedAllocationDelete : IApplyDataFix
    {
        public string Release => "R181";
        public int StoryNumber => 48427;
        public string Name => "ASF Allocation Removal for provider 10001550";
        public int Order => 1;

        public void ApplyDataFix()
        {
            var connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnectionWithRetry(connectionString))
            {
                try
                {
                    connection.Execute(@"DELETE FROM FundingAllocation.FundingAllocation 
                                         WHERE FundingId = 'ASFG-AY-2526-Contracting-Provider-10001550-2_0'");

                    connection.Execute(@"DELETE FROM FundingAllocation.FundingAllocationLine 
                                         WHERE ProviderFundingId = 'ASFG-AY-2526-10001550-2_0'");

                    connection.Execute(@"DELETE FROM FundingAllocation.FundingAllocationProfilePeriod 
                                         WHERE ProviderFundingId = 'ASFG-AY-2526-10001550-2_0'");

                    connection.Execute(@"DELETE FROM FundingAllocation.ProcessedMessage 
                                         WHERE BusinessKey = 'ASFG-AY-2526-Contracting-Provider-10001550-2_0'");

                    connection.Execute(@"DELETE FROM FundingAllocation.ProviderFunding 
                                         WHERE ProviderFundingId = 'ASFG-AY-2526-10001550-2_0'");

                    connection.Execute(@"DELETE FROM FundingAllocation.ProviderFundingAllocation 
                                         WHERE FundingId = 'ASFG-AY-2526-Contracting-Provider-10001550-2_0'");

                    //Unparked version 3 allocation

                    const string queueName = "FundingAllocation.IgnoreItemsOfNoInterest";

                    IReadOnlyCollection<string> FundingAllocationId1 = new List<string>
                    {
                     "ASFG-AY-2526-Contracting-Provider-10001550-3_0"
                    };

                    var endpoint = EndpointBuilder.CreateSendOnlyEndpoint<IgnoreItemsOfNoInterestCommand>();

                    var obj = new IgnoreItemsOfNoInterestCommand() { FundingAllocationIds = FundingAllocationId1 };
                    endpoint.Send(destination: queueName, message: obj).Wait();
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Error applying data fix: {ex.Message}");
                }
            }
        }
    }
}
