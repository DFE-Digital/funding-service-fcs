using Datafix.Tests.Infrastructure;
using Datafix.Tests.Services;
using NServiceBus;
using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Datafix.Tests.Automation.Releases.R188
{
    public class ImportMissedAllocation : RunSqlFileIntoDb, IApplyDataFix
    {
        public string Release => "R188e";
        public int StoryNumber => 48427;
        public string Name => "Import 5 Allocation from parked to Contracts";
        public int Order => 2;

        public void ApplyDataFix()
        {
             try
            {
                IReadOnlyCollection<string> RestoreAllocationSQL = new List<string>
                {
                     "Datafix.Tests.Resources.R188.Restore-10000944.sql",
                     "Datafix.Tests.Resources.R188.Restore-10001465.sql",
                     "Datafix.Tests.Resources.R188.Restore-10002917.sql",
                     "Datafix.Tests.Resources.R188.Restore-10009063.sql",
                     "Datafix.Tests.Resources.R188.Restore-10021684.sql"
                };
                foreach (var sqlFile in RestoreAllocationSQL)
                {
                    RunCodeFromFileIntoDb(sqlFile);
                }

                Thread.Sleep(50000); // milliseconds


                const string queueName = "FundingAllocation.IgnoreItemsOfNoInterest";

                IReadOnlyCollection<string> FundingAllocationId1 = new List<string>
                   {
                        "1619-AS-2627-Contracting-Provider-10001465-1_0",
                        "1619-AS-2627-Contracting-Provider-10002917-1_0",
                        "1619-AS-2627-Contracting-Provider-10009063-1_0",
                        "1619-AS-2627-Contracting-Provider-10021684-1_0",
                        "1619-AS-2627-Contracting-Provider-10000944-1_0"
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
