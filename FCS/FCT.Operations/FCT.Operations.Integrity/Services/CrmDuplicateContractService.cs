namespace SFA.FCT.Operations.Integrity.Services
{
    using Repositories;
    using System.Linq;
    using System.Collections.Generic;
    using DTOs;
    using Framework.Logging.Interfaces;
    using SFA.FCT.CrossDomain.Integration.Common.Slack;

    public class CrmDuplicateContractService : ICrmDuplicateContractService
    {
        private readonly ICrmDuplicateContractRepository _crmDuplicateContractRepository;
        private readonly IDuplicateContractRepository _duplicateContractRepository;

        public CrmDuplicateContractService(ICrmDuplicateContractRepository crmDuplicateContractRepository, IDuplicateContractRepository duplicateContractRepository)
        {
            _crmDuplicateContractRepository = crmDuplicateContractRepository;
            _duplicateContractRepository = duplicateContractRepository;
        }

        public void IdentifyNewDuplicateContracts(ILogger logger)
        {
            var newDuplicatedContracts = _crmDuplicateContractRepository.GetDuplicatedContracts();
            var oldDuplicatedContracts = _duplicateContractRepository.GetDuplicatedContracts();

             if (AreDifferent(newDuplicatedContracts, oldDuplicatedContracts))
             {
                 _duplicateContractRepository.RefreshDuplicatedContracts(newDuplicatedContracts);

                 if (HasNewDuplicates(newDuplicatedContracts, oldDuplicatedContracts))
                 {
                     SlackNotifier.SendMessage("Duplicate Contracts or Allocations in CRM", logger);
                 }
             }
        }

        private static bool AreDifferent(IReadOnlyCollection<DuplicateContract> listOne,IReadOnlyCollection<DuplicateContract> listTwo)
        {
            return listOne.Any(n => !listTwo.Contains(n)) || listTwo.Any(n => !listOne.Contains(n));
        }

        private static bool HasNewDuplicates(IReadOnlyCollection<DuplicateContract> newDuplicatedContracts, IReadOnlyCollection<DuplicateContract> oldDuplicatedContracts)
        {
            return newDuplicatedContracts.Any(n => !oldDuplicatedContracts.Contains(n));
        }
    }
}