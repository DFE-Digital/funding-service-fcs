namespace Datafix.Tests.Automation.Releases.R86
{
    using System.Linq;
    using Datafix.Tests.Repositories;

    public class ReseedCreatedContractTableWithAmendmentType : IApplyDataFix
    {
        private readonly ICrmContractInformationRepository _crmContractInformationRepository;

        public ReseedCreatedContractTableWithAmendmentType()
        {
            _crmContractInformationRepository = new CrmContractInformationRepository();
        }

        public ReseedCreatedContractTableWithAmendmentType(ICrmContractInformationRepository crmContractInformationRepository)
        {
            _crmContractInformationRepository = crmContractInformationRepository;
        }

        public string Release => "R86";

        public int StoryNumber => 30031;

        public string Name => "Reseed the Created Contract table including Amendment Type";

        public int Order => 1;

        public void ApplyDataFix()
        {
            CreatedContractRepository.ClearCreatedContractTable();

            var contracts = _crmContractInformationRepository
                .GetLastApprovedAndLatestVersionContractsWithoutDuplicates();

            contracts.ToList().ForEach(CreatedContractRepository.InsertCreatedContract);
        }
    }
}
