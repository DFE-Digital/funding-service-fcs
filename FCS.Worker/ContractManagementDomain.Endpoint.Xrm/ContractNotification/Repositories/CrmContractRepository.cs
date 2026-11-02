namespace ContractManagementDomain.Endpoint.Xrm.ContractNotification.Repositories
{
    using System;
    using System.Linq;
    using Microsoft.Xrm.Sdk;
    using Dtos;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    public class CrmContractRepository : ICrmContractRepository
    {
        private readonly IOrganizationService _organizationService;

        public CrmContractRepository(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        public Guid GetLatestUserIdAssociatedWithWorkflowItemForContract(string contractNumber, int version, int subVersion, string workflowActionName)
        {
            using (XrmServiceContext xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                return (
                    from wf in xrmServiceContext.sfa_contracttransitionhistorySet
                    join c in xrmServiceContext.sfa_contractSet on wf.sfa_Contract.Id equals c.sfa_contractId.Value
                    join t in xrmServiceContext.sfa_transitionSet on wf.sfa_Action.Id equals t.sfa_transitionId.Value
                    join u in xrmServiceContext.SystemUserSet on wf.sfa_Actionby.Id equals u.SystemUserId.Value
                    where
                        c.sfa_number == contractNumber
                        && c.sfa_Version == version
                        && c.sfa_SubVersion == subVersion
                        && t.sfa_name == workflowActionName
                    select new
                    {
                        UserId = u.SystemUserId.Value,
                        TransitionHistoryCreatedOn = wf.CreatedOn
                    })
                    .ToList()
                    .OrderByDescending(u => u.TransitionHistoryCreatedOn)
                    .Select(u => u.UserId)
                    .First();
            }
        }

        public ProviderInfo GetProviderInfoForContract(string contractNumber, int version, int subVersion)
        {
            using (var xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                return (from a in xrmServiceContext.AccountSet
                        join c in xrmServiceContext.sfa_contractSet
                            on a.Id equals c.sfa_ProviderName.Id
                        where c.sfa_number == contractNumber
                           && c.sfa_Version == version
                           && c.sfa_SubVersion == subVersion
                        select new ProviderInfo(a.Name, a.sfa_UKPRN)).Single();
            }
        }

        public ProviderInfo GetProviderInfoForContract(string contractNumber, int version)
        {
            using (var xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                return (from a in xrmServiceContext.AccountSet
                        join c in xrmServiceContext.sfa_contractSet
                            on a.Id equals c.sfa_ProviderName.Id
                        where c.sfa_number == contractNumber
                           && c.sfa_Version == version
                        select new ProviderInfo(a.Name, a.sfa_UKPRN)).First();
            }
        }

        public Guid GetSpecialTaskOwnerUserForContractWithSubStatus(string contractNumber, int versionNumber, string subStatusName)
        {
            using (XrmServiceContext xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                return
                    (from c in xrmServiceContext.sfa_contractSet
                     join u in xrmServiceContext.SystemUserSet on c.sfa_specialtaskowner.Id equals u.SystemUserId.Value
                     join s in xrmServiceContext.sfa_statusSet on c.sfa_SubStatus.Id equals s.sfa_statusId.Value
                     where
                         c.sfa_number == contractNumber
                         && c.sfa_Version == versionNumber
                         && s.sfa_name == subStatusName
                     select u.SystemUserId.Value).First();
            }
        }
    }
}