namespace ContractCreateDomain.Endpoint.NonFinancialAmendment.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Dtos;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Common.Extensions;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    public class CrmContractRepository : ICrmContractRepository
    {
        private readonly IOrganizationService _orgService;
        private static Guid? _approvedStatus;

        public CrmContractRepository(IOrganizationService orgService)
        {
            _orgService = orgService;
        }

        public bool IsContractApproved(string contractNumber, int versionNumber, int subversionNumber)
        {
            using (var xrmServiceContext = new XrmServiceContext(_orgService))
            {
                return
                    xrmServiceContext.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber && c.sfa_Version == versionNumber && c.sfa_SubVersion == subversionNumber)
                    .Where(c => c.sfa_ContractStatus.Value == (int)sfa_contractstatus.Approved && c.sfa_SubStatus.Id == GetApprovedStatus())
                    .Select(c => c.Id)
                    .ToList()
                    .Any();
            }
        }

        public bool IsContractApprovedWithSubstatus(string contractNumber, int versionNumber, int subversionNumber, string[] substatuses)
        {
            using (var xrmServiceContext = new XrmServiceContext(_orgService))
            {
                return (from c in xrmServiceContext.sfa_contractSet
                        join s in xrmServiceContext.sfa_statusSet
                            on c.sfa_SubStatus.Id equals s.sfa_statusId
                        where c.sfa_number == contractNumber
                              && c.sfa_Version == versionNumber
                              && c.sfa_SubVersion == subversionNumber
                              && c.sfa_ContractStatus.Value == (int)sfa_contractstatus.Approved
                        select s.sfa_name)
                    .ToList()
                    .Any(substatuses.Contains);
            }
        }

        public void SetNonFinancialAmendmentFailedServiceResponseOnContract(string contractNumber, int versionNumber, int subVersionNumber)
        {
            using (var xrmServiceContext = new XrmServiceContext(_orgService))
            {
                var contractId = xrmServiceContext.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber && c.sfa_Version == versionNumber && c.sfa_SubVersion == subVersionNumber)
                    .Select(c => c.sfa_contractId)
                    .FirstOrDefault();

                if (contractId != null)
                {
                    sfa_contract contract = new sfa_contract
                    {
                        sfa_contractId = contractId,
                        sfa_ServiceResponse = new OptionSetValue((int)sfa_serviceresponse.NonFinancialAmendmentInitiationFailed)
                    };

                    _orgService.Update(contract);
                }
            }
        }

        public bool IsThereNoSubsequentDraftContracts(string contractNumber, int versionNumber, int subversionNumber)
        {
            using (var xrmServiceContext = new XrmServiceContext(_orgService))
            {
                List<ContractInformation> contractInformations =
                    xrmServiceContext.sfa_contractSet
                        .Where(c => c.sfa_number == contractNumber)
                        .Select(c =>
                            new ContractInformation(
                                c.sfa_number,
                                c.sfa_Version.Value,
                                c.sfa_SubVersion.Value,
                                (sfa_contractstatus)c.sfa_ContractStatus.Value))
                        .ToList();

                if (!contractInformations.Any())
                {
                    throw new ArgumentException("Contract does not exist in CRM");
                }

                return contractInformations
                        .Where(c => (c.VersionNumber > versionNumber || c.SubVersionNumber > subversionNumber)
                                 && c.ContractStatus == sfa_contractstatus.Draft)
                        .ToList()
                        .Empty();
            }
        }

        public FundingTypeFundingPeriodKey GetFundingTypeFundingPeriodKeyForGivenContract(string contractNumber, int versionNumber, int subversionNumber)
        {
            using (XrmServiceContext xrmServiceContext = new XrmServiceContext(_orgService))
            {
                FundingTypeFundingPeriodKey fundingTypeFundingPeriodKeyDto =
                    (from c in xrmServiceContext.sfa_contractSet
                     join ft in xrmServiceContext.sfa_fundingtypeSet on c.sfa_FundingType.Id equals ft.Id
                     join p in xrmServiceContext.sfa_periodSet on c.sfa_PeriodId.Id equals p.Id
                     where c.sfa_number == contractNumber && c.sfa_Version == versionNumber && c.sfa_SubVersion == subversionNumber
                     select new FundingTypeFundingPeriodKey(ft.sfa_fundingtypecode, p.sfa_periodname))
                     .Single();
                return fundingTypeFundingPeriodKeyDto;
            }
        }

        public bool HasSiblingContractWithDraftStatusOrAmendmentCreationInProgress(string contractNumber)
        {
            using (XrmServiceContext xrmServiceContext = new XrmServiceContext(_orgService))
            {
                var parentContractId  = xrmServiceContext.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber)
                    .Select(c => c.sfa_ParentContractId.Id)
                    .First();

                return (from c in xrmServiceContext.sfa_contractSet
                    where c.sfa_ParentContractId.Id == parentContractId &&
                          c.sfa_LatestVersion == true &&
                          (c.sfa_ContractStatus.Value == (int)sfa_contractstatus.Draft || c.sfa_nfainprogress == true) &&
                          c.sfa_number != contractNumber
                    select c.sfa_number).ToList().Any();
            }
        }

        private Guid GetApprovedStatus()
        {
            if (_approvedStatus == null)
            {
                using (var xrmContext = new XrmServiceContext(_orgService))
                {
                    _approvedStatus = xrmContext.sfa_statusSet.Where(s => s.sfa_name == "Approved").Select(s => s.Id).Single();
                }
            }
            return _approvedStatus.Value;
        }
    }
}
