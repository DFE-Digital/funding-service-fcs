using Datafix.Tests.Infrastructure;
using Datafix.Tests.Repositories;
using Datafix.Tests.Services;
using NServiceBus;
using Operations.DataStore;
using PaymentGenerationDomain.Integration.DataStore;
using SFA.FCT.CrossDomain.Integration.Messages.Commands;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Datafix.Tests.Automation.Releases.R141
{
    public class AddingMissedCollegeProvider : IApplyDataFix
    {
        public string Release => "R145a";
        public int StoryNumber => 39661;
        public string Name => "AddingMissedCollegeProvider";
        public int Order => 1;

        public void ApplyDataFix()
        {

            var connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            using (var connection = new SqlConnectionWithRetry(connectionString))
            {
                const string sqlFeedRead = @"INSERT INTO [FundingAllocation].[CfsCodesToContractTypeConfig](FundingTypeCode,FundingPeriodCode,ProviderCategory,ContractType,CreatedDate)
VALUES ('EDSK','AY2324','College','Accountability Agreement (College)',getdate())";

                connection.Execute(sqlFeedRead);

            }


            const string queueName = "FundingAllocation.UnParkFundingAllocation";

            var endpoint = EndpointBuilder.CreateSendOnlyEndpoint<StartUnParkFundingAllocationsCommand>();

            endpoint.Send(destination: queueName, message: new StartUnParkFundingAllocationsCommand()).Wait();
        }
    }
}
