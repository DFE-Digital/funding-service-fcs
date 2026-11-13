namespace PerformanceManagementDomain.PullFundingClaim.Handlers
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Threading.Tasks;
    using DTOs;
    using Extensions;
    using Infrastructure;
    using NServiceBus;
    using NServiceBus.Transport.AzureServiceBus;
    using PerformanceManagementDomain.Services;
    using Repositories;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PerformanceManagementDomain.Common.Logging;
    using System.Configuration;
    
    public class UpdateExistingPeriodClaimTypeHandler : IHandleMessages<UpdateExistingPeriodClaimTypeCommand>
    {
        private readonly ILogger _logger;
        private readonly IFundingClaimsApiAdapter _fundingClaimsApiAdapter;
        private readonly IFundingClaimRepository _fundingClaimRepository;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly IClaimReconciliationAllocationGroupFspRepository
            _claimReconciliationAllocationGroupFspRepository;
        private readonly IFundingClaimDebatchService _fundingClaimDebatchService;

        public UpdateExistingPeriodClaimTypeHandler(ILogger logger, IFundingClaimsApiAdapter fundingClaimsApiAdapter,
            IFundingClaimRepository fundingClaimRepository,
            ISessionConnectionFactory sessionConnectionFactory,
            IClaimReconciliationAllocationGroupFspRepository claimReconciliationAllocationGroupFspRepository,
            IFundingClaimDebatchService fundingClaimDebatchService)
        {
            _logger = logger;
            _fundingClaimsApiAdapter = fundingClaimsApiAdapter;
            _fundingClaimRepository = fundingClaimRepository;
            _sessionConnectionFactory = sessionConnectionFactory;
            _claimReconciliationAllocationGroupFspRepository = claimReconciliationAllocationGroupFspRepository;
            _fundingClaimDebatchService = fundingClaimDebatchService;
        }

        public async Task Handle(UpdateExistingPeriodClaimTypeCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(
                PerformanceManagementLoggingId.UpdateExistingPeriodClaimTypeCommandReceived,
                $"UpdateExistingPeriodClaimTypeCommand arrived :{message}");

            var totalRows = _fundingClaimsApiAdapter.GetCountOfFundingClaimsForCollectionKey(message.PeriodClaimType).Result;

            var totalPages = _fundingClaimsApiAdapter.GetNumberOfPagesRequired(totalRows);

            var fundingClaimApiDtos = Enumerable.Range(1, totalPages).ToList()
                .SelectMany(pageNumber => _fundingClaimsApiAdapter.GetFundingClaimsForCollectionKey(message.PeriodClaimType, pageNumber).Result).ToList();

            _logger.LogInformation(
                PerformanceManagementLoggingId.UpdateExistingPeriodClaimTypeCommandReceived,
                $"Total Pages: {totalPages}, fundingClaimApiDtos: {fundingClaimApiDtos.Count}");

            var fundingClaimsFromApiDictionary = fundingClaimApiDtos.ToDictionary(fc =>
                new FundingClaimKey
                {
                    ClaimTypeName = fc.ClaimTypeName,
                    OrganisationIdentifier = fc.OrganisationIdentifier,
                    Period = fc.Period,
                    PeriodTypeCode = fc.PeriodTypeCode,
                    VersionNumber = fc.VersionNumber
                }, fc => fc);

            var connectionInfo = _sessionConnectionFactory.GetConnection(context);

            var periodClaimTypeSplit = message.PeriodClaimType.Split('-');
            var keysFromDb = await _fundingClaimRepository.GetKeys(periodClaimTypeSplit[0], periodClaimTypeSplit[1].ToUpper(), connectionInfo);

            var fundingClaimKeysNotInDb =
                fundingClaimsFromApiDictionary.Keys.Where(key => !keysFromDb.Contains(key)).ToList();

            _logger.LogInformation(
                PerformanceManagementLoggingId.UpdateExistingPeriodClaimTypeCommandReceived,
                $"fundingClaimKeysNotInDb: {fundingClaimKeysNotInDb.Count}");

            // persist in DB.
            var fundingAllocationDtosNotInDb = fundingClaimKeysNotInDb.Select(key => fundingClaimsFromApiDictionary[key]).ToList();
            _logger.LogInformation(
                PerformanceManagementLoggingId.UpdateExistingPeriodClaimTypeCommandReceived,
                $"fundingAllocationDtosNotInDb: {string.Join(", ",fundingAllocationDtosNotInDb.Select(f => f.Ukprn))}");
            await RemoveInvalidAllocations(fundingAllocationDtosNotInDb, connectionInfo);
            var fundingClaims = fundingAllocationDtosNotInDb
                .Select(dto => dto.ToDataModel()).ToList();
            await _fundingClaimRepository.AddFundingClaims(fundingClaims, connectionInfo);

            // now publish
            var fundingClaimSchemaObjectsNotInDb = fundingAllocationDtosNotInDb
                .Select(ConvertFundingClaimDtoToSchemaType).ToList();

            await DebatchAndPublishIntoSystem(fundingClaimSchemaObjectsNotInDb, connectionInfo);

            _logger.LogInformation(
                PerformanceManagementLoggingId.UpdateExistingPeriodClaimTypeCommandProcessed,
                $"UpdateExistingPeriodClaimTypeCommand processed :{message}");
        }

        private async Task DebatchAndPublishIntoSystem(IReadOnlyCollection<FundingClaim> fundingClaimSchemaObjectsNotInDb, ConnectionInfo connectionInfo)
        {
            List<List<DebatchedFundingClaim>> allDebatchedFundingClaims = new List<List<DebatchedFundingClaim>>();
            foreach (var fundingClaimSchemaObjectNotInDb in fundingClaimSchemaObjectsNotInDb)
            {
                var debatchedEnumerable = await _fundingClaimDebatchService.DebatchFundingClaimByAllocationGroup(
                    fundingClaimSchemaObjectNotInDb, connectionInfo);
                allDebatchedFundingClaims.Add(debatchedEnumerable.ToList());
            }
            
            var endpoint = CreatePublishingEndpoint<FundingClaimDebatchedEvent>("PerformanceManagementDomain.FundingClaimImport");
            foreach (var debatchedFundingClaimCollection in allDebatchedFundingClaims)
            {
                await PublishDebatchedFundingClaims(debatchedFundingClaimCollection, endpoint);
            }
        }

        private async Task PublishDebatchedFundingClaims(IEnumerable<DebatchedFundingClaim> debatchedFundingClaims, IEndpointInstance endpoint)
        {
            List<Task> tasks = new List<Task>();

            foreach (DebatchedFundingClaim fc in debatchedFundingClaims)
            {
                var task = endpoint.Publish<FundingClaimDebatchedEvent>(x =>
                {
                    x.DebatchedFundingClaim = fc;
                });

                tasks.Add(task);
            };

            await Task.WhenAll(tasks);
        }

        private async Task RemoveInvalidAllocations(IReadOnlyCollection<FundingClaimApiDto> fundingClaimSchemaObjectsNotInDb, ConnectionInfo connectionInfo)
        {
            var validFspCodes = await _claimReconciliationAllocationGroupFspRepository.GetValidFundingStreamPeriodCodes(connectionInfo);

            fundingClaimSchemaObjectsNotInDb
                .ToList()
                .ForEach(fc => fc.ContractAllocations = fc.ContractAllocations.Where(ca => validFspCodes.Contains(ca.FundingStreamPeriodCode)).ToList());
        }

        private static SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.FundingClaim ConvertFundingClaimDtoToSchemaType(FundingClaimApiDto fundingClaim)
        {
            return new SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.FundingClaim
            {
                Period = fundingClaim.Period,
                ClaimTypeName = (ClaimTypeName)Enum.Parse(typeof(ClaimTypeName), fundingClaim.ClaimTypeName.Replace(" ", string.Empty).ToUpper()),
                ContractAllocations = fundingClaim.ContractAllocations.Select(ConvertAllocationToDto).ToList(),
                HasBeenSigned = bool.Parse(fundingClaim.HasBeenSigned.ToUpper()),
                PeriodTypeCode = (PeriodTypeCode)Enum.Parse(typeof(PeriodTypeCode), fundingClaim.PeriodTypeCode),
                Contractor = new Contractor { OrganisationIdentifier = fundingClaim.OrganisationIdentifier, Ukprn = int.Parse(fundingClaim.Ukprn) },
                VersionNumber = fundingClaim.VersionNumber
            };
        }

        private static SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.ContractAllocation ConvertAllocationToDto(ContractAllocationApiDto allocation)
        {
            return new SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.ContractAllocation
            {
                ContractAllocationNumber = allocation.ContractAllocationNumber,
                FundingStreamPeriodCode = allocation.FundingStreamPeriodCode,
                DeliverableLines = allocation.DeliverableCodes.Select(ConvertDeliverableToDto).ToList()
            };
        }

        private static SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.DeliverableLine ConvertDeliverableToDto(DeliverableCodeApiDto deliverable)
        {
            return new SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.DeliverableLine
            {
                DeliverableCode = deliverable.DeliverableCodeValue,
                ActualValue = deliverable.ActualValue,
                AdjustmentValue = deliverable.AdjustmentValue,
                ForecastValue = deliverable.ForecastValue,
                TotalDelivery = deliverable.TotalDelivery
            };
        }


        public static IEndpointInstance CreatePublishingEndpoint<TEvent>(string endpointToPublishFrom)
        {
            EndpointConfiguration endpointConfiguration = new EndpointConfiguration(endpointToPublishFrom);

            var transport = new AzureServiceBusTransport(
                ConfigurationManager.ConnectionStrings["NServiceBus/Transport"].ConnectionString,
                TopicTopology.Default
            );

            endpointConfiguration.UseTransport(transport);

            endpointConfiguration.Conventions()
                .DefiningEventsAs(t => t == typeof(TEvent));

            string[] assembliesToExclude = Directory.EnumerateFiles(AppDomain.CurrentDomain.BaseDirectory, "*.dll")
                .Select(Path.GetFileName)
                .ToArray();

            AssemblyScannerConfiguration scanner = endpointConfiguration.AssemblyScanner();
            scanner.ExcludeAssemblies(assembliesToExclude);
            scanner.ThrowExceptions = false;

            endpointConfiguration.UseSerialization<NewtonsoftSerializer>();

            return Endpoint.Start(endpointConfiguration).GetAwaiter().GetResult();
        }

    }
}
