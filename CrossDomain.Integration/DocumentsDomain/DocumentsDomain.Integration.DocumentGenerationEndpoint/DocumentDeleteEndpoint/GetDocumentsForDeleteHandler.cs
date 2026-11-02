namespace SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint.DocumentDeleteEndpoint
{
    using System.Linq;
    using System.Threading.Tasks;
    using Common;
    using Common.Commands;
    using CrossDomain.Integration.Common.Storage;
    using DocumentGeneration.DocumentLocationResolver;
    using Framework.Logging.Interfaces;
    using Framework.Logging.NullObjects;
    using NServiceBus;
    using FctFile = Common.Models.FctFile;

    public class GetDocumentsForDeleteHandler : IHandleMessages<GetDocumentsForDeleteCommand>
    {
        public ILogger Logger { get; set; }

        private readonly IOffice365Adapter _o365Adapter;

        private readonly IDocumentLocationResolver _docLocResolver;

        public GetDocumentsForDeleteHandler(IOffice365Adapter o365Adapter, IDocumentLocationResolver docLocResolver)
        {
            _o365Adapter = o365Adapter;
            _docLocResolver = docLocResolver;
            Logger = new LoggerNullObject();
        }

        public async Task Handle(GetDocumentsForDeleteCommand message, IMessageHandlerContext context)
        {
            var contract = message.Contract;
            var ukprn = contract.contractor.ukprn;
            var contractNumber = contract.contractNumber;

            Logger.LogInformation(DocumentsDomainLoggingEventId.GetDocumentsForDeleteHandlerMsgReceived, $"{nameof(GetDocumentsForDeleteCommand)} received for (UKPRN: [{ukprn}]/Contract Number: [{contractNumber}])");
            
            var lib = _docLocResolver.GetLocationOfTermsAndConditions(contract);

            Logger.LogInformation(DocumentsDomainLoggingEventId.GetDocumentsForDeleteHandlerGettingDocs, $"Getting T&Cs to delete for (UKPRN: [{ukprn}]/Contract Number: [{contractNumber}])");

            var fileNames = _o365Adapter.GetFilenamesByFileNameStartText(lib, $"{ukprn}_{contractNumber}_");

            if (fileNames.Any())
            {
                var deleteCmd = new DocumentDeleteCommand();

                fileNames.ToList().ForEach(fn => deleteCmd.Files.Add(new FctFile
                {
                    FileContainer = lib,
                    Filename = fn
                }));

                Logger.LogInformation(DocumentsDomainLoggingEventId.GetDocumentsForDeleteHandlerSendingDeleteCmd,
                    $"Sending {nameof(DocumentDeleteCommand)} for {deleteCmd.Files.Count} document(s) for (UKPRN: [{ukprn}]/Contract Number: [{contractNumber}])");

                await context.Send(deleteCmd)
                    .ConfigureAwait(false);
            }
            else
            {
                Logger.LogWarning(DocumentsDomainLoggingEventId.GetDocumentsForDeleteHandlerNoDocsFound, $"Found no files to delete for (UKPRN: [{ukprn}]/Contract Number: [{contractNumber}])");
            }
        }
    }
}
