using DocumentFormat.OpenXml.Spreadsheet;
using Operations.Web.Dtos;
using Operations.Web.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;

namespace Operations.Web.Services
{
    public class ContractCleanupService : IContractCleanupService
    {
        private readonly ICrmContractInformationRepository _crmcontractInformationRepository;
        private readonly IContractAtomFeedQueryRepository _contractInformationRepository;
        public ContractCleanupService(IContractAtomFeedQueryRepository contractAtomFeedQueryRepository, ICrmContractInformationRepository crmContractInformationRepository)
        {
            _contractInformationRepository = contractAtomFeedQueryRepository;
            _crmcontractInformationRepository = crmContractInformationRepository;
        }
        public async Task<string> CleanContractData(List<string> fundingIds)
        {
            IReadOnlyCollection<ContractCleanup> approvedContractData = await _contractInformationRepository.GetApprovedContractData(fundingIds);

            if (approvedContractData.Count > 0)
            {
                return "Few funding Ids either in approved or withdraw state : " + string.Join(", ", approvedContractData.Select(x => x.FundingId));
            }
            IReadOnlyCollection<ContractCleanup> CRMData = await _contractInformationRepository.GetContractData(fundingIds);

            //Clean PaaS table

            var PaaSCleanup = await CleanPaaSDB(CRMData);

            if (PaaSCleanup)
            {
                //Clean CRM table
                var crmCleanup = await CleanCRMDB(CRMData);
                if (crmCleanup)
                {
                    return "PaaS and CRM Data Cleared";
                }
                else if (PaaSCleanup)
                {
                    return "Only PaaS Data Cleared";
                }
            }
            return "Data not cleaned up! Please try again later!!";
        }

        private async Task<bool> CleanPaaSDB(IReadOnlyCollection<ContractCleanup> contractsdata)
        {
            return await _contractInformationRepository.CleanupContractData(contractsdata);
        }

        private async Task<bool> CleanCRMDB(IReadOnlyCollection<ContractCleanup> contractData)
        {
            return await _crmcontractInformationRepository.CleanupContractData(contractData);
        }
    }
}