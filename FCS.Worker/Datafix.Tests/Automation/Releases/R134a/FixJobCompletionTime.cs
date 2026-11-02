using Datafix.Tests.Infrastructure;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Datafix.Tests.Automation.Releases.R134a
{
    public class FixJobCompletionTime : IApplyDataFix
    {
        public string Release => "R134a";
        public int StoryNumber => 38326;
        public string Name => "Update JobCompletedDate in FeedRead";
        public int Order => 1;

        public void ApplyDataFix()
        {
            var connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            using (var connection = new SqlConnectionWithRetry(connectionString))
            {
                const string sqlFeedRead = @"UPDATE [FundingAllocation].[FeedRead]
                                     SET [CfsReadCompletedDate] = Getdate() - 1 , [JobCompletedDate] = Getdate() - 1 
                                       WHERE [readId] = 361";
                connection.Execute(sqlFeedRead);
            }
        }
    }
}
