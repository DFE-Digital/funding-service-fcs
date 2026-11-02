namespace DocumentsDomain.Endpoint.ArchiveDocument
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Infrastructure;
    using NServiceBus;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.DocumentsDomain.Common;
    using SFA.FCT.DocumentsDomain.Common.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using FctFile = SFA.FCT.DocumentsDomain.Common.Models.FctFile;

    public class ContractApprovedAndWithdrawnHandler :
        IHandleMessages<ContractApprovedEvent>,
        IHandleMessages<ContractWithdrawnEvent>
    {
        private readonly ILogger _logger;
        private readonly IArchiveFileOrchestrator _archiveFileOrchestrator;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly IPolicyQueryService _policyQueryService;

        public ContractApprovedAndWithdrawnHandler(
            ILogger logger,
            IArchiveFileOrchestrator archiveFileOrchestrator,
            ISessionConnectionFactory sessionConnectionFactory,
            IPolicyQueryService policyQueryService)
        {
            _logger = logger;
            _archiveFileOrchestrator = archiveFileOrchestrator;
            _sessionConnectionFactory = sessionConnectionFactory;
            _policyQueryService = policyQueryService;
        }

        public async Task Handle(ContractApprovedEvent message, IMessageHandlerContext context)
        {
            string amendmentType = message.CorporateContract.contracts.First().amendmentType;

            _logger.LogInformation(DocumentsDomainLoggingEventId.ContractApprovedHandlerStarted,
                $"Documents ContractApprovedAndWithdrawnHandler ContractApprovedEvent - Started: {message}, {amendmentType}");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);
            bool shouldGenerateDocumentationForContract = await _policyQueryService.ShouldGenerateDocumentationForContract(message.CorporateContract, connectionInfo)
                .ConfigureAwait(false);

            if (shouldGenerateDocumentationForContract)
            {
                IReadOnlyCollection<FileInfo> fileInfos = GetFilesToBeDeletedAndArchived(message.CorporateContract);

                _logger.LogInformation(DocumentsDomainLoggingEventId.ContractApprovedHandlerStarted,
                    $"Documents ContractApprovedAndWithdrawnHandler ContractApprovedEvent - number of fileInfos: {fileInfos.Count}");

                var tasks = fileInfos.Select(fi => ProcessFileInfo(context, fi, EventType.Approval)).ToList();

                await Task.WhenAll(tasks);
            }

            _logger.LogInformation(DocumentsDomainLoggingEventId.ContractApprovedHandlerEnded,
                $"Documents ContractApprovedAndWithdrawnHandler ContractApprovedEvent - Ended: {message}, {amendmentType}");
        }

        public async Task Handle(ContractWithdrawnEvent message, IMessageHandlerContext context)
        {
            string amendmentType = message.CorporateContract.contracts.First().amendmentType;

            _logger.LogInformation(DocumentsDomainLoggingEventId.ContractWithdrawnHandlerStarted,
                $"Documents ContractApprovedAndWithdrawnHandler ContractWithdrawnEvent - Started: {message}, {amendmentType}");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);
            bool shouldGenerateDocumentationForContract = await _policyQueryService.ShouldGenerateDocumentationForContract(message.CorporateContract, connectionInfo)
                .ConfigureAwait(false);

            if (shouldGenerateDocumentationForContract)
            {
                IReadOnlyCollection<FileInfo> fileInfos = GetFilesToBeDeletedAndArchived(message.CorporateContract);

                _logger.LogInformation(DocumentsDomainLoggingEventId.ContractWithdrawnHandlerStarted,
                    $"Documents ContractApprovedAndWithdrawnHandler ContractWithdrawnEvent - number of fileInfos: {fileInfos.Count}");

                var tasks = fileInfos.Select(fi => ProcessFileInfo(context, fi, EventType.Withdrawal)).ToList();

                await Task.WhenAll(tasks);
            }

            _logger.LogInformation(DocumentsDomainLoggingEventId.ContractWithdrawnHandlerEnded,
                $"Documents ContractApprovedAndWithdrawnHandler ContractWithdrawnEvent - Ended: {message}, {amendmentType}");
        }

        private IReadOnlyCollection<FileInfo> GetFilesToBeDeletedAndArchived(contract corporateContract)
        {
            if (corporateContract.contracts.First().amendmentType == "Notification")
            {
                return _archiveFileOrchestrator.OrchestrateForNotification(corporateContract);
            }

            return _archiveFileOrchestrator.OrchestrateForNonNotification(corporateContract);
        }

        private async Task ProcessFileInfo(IPipelineContext context, FileInfo fileInfo, EventType eventType)
        {
            if (fileInfo.FileAction == FileAction.Delete)
            {
                var documentDeleteCommand = new DocumentDeleteCommand();
                documentDeleteCommand.Files.Add(new FctFile(
                    fileContainer: fileInfo.FolderName,
                    filename: fileInfo.Filename));

                await context.Send(documentDeleteCommand)
                    .ConfigureAwait(false);
            }
            else if (fileInfo.FileAction == FileAction.Archive)
            {
                ArchiveDocumentCommand archiveDocumentCommand = new ArchiveDocumentCommand
                {
                    AmendmentType = fileInfo.AmendmentType,
                    EventType = eventType,
                    FileName = fileInfo.Filename,
                    FolderOrigin = fileInfo.FolderName,
                    Key = fileInfo.GetGuid()
                };

                SendOptions sendOptions = new SendOptions();
                sendOptions.RouteToThisEndpoint();

                await context.Send(archiveDocumentCommand, sendOptions)
                    .ConfigureAwait(false);
            }
            else
            {
                throw new ArgumentException($"This fileAction: {fileInfo.FileAction} is not supported");
            }
        }
    }
}
