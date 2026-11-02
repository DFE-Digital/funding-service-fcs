namespace Datafix.Tests.Automation.Releases.R111a
{
    using System.Linq;
    using Datafix.Tests.Repositories;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class RemoveDuplicateCdpRowFromCrm : IApplyDataFix
    {
        public string Release => "R111a";

        public int StoryNumber => 36020;

        public string Name => "Remove duplicate cdp row from CRM";

        public int Order => 1;

        public void ApplyDataFix()
        {
            var ids = CrmContractDeliverablePeriodRepository.GetCdpIdsLatestAllocation("LEVY-5186", 8, "Dec-21");

            if (ids.Count == 2)
            {
                var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
                organizationService.Delete(sfa_contractdeliverableperiod.EntityLogicalName, ids.First());
            }
        }
    }
}
