namespace Datafix.Tests.Automation.Releases.R99c
{
    using System.Linq;
    using Datafix.Tests.Repositories;
    using Microsoft.Xrm.Sdk;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class CrmContractTypeForNLGContracts : IApplyDataFix
    {
        public string Release => "R99c";
        public int StoryNumber => 32693;
        public string Name => "Datafix Contract Type for Funding Type Non-learning Grants";
        public int Order => 1;

        public void ApplyDataFix()
        {
            var contractIdsToUpdate =
                CrmContractInformationRepository.GetContractIdsWithAnEmptyContractTypeForFundingType("NLG");

            var contractTypeId = CrmContractTypeRepository.GetContractTypeId("Non-learning Grant");

            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            contractIdsToUpdate.Select(id => new sfa_contract
            {
                Id = id,
                sfa_ContractType = new EntityReference(sfa_contracttype.EntityLogicalName, contractTypeId)
            }).ToList().ForEach(c =>
            {
                organizationService.Update(c);
            });
        }
    }
}
