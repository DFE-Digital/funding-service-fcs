namespace FCT.Operations.FundingAllocationExtract
{
    using System.IO;
    using System.Threading.Tasks;
    using Infrastructure;
    using FCT.Operations.Repositories;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Operations.Common;
    using Aspose.Cells;
    using Extensions;
    using Repositories;

    public class CreateFundingAllocationExtractsHandler : IHandleMessages<CreateFundingAllocationExtractCommand>
    {
        private readonly ILogger _logger;
        private readonly IWorkbookSharePointRepository _workbookSharePointRepository;
        private readonly IExcelGenerator _excelGenerator;
        private readonly IFundingAllocationExtractRepository _fundingAllocationExtractRepository;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public CreateFundingAllocationExtractsHandler(ILogger logger,
            IWorkbookSharePointRepository workbookSharePointRepository,
            IExcelGenerator excelGenerator,
            IFundingAllocationExtractRepository fundingAllocationExtractRepository,
            ISessionConnectionFactory sessionConnectionFactory)
        {
            _logger = logger;
            _workbookSharePointRepository = workbookSharePointRepository;
            _excelGenerator = excelGenerator;
            _fundingAllocationExtractRepository = fundingAllocationExtractRepository;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public async Task Handle(CreateFundingAllocationExtractCommand message, IMessageHandlerContext context)
        {
            const string folderName = "Funding Allocation Extracts";
            const string filename = "Parked_and_Discarded_Extract.xlsx";

            _logger.LogInformation(LoggingEventId.CreateFundingAllocationExtractReceived, "Received CreateFundingAllocationExtractCommand");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetReplicaConnection();

            var parkedRows = await _fundingAllocationExtractRepository.GetExtract(FundingAllocationExtractType.Parked, connectionInfo);
            var discardedRows = await _fundingAllocationExtractRepository.GetExtract(FundingAllocationExtractType.Discarded, connectionInfo);

            Workbook workbook = _excelGenerator.GenerateWorkbook(parkedRows, discardedRows);

            _workbookSharePointRepository.Upload(folderName, filename, workbook.ToBytes());

            _logger.LogInformation(LoggingEventId.CreateFundingAllocationExtractProcessed, $"Processed CreateFundingAllocationExtractCommand, parkedRows: {parkedRows.Count}, discardedRows: {discardedRows.Count}");
        }
    }
}
