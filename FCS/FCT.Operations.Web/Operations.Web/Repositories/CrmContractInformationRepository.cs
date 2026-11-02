namespace Operations.Web.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Dtos;
    using Infrastructure;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    public class CrmContractInformationRepository : ICrmContractInformationRepository
    {
        public async Task<bool> CleanupContractData(IReadOnlyCollection<ContractCleanup> contractData)
        {
            bool result = false;
            foreach (var contract in contractData)
            {
                if (contract.CrmEntityId != null)
                    result = await DeleteFromsfa_fundingallocationsSet(contract.AllocationFundingStream, contract.CrmEntityId, contract.FundingId);
                if (contract.ContractNumber != null)
                    result =  await DeleteFromsfa_contractSet(contract.ContractNumber, contract.ContractVersionNumber, contract.ContractSubVersionNumber);
            }
            return result;
        }

        public static Task<bool> DeleteFromsfa_fundingallocationsSet(string allocationfundingstream, Guid fundingCRMID, string fundingId)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            try
            {
                using (XrmServiceContext context = new XrmServiceContext(organizationService))
                {
                    var res = (
                         from c in context.sfa_fundingallocationSet
                         where
                         c.Id == fundingCRMID && c.sfa_allocationfundingstream == allocationfundingstream //&& c.sfa_fundingallocationId == new Guid(fundingId)
                         select c
                     )
                     .ToList();

                    organizationService.Delete(sfa_fundingallocation.EntityLogicalName, res.First().Id);

                }
            }
            catch (Exception ex) { return System.Threading.Tasks.Task.FromResult(false); }
            return System.Threading.Tasks.Task.FromResult(true);
        }

        public static Task<bool> DeleteFromsfa_contractSet(string contractnumber, int? contractversion, int? contractsubversion)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            try
            {
                using (XrmServiceContext context = new XrmServiceContext(organizationService))
                {
                    var res = (
                         from c in context.sfa_contractSet
                         where
                         c.sfa_number == contractnumber && c.sfa_Version == contractversion && c.sfa_SubVersion == contractsubversion
                         select c.sfa_contractId.Value
                     )
                     .ToList();
                    organizationService.Delete(sfa_contract.EntityLogicalName, res.First());

                }
            }
            catch (Exception ex) { return System.Threading.Tasks.Task.FromResult(false); }
            return System.Threading.Tasks.Task.FromResult(true);
        }

        public static void DeleteFromsfa_releasegroupSet(string reelasename)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();


            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                var res = (
                     from c in context.sfa_releasegroupSet
                     where
                     c.sfa_name == reelasename //&& c.sfa_allocationfundingstream == "LOANS"
                     select c
                 )
                 .ToList();

                organizationService.Delete(sfa_releasegroup.EntityLogicalName, res.First().Id);

            }


        }

        public IReadOnlyCollection<ContractInformation> GetLatestContractInformationByFundingTypeAndFundingPeriod(string fundingTypeCode, string fundingPeriodCode)
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetOrganizationService()))
            {
                var contracts = (
                    from contract in context.sfa_contractSet
                    join master in context.sfa_contractSet on contract.sfa_ParentContractId.Id equals master.Id
                    join period in context.sfa_periodSet on contract.sfa_PeriodId.Id equals period.Id
                    join fundingType in context.sfa_fundingtypeSet on contract.sfa_FundingType.Id equals fundingType.Id
                    join sfaStatus in context.sfa_statusSet on contract.sfa_SubStatus.Id equals sfaStatus.Id
                    where fundingType.sfa_fundingtypecode == fundingTypeCode
                          && period.sfa_periodname == fundingPeriodCode
                          && contract.sfa_HierarchyType.Value == (int)sfa_contracthierarchytype.Contract
                          && contract.sfa_LatestVersion == true
                    select new { Contract = contract, Substatus = sfaStatus.sfa_name, MasterNumber = master.sfa_number }
                    )
                    .ToList();

                return contracts
                   .Select(contract => new ContractInformation(
                       contract.Contract.sfa_number,
                       contract.MasterNumber,
                       contract.Contract.sfa_Version.Value,
                       contract.Contract.sfa_SubVersion.Value,
                       contract.Contract.sfa_UKPRN,
                       ((sfa_contractstatus)contract.Contract.sfa_ContractStatus.Value).ToString(),
                       contract.Substatus)
                       )
                   .ToList();
            }
        }


    }
}