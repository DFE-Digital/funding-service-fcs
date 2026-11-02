using Datafix.Tests.Infrastructure;
using Datafix.Tests.Repositories;
using Datafix.Tests.Services;
using SFA.FCT.ContractManagementService.Common.Commands;
using SFA.FCT.CrossDomain.Integration.Entities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Datafix.Tests.Automation.Releases.R160
{
    public class RemoveUnusedParkedRecord : IApplyDataFix
    {
        public string Release => "R160";
        public int StoryNumber => 42186;  //story Number 
        public string Name => "Remove Unused Parked Records";
        public int Order => 1;

        public void ApplyDataFix()
        {
            var connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            using (var connection = new SqlConnectionWithRetry(connectionString))
            {
                //Delete Data From - FundingAllocation.FundingAllocation
                const string sqlFundingAllocation = @"Delete From FundingAllocation.FundingAllocation 
                                              Where FundingId in 
                                              ('1619-AS-2223-Contracting-LocalAuthoritySsf-10006335-1_0'
                                              ,'1619Recon-AS-2324-Contracting-Provider-10000055-1_0')";
                connection.Execute(sqlFundingAllocation);

                //Delete Data From - FundingAllocation.ProviderFunding
                const string sqlProviderFunding = @"Delete from  FundingAllocation.ProviderFunding 
                                                Where ProviderFundingId in(
                                                '1619-AS-2223-10016839-3_0',
                                                '1619Recon-AS-2324-10000055-1_0' )";
                connection.Execute(sqlProviderFunding);

                ////Delete Data From - FundingAllocation.FundingAllocationProfilePeriod
                //const string sqlFundingAllocationProfilePeriod = @"Delete From [FundingAllocation].[FundingAllocationProfilePeriod] 
                //                                Where ProviderFundingId in(
                //                            '1619-AS-2223-10016839-3_0','1619Recon-AS-2324-10000055-1_0' ) ";
                //connection.Execute(sqlFundingAllocationProfilePeriod);

                ////Delete Data From - FundingAllocation.FundingAllocationLine
                //const string sqlFundingAllocationLine = @"Delete FROM FundingAllocation.FundingAllocationLine where ProviderFundingId in(
                //                                         '1619-AS-2223-10016839-3_0','1619Recon-AS-2324-10000055-1_0' ) ";
                //connection.Execute(sqlFundingAllocationLine);

                ////Delete Data From - FundingAllocation.ProviderFundingAllocation
                //const string sqlProviderFundingAllocation = @"Delete from  [FundingAllocation].ProviderFundingAllocation 
                //                        Where FundingId in ('1619-AS-2223-Contracting-LocalAuthoritySsf-10006335-1_0',
                //                        '1619Recon-AS-2324-Contracting-Provider-10000055-1_0')";
                //connection.Execute(sqlProviderFundingAllocation);
            }
        }

    }
}
