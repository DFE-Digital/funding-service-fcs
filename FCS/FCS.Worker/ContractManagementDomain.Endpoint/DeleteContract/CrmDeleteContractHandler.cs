namespace ContractManagementDomain.Endpoint.DeleteContract
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using NServiceBus;
    using Repositories;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class CrmDeleteContractHandler : IHandleMessages<DeleteContractCommand>
    {
        private readonly ILogger _logger;
        private readonly ICrmContractRepository _crmContractRepository;

        public CrmDeleteContractHandler(ILogger logger, ICrmContractRepository crmContractRepository)
        {
            _logger = logger;
            _crmContractRepository = crmContractRepository;
        }

        public async Task Handle(DeleteContractCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractManagementLoggingEvents.DeleteContractCommandReceived,
                $"DeleteContractCommand received for - {message}");

            IReadOnlyCollection<CrmContractIdentity> contractIds = _crmContractRepository.GetContractIds(message.ContractNumber, message.VersionNumber);

            var masterContractGroups = contractIds.GroupBy(c => c.MasterContractId).ToList();

            List<Guid> mastersToDelete = new List<Guid>();
            masterContractGroups.ForEach(masterContractGroup =>
            {
                if (_crmContractRepository.AreTheseChildContractsTheOnlyOnesRelatedToTheMaster(masterContractGroup.Key,
                    masterContractGroup.Select(m => m.ContractId).ToList()))
                {
                    mastersToDelete.Add(masterContractGroup.Key);
                }
            });

            // contracts initially holds child contracts then we add masters to the end
            var childContracts = contractIds.Select(c => c.ContractId).ToList();
            
            _crmContractRepository.DeleteContractsTasksAndWorkflows(childContracts);

            await context.Send(new DeleteMasterContractsCommand
            {
                RelatedChildContractNumber = message.ContractNumber,
                RelatedChildContractVersionNumber = message.VersionNumber,
                MasterContractIds = mastersToDelete
            });

            Guid? lastApprovedContractId = _crmContractRepository.GetLastApprovedContractId(message.ContractNumber);

            if (lastApprovedContractId.HasValue)
            {
                _crmContractRepository.UpdateContractToLatestVersion(lastApprovedContractId.Value);
            }

            _logger.LogInformation(ContractManagementLoggingEvents.DeleteContractCommandCompleted,
                $"DeleteContractCommand completed for - {message}");
        }
    }
}