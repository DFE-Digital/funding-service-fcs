namespace Datafix.Tests.Automation.Releases.R98
{
    using System.Collections.Generic;
    using System.Linq;
    using Datafix.Tests.Repositories;
    using Dtos;
    using Microsoft.Xrm.Sdk;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    public class UpdateUnderTerminationContractsInCrm : IApplyDataFix
    {
        public string Release => "R98";
        public int StoryNumber => 31496;
        public string Name => "Adjust termination details data profiles in contracts under termination in production";
        public int Order => 2;
        
        public void ApplyDataFix()
        {
            var contractsUnderTermination = CrmContractInformationRepository.GetContractTerminationInfos("Under Termination", sfa_contractstatus.Approved);

            UpdateAllTerminationInfo(contractsUnderTermination);
        }

        private void UpdateAllTerminationInfo(IReadOnlyCollection<CrmContractTerminationInfo> contracts)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            contracts.Select(ToCrmContract)
                .ToList()
                .ForEach(c =>
                {
                    organizationService.Update(c);
                });

            contracts.SelectMany(ToCrmAllocations)
                .ToList()
                .ForEach(a =>
                {
                    organizationService.Update(a);
                });
        }

        private static sfa_contract ToCrmContract(CrmContractTerminationInfo contractTerminationInfo)
        {
            return new sfa_contract
            {
                Id = contractTerminationInfo.ContractId,
                sfa_inflightterminationdate = contractTerminationInfo.TerminationDate,
                sfa_inflightterminationreason = contractTerminationInfo.TerminationReason,
                sfa_inflightstopnewstartsdate = null,
                sfa_defaultstopnewstartsdate = null,
                sfa_inflightterminationcomments = null,
                sfa_terminationcomments = null
            };
        }

        private static IReadOnlyCollection<sfa_contractallocation> ToCrmAllocations(CrmContractTerminationInfo contractTerminationInfo)
        {
            return contractTerminationInfo.Allocations.Select(a => new sfa_contractallocation
            {
                Id = a.AllocationId,
                sfa_inflightstopnewstartsdate = a.StopNewStartsDate,
                sfa_inflightterminationdate = a.TerminationDate
            }).ToList();
        }
    }
}
