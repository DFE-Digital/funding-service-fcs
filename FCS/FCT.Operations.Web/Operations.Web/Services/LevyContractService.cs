namespace Operations.Web.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Dtos;
    using Repositories;

    public class LevyContractService : ILevyContractService
    {
        private static readonly IReadOnlyCollection<string> StatusesThatCannotBeAmended = new List<string> { "Closed" };
        private static readonly IReadOnlyCollection<string> SubStatusesForTerminationModificationOrClosureInProgress = new List<string>
        {
            "Awaiting Closure Approval",
            "Closure Initiation in Progress",
            "Awaiting Termination Initiation Approval",
            "Awaiting Modification Approval"
        };

        private readonly ICrmContractInformationRepository _contractInformationRepository;
        private readonly IRoatpUkprnRepository _roatpUkprnRepository;

        public LevyContractService(ICrmContractInformationRepository contractInformationRepository, IRoatpUkprnRepository roatpUkprnRepository)
        {
            _contractInformationRepository = contractInformationRepository;
            _roatpUkprnRepository = roatpUkprnRepository;
        }

        public IReadOnlyCollection<ContractInformation> GetLevyContractsThatCannotBeAmended()
        {
            const string levyFundingType = "LEVY";
            const string levyFundingPeriod = "LEVY1799";
            

            IReadOnlyCollection<ContractInformation> levyContracts = _contractInformationRepository
                .GetLatestContractInformationByFundingTypeAndFundingPeriod(
                fundingTypeCode: levyFundingType,
                fundingPeriodCode: levyFundingPeriod);

            IReadOnlyCollection<string> validUkprns = _roatpUkprnRepository.GetValidUkprns();

            return levyContracts
                .Where(lc => IsInvalid(lc.Ukprn, validUkprns) || SubStatusesForTerminationModificationOrClosureInProgress.Contains(lc.ContractSubStatus))
                .Where(HasAmendableStatus)
                .ToList();
        }

        private static bool IsInvalid(string ukprn, IReadOnlyCollection<string> validUkprns) => !validUkprns.Contains(ukprn);

        private static bool HasAmendableStatus(ContractInformation ci) => !StatusesThatCannotBeAmended.Contains(ci.ContractStatus);

        public Task<bool> GetEngagementWatcherWebJobStatus()
        {
            return _roatpUkprnRepository.GetStatusOfEngagmenetWatcherWebjob("EngagmenetWatcherWebjob");
        }
        public void UpdateStatusOfEngagementWatcherWebJobStatus(bool enabled, string username)
        {
            _roatpUkprnRepository.UpdateStatusOfEngagementWatcherWebJobStatus("EngagmenetWatcherWebjob", enabled, username);
        }
    }
}