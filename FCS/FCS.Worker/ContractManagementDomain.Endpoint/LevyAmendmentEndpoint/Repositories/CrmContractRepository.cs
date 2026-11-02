namespace ContractManagementDomain.Endpoint.LevyAmendmentEndpoint.Repositories
{
    using System.Collections.Generic;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.ContractManagementDomain.Integration.Dtos;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using System.Linq;

    public class CrmContractRepository : ICrmContractRepository
    {
        private readonly IOrganizationService _organizationService;

        public CrmContractRepository(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        public ContractStatusInfo GetContractStatusIfContractIsLatest(string contractNumber, int version, int subVersion)
        {
            using (var xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                return (from contract in xrmServiceContext.sfa_contractSet
                        join sfaStatus in xrmServiceContext.sfa_statusSet on contract.sfa_SubStatus.Id equals sfaStatus.Id
                        where contract.sfa_number == contractNumber
                              && contract.sfa_Version == version
                              && contract.sfa_SubVersion == subVersion
                              && contract.sfa_LatestVersion == true
                        select new
                        {
                            Status = (sfa_contractstatus)contract.sfa_ContractStatus.Value,
                            SubStatus = sfaStatus.sfa_name
                        })
                    .AsEnumerable()
                    .Select(s => new ContractStatusInfo(
                        contractStatus: TransformContractStatus(s.Status),
                        contractSubStatus: TransformContractSubStatus(s.SubStatus)))
                    .FirstOrDefault();
            }
        }

        public IReadOnlyCollection<SimpleAllocationInfo> GetAllocationsForContract(string contractNumber, int version, int subVersion)
        {
            using (XrmServiceContext context = new XrmServiceContext(_organizationService))
            {
                var allocationFsps = (from c in context.sfa_contractSet
                        join a in context.sfa_contractallocationSet on c.sfa_contractId.Value equals a.sfa_ContractId.Id
                    join fsp in context.sfa_fundingstreamperiodSet on a.sfa_FundingStreamPeriodId.Id equals fsp.sfa_fundingstreamperiodId
                    where c.sfa_number == contractNumber
                          && c.sfa_Version == version
                          && c.sfa_SubVersion == subVersion
                    select fsp.sfa_fundingstreamperiodcode).ToList();

                return allocationFsps.Select(fsp => new SimpleAllocationInfo(fsp)).ToList();
            }
        }

        private static ContractSubStatus TransformContractSubStatus(string crmSubstatus)
        {
            Dictionary<string, ContractSubStatus> statuses = new Dictionary<string, ContractSubStatus>
            {
                {"Approved", ContractSubStatus.Approved},
                {"Awaiting Closure Approval", ContractSubStatus.AwaitingClosureApproval},
                {"Closed", ContractSubStatus.Closed},
                {"Closure in Progress", ContractSubStatus.ClosureinProgress},
                {"Closure Initiation in Progress", ContractSubStatus.ClosureInitiationinProgress},
                {"Published to Provider", ContractSubStatus.PublishedtoProvider},
                {"Awaiting Termination Initiation Approval", ContractSubStatus.AwaitingTerminationInitiationApproval},
                {"Under Termination", ContractSubStatus.UnderTermination},
                {"Awaiting Modification Approval", ContractSubStatus.AwaitingModificationApproval},
                {"Modified", ContractSubStatus.Modified},
            };

            return statuses.ContainsKey(crmSubstatus) ? statuses[crmSubstatus] : ContractSubStatus.Other;
        }

        private static ContractStatus TransformContractStatus(sfa_contractstatus crmContractstatus)
        {
            Dictionary<sfa_contractstatus, ContractStatus> statuses = new Dictionary<sfa_contractstatus, ContractStatus>
            {
                {sfa_contractstatus.Approved, ContractStatus.Approved},
                {sfa_contractstatus.Closed, ContractStatus.Closed},
                {sfa_contractstatus.Draft, ContractStatus.Draft}
            };

            return statuses.ContainsKey(crmContractstatus) ? statuses[crmContractstatus] : ContractStatus.Other;
        }
    }
}