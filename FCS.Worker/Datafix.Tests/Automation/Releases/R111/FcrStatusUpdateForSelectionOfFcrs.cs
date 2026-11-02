namespace Datafix.Tests.Automation.Releases.R111
{
    using System;
    using System.Linq;
    using Microsoft.Xrm.Sdk;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using System.Collections.Generic;

    public class FcrStatusUpdateForSelectionOfFcrs : IApplyDataFix
    {
        public string Release => "R111";

        public int StoryNumber => 35893;

        public string Name => "Update selection of FCRs to manually published";

        public int Order => 1;

        public void ApplyDataFix()
        {
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            GetFcrIds(organizationService).ToList().ForEach(fcrId =>
                UpdateStatusAndSubStatus(fcrId,
                    sfa_sfastatuscode.Published,
                    sfa_sfasubstatuscode.ManuallyPublished,
                    organizationService));
        }

        private static IEnumerable<Guid> GetFcrIds(IOrganizationService organizationService)
        {
            var sfaPeriodId = GetFundingPeriodIdFromCrm(organizationService, "AY2021");
            var sfaClaimTypeId = GetClaimTypeIdFromCrm(organizationService, "Year End");

            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                return context.sfa_fundingclaimreconciliationSet
                    .Where(fcr => fcr.sfa_StatusCode.Value == (int)sfa_sfastatuscode.Draft)
                    .Where(fcr => fcr.sfa_FundingPeriodId.Id != sfaPeriodId ||
                                  fcr.sfa_ClaimTypeId.Id == sfaClaimTypeId)
                    .Select(fcr => fcr.Id)
                    .ToList();
            }
        }

        private static Guid GetFundingPeriodIdFromCrm(IOrganizationService organizationService, string periodName)
        {
            using (var context = new XrmServiceContext(organizationService))
            {
                return context.sfa_periodSet
                    .Where(p => p.sfa_periodname == periodName)
                    .Select((p => p.Id)).Single();
            }
        }

        private static Guid GetClaimTypeIdFromCrm(IOrganizationService organizationService, string claimTypeName)
        {
            using (var context = new XrmServiceContext(organizationService))
            {
                return context.sfa_claimtypeSet
                    .Where(ct =>ct.sfa_name == claimTypeName)
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
        }
    }
}