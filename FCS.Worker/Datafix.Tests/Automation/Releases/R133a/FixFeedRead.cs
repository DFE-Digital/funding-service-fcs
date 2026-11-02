using Datafix.Tests.Infrastructure;
using Datafix.Tests.Repositories;
using Datafix.Tests.Services;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NServiceBus;
using SFA.FCT.ContractCreateDomain.Common.Messages.Commands;
using SFA.FCT.ContractManagementService.Common.Commands;
using SFA.FCT.CrossDomain.Integration.Common;
using SFA.FCT.CrossDomain.Integration.Events;
using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Datafix.Tests.Automation.Releases.R133a
{
    public class FixFeedRead : IApplyDataFix
    {
        public string Release => "R133a";
        public int StoryNumber => 38258;
        public string Name => "Fix FeedRead";
        public int Order => 1;

        public void ApplyDataFix()
        {
            var connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            using (var connection = new SqlConnectionWithRetry(connectionString))
            {
                const string sqlFeedRead = @"UPDATE [FundingAllocation].[FeedRead]
                                     SET [CfsReadCompletedDate] = Getdate() - 1 , [JobCompletedDate] = Getdate() - 1 
                                       WHERE [readId] = 360";
                connection.Execute(sqlFeedRead);

                const string sqlPageControl = @"UPDATE [FundingAllocation].[FundingAllocationPageControl]
                                    SET [LatestBookmarkOnPage] = '1619-AS-2122-Contracting-Provider-10004676-7_0'  
                                    WHERE [readId] = 360";
                connection.Execute(sqlPageControl);
            }
        }
     }
}
