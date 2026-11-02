namespace Datafix.Tests.Automation.Releases.R86
{
    using System.Linq;
    using Datafix.Tests.Repositories;

    public class ReseedApprovedContractTableWithReplacedContracts : IApplyDataFix
    {
        private readonly ICrmContractInformationRepository _crmContractInformationRepository;

        public ReseedApprovedContractTableWithReplacedContracts()
        {
            _crmContractInformationRepository = new CrmContractInformationRepository();
        }

        public string Release => "R86";

        public int StoryNumber => 30031;

        public string Name => "Reseed the Approved Contract table with replaced contracts";

        public int Order => 2;

        public void ApplyDataFix()
        {
            var replacedContracts = _crmContractInformationRepository
                .GetReplacedContracts();

            replacedContracts.ToList().ForEach(ApprovedContractRepository.InsertContractIfNotExists);
        }
    }
}
