using Microsoft.Xrm.Sdk;
using SFA.FCS.Worker.Common.Crm;
using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Datafix.Tests.Infrastructure;
using System.Configuration;

namespace Datafix.Tests.Automation.Releases.R170
{
    public class FcrStatusUpdateForSelectedFcrsIApplyDataFix :IApplyDataFix
    {
        public string Release => "R170";

        public int StoryNumber => 45783;

        public string Name => "Update selection of FCRs to manually published";

        public int Order => 1;

        public void ApplyDataFix()
        {
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            GetFcrIds(organizationService).ToList().ForEach(fcrId =>
                UpdateStatusAndSubStatus(fcrId,
                    sfa_sfastatuscode.Draft,
                    sfa_sfasubstatuscode.Draft,
                    organizationService));

            //Delete ATOM feed from [PerformanceManagement].[AtomFeedItem] Table
            DeleteATOMFeedFromPAAS();
        }

        private static IEnumerable<Guid> GetFcrIds(IOrganizationService organizationService)
        {
            var sfaPeriodId = GetFundingPeriodIdFromCrm(organizationService, "AY2324");
            var sfaClaimTypeId = GetClaimTypeIdFromCrm(organizationService, "Final");

            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                return context.sfa_fundingclaimreconciliationSet
                    .Where(fcr => fcr.sfa_StatusCode.Value == (int)sfa_sfastatuscode.Published)
                    .Where(fcr => fcr.sfa_FundingPeriodId.Id == sfaPeriodId &&
                                  fcr.sfa_ClaimTypeId.Id == sfaClaimTypeId &&
                                  fcr.ModifiedOn > new DateTime(2024,11,13) &&
                                  fcr.ModifiedOn < new DateTime(2024, 11, 16))
                    .Select(fcr => fcr.Id)
                    .ToList();
            }
        }

        private static Guid GetFundingPeriodIdFromCrm(IOrganizationService organizationService, string periodName)
        {
            using (var context = new XrmServiceContext(organizationService))
            {
                var data = context.sfa_periodSet.ToList();
                return context.sfa_periodSet
                    .Where(p => p.sfa_periodname == periodName)
                    .Select((p => p.Id)).Single();
            }
        }
        private readonly List<string> _providerList = new List<string>()
        {
            "10002107",
            "10003753",
            "10007427",
            "10007578",
            "10007928",
            "10065150"
        };
        private static Guid GetClaimTypeIdFromCrm(IOrganizationService organizationService, string claimTypeName)
        {
            using (var context = new XrmServiceContext(organizationService))
            {
                return context.sfa_claimtypeSet
                    .Where(ct => ct.sfa_name == claimTypeName)
                    .Select((ct => ct.Id)).Single();
            }
        }

        private static void UpdateStatusAndSubStatus(Guid fcrId, sfa_sfastatuscode fcrStatus, sfa_sfasubstatuscode fcrSubStatus, IOrganizationService organizationService)
        {
            sfa_fundingclaimreconciliation fcrToUpdate = new sfa_fundingclaimreconciliation
            {
                Id = fcrId,
                sfa_StatusCodeEnum = fcrStatus,
                sfa_substatusEnum = fcrSubStatus,
                sfa_StatusLastUpdatedDate = DateTime.Now
            };

            organizationService.Update(fcrToUpdate);

            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                var ukprn = context.sfa_fundingclaimreconciliationSet
                    .Where(fcr => fcr.Id == fcrId)
                    .Select(fcr => fcr.sfa_ukprn).FirstOrDefault();
            }            
        }

        private void DeleteATOMFeedFromPAAS()
        {
            var connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnectionWithRetry(connectionString))
            {
                const string sql = @"Delete  [PerformanceManagement].[AtomFeedItem] where ClaimTypeName = 'Final' 
                                    and Period = '2324' 
                                    and AllocationGroupName = 'AEB (Grant) - Adult Skills and Community Learning 23/24' 
                                    and Ukprn in (
                                                    '10002107',
                                                    '10003753',
                                                    '10007427',
                                                    '10007578',
                                                    '10007928',
                                                    '10065150'
                                                 )";

                connection.Execute(sql);
            }
        }
    }
}
