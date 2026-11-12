using Datafix.Tests.Services;
using Newtonsoft.Json;
using NServiceBus;
using SFA.FCS.Worker.Common.Crm;
using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
using SFA.FCT.CrossDomain.Integration.Messages.Commands;
using System;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using Microsoft.Xrm.Sdk;
using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
using System.Configuration;
using Datafix.Tests.Infrastructure;

namespace Datafix.Tests.Automation.Releases.R145b
{
    public class UpdateReleaseStatus : IApplyDataFix
    {
        public string Release => "R145B";
        public int StoryNumber => 39727;
        public string Name => "Update Release group status";
        public int Order => 1;

        public void ApplyDataFix()
        {
            try
            {
                // Set Release group to Released in PAAS and CRM
                var endpoint = EndpointBuilder.CreateSendOnlyEndpoint<ReleaseGroupSetToReleasedCommand>();

                endpoint.Send("FundingAllocation.ReleaseGroupSetToReleased", new ReleaseGroupSetToReleasedCommand("RG100450")).Wait();

                //Update CRM status to AwaitingRelease for UKPRN - 10044729
                UpdateCrmReleaseStatus(new Guid("A3A03BFE-48B4-4384-822F-4CDE62DA75A7"));

                //Delete draft contract
                DeleteDraftContractfromPAAS();
            }
            catch(Exception ex)
            {

            }
        }

        private void DeleteDraftContractfromPAAS()
        {
            var connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnectionWithRetry(connectionString))
            {

                const string sql = @"delete from [FundingAllocation].[Contract]
                                 where id NOT in (select ISNULL(fa.ContractId, -1)
                                                 from [FundingAllocation].[FundingAllocation] fa)
                                 and ContractNumber = 'EDSK-5474'
                                 and ContractVersionNumber = '2'";
                
                connection.Execute(sql);
            }
        }

        private void UpdateCrmReleaseStatus(Guid crmId)
        {
            var subnominalaggregation = new sfa_releasegroup
            {
                Id = crmId,
                sfa_releasestatus = new OptionSetValue((int)sfa_ReleaseGroupStatus.AwaitingRelease),
                EntityState = EntityState.Changed
            };

            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            organizationService.Update(subnominalaggregation);
        }
    }
}
