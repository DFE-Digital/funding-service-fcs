namespace Datafix.Tests.Repositories
{
    using System;
    using System.Linq;
    using Microsoft.Xrm.Sdk;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    public static class FundingClaimReconciliationRepository
    {
        public static void UpdateStatusAndSubStatus(int ukprn, sfa_sfastatuscode fcrStatus, sfa_sfasubstatuscode fcrSubStatus, string nameStartsWith)
        {
            var id = GetFcrId(ukprn.ToString(), nameStartsWith);

            sfa_fundingclaimreconciliation fcrToUpdate = new sfa_fundingclaimreconciliation
            {
                Id = id,
                sfa_StatusCodeEnum = fcrStatus,
                sfa_substatusEnum = fcrSubStatus,
                sfa_StatusLastUpdatedDate = DateTime.Now
            };

            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            organizationService.Update(fcrToUpdate);
        }

        private static Guid GetFcrId(string ukprn, string nameStartsWith)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                return context.sfa_fundingclaimreconciliationSet.Where(fcr => fcr.sfa_ukprn == ukprn)
                    .ToList()
                    .Where(fcr => fcr.sfa_name.StartsWith(nameStartsWith))
                    .OrderByDescending(fcr => fcr.CreatedOn)
                    .Single().sfa_fundingclaimreconciliationId.Value;
            }
        }
    }
}
