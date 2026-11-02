namespace ContractManagementDomain.Endpoint.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Extensions;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.ContractManagementDomain.Integration.Dtos;
    using SFA.FCT.ContractManagementService.Common.Dtos;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    public class CrmContractRepository : ICrmContractRepository
    {
        private readonly IOrganizationService _organizationService;

        public CrmContractRepository(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        public void UpdateStartDate(Guid contractId, DateTime startDateTime)
        {
            sfa_contract contract = new sfa_contract
            {
                Id = contractId,
                sfa_StartDate = startDateTime,
                EntityState = EntityState.Changed
            };

            _organizationService.Update(contract);
        }

        public FundingTypeFundingPeriodKeyDto GetFundingTypeFundingPeriodKeyDtoForLatestContract(string contractNumber, int versionNumber)
        {
            using (XrmServiceContext xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                FundingTypeFundingPeriodKeyDto fundingTypeFundingPeriodKeyDto =
                    (from c in xrmServiceContext.sfa_contractSet
                     join ft in xrmServiceContext.sfa_fundingtypeSet on c.sfa_FundingType.Id equals ft.Id
                     join p in xrmServiceContext.sfa_periodSet on c.sfa_PeriodId.Id equals p.Id
                     where c.sfa_number == contractNumber && c.sfa_Version == versionNumber && c.sfa_LatestVersion == true
                     select new FundingTypeFundingPeriodKeyDto(ft.sfa_fundingtypecode, p.sfa_periodname))
                     .Single();
                return fundingTypeFundingPeriodKeyDto;
            }
        }

        public bool HasContractBeenApproved(string contractNumber)
        {
            using (XrmServiceContext xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                return
                    (from c in xrmServiceContext.sfa_contractSet
                     where c.sfa_number == contractNumber && c.sfa_LastApprovedVersion == true
                     select c.Id)
                    .ToList()
                    .Any();
            }
        }

        public ContractEndDateInfo GetContractEndDateInfoByContractNumberVersionAndSubVersion(string contractNumber, int version, int subVersion)
        {
            using (var xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                var contract = xrmServiceContext.sfa_contractSet
                        .Where(c => c.sfa_number == contractNumber
                                 && c.sfa_Version == version
                                 && c.sfa_SubVersion == subVersion)
                        .Select(c => new { Id = c.sfa_contractId, EndDate = c.sfa_EndDate })
                        .SingleOrDefault();

                return new ContractEndDateInfo(contract?.EndDate, isContractPresent: contract != null);
            }
        }

        public void UpdateServiceResponseOnContract(string contractNumber, int version, int subVersion, sfa_serviceresponse serviceresponse)
        {
            sfa_contract contract = new sfa_contract
            {
                Id = GetContractId(contractNumber, version, subVersion),
                sfa_ServiceResponse = new OptionSetValue((int)serviceresponse)
            };

            _organizationService.Update(contract);
        }

        public bool IsContractLatestVersion(string contractNumber, int version, int subVersion)
        {
            using (var xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                return xrmServiceContext.sfa_contractSet
                        .Where(c => c.sfa_number == contractNumber
                                 && (c.sfa_Version > version || c.sfa_SubVersion > subVersion)
                                 && c.sfa_ContractStatus.Value == (int)sfa_contractstatus.Draft)
                        .Select(c => c.Id)
                        .ToList()
                        .Empty();
            }
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

        public bool LastApprovedContractDoesNotIncludeAllocation(string contractNumber, string fundingStreamPeriodCode)
        {
            using (var xrmContext = new XrmServiceContext(_organizationService))
            {
                return (from c in xrmContext.sfa_contractSet
                    join a in xrmContext.sfa_contractallocationSet on c.sfa_contractId equals a.sfa_ContractId.Id
                    join fsp in xrmContext.sfa_fundingstreamperiodSet on a.sfa_FundingStreamPeriodId.Id equals fsp.sfa_fundingstreamperiodId
                    where c.sfa_number == contractNumber && 
                          c.sfa_LastApprovedVersion == true  && 
                          fsp.sfa_fundingstreamperiodcode == fundingStreamPeriodCode
                          select fsp.Id)
                    .ToList().Empty();
            }
        }

        public bool LatestContractIncludesAllocation(string contractNumber, string fundingStreamPeriodCode)
        {
            using (var xrmContext = new XrmServiceContext(_organizationService))
            {
                return (from c in xrmContext.sfa_contractSet
                        join a in xrmContext.sfa_contractallocationSet on c.sfa_contractId equals a.sfa_ContractId.Id
                        join fsp in xrmContext.sfa_fundingstreamperiodSet on a.sfa_FundingStreamPeriodId.Id equals fsp.sfa_fundingstreamperiodId
                        where c.sfa_number == contractNumber &&
                              c.sfa_LatestVersion == true &&
                              fsp.sfa_fundingstreamperiodcode == fundingStreamPeriodCode
                        select fsp.Id)
                    .ToList().Any();
            }
        }

        public Guid GetContractId(string contractNumber, int version, int subVersion)
        {
            using (XrmServiceContext xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                return xrmServiceContext.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber && c.sfa_Version == version && c.sfa_SubVersion == subVersion)
                    .Select(c => c.Id)
                    .Single();
            }
        }

        public bool IsContractClosed(string contractNumber)
        {
            using (XrmServiceContext xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                return xrmServiceContext.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber && c.sfa_ContractStatus.Value == (int)sfa_contractstatus.Closed)
                    .Select(c => c.Id)
                    .ToList()
                    .Any();
            }
        }

        public void UpdateContract(sfa_contract contract)
        {
            _organizationService.Update(contract);
        }

        public IReadOnlyCollection<Guid> GetAllocationIdsForContract(string contractNumber, int version, int subVersion)
        {
            using (XrmServiceContext xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                return
                    (from a in xrmServiceContext.sfa_contractallocationSet
                     join c in xrmServiceContext.sfa_contractSet on a.sfa_ContractId.Id equals c.Id
                     where c.sfa_number == contractNumber && c.sfa_Version == version && c.sfa_SubVersion == subVersion
                     select a.Id)
                    .ToList();
            }
        }

        public string GetMasterContractNumber(string contractNumber, int version, int subversion)
        {
            using (XrmServiceContext xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                List<string> masterContractNumber =
                    (from m in xrmServiceContext.sfa_contractSet
                     join c in xrmServiceContext.sfa_contractSet on m.sfa_contractId equals c.sfa_ParentContractId.Id
                     where c.sfa_number == contractNumber && c.sfa_Version == version && c.sfa_SubVersion == subversion
                     select m.sfa_number).ToList();

                return masterContractNumber.Single();
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
                {"Under Termination", ContractSubStatus.UnderTermination}
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
