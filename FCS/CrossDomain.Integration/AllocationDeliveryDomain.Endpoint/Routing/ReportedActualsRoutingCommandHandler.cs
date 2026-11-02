namespace AllocationDeliveryDomain.Endpoint.Routing
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using AllocationDelivery.Messages.Commands;
    using AllocationDelivery.Messages.DTOs;
    using Infrastructure;
    using NServiceBus;
    using Repositories;
    using SFA.FCT.AllocationDeliveryDomain.Common;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ReportedActualsRoutingCommandHandler : IHandleMessages<ReportedActualsRoutingCommand>
    {
        private readonly IAzureRepository<ReportedActual> _reportedActualRepository;
        private readonly IFundingStreamPeriodRepository _fundingStreamPeriodRepository;
        private readonly ILogger _logger;
        private readonly IHeldReportedActualGroupCommandRepository _heldReportedActualGroupCommandRepository;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private static readonly IReadOnlyCollection<string> CollectionTypesWhereUnRecognisedFspsAllowed = new List<string>{"ALLF"};

        public ReportedActualsRoutingCommandHandler(
            IAzureRepository<ReportedActual> reportedActualRepository,
            IFundingStreamPeriodRepository fundingStreamPeriodRepository,
            ILogger logger,
            IHeldReportedActualGroupCommandRepository heldReportedActualGroupCommandRepository,
            ISessionConnectionFactory sessionConnectionFactory)
        {
            _reportedActualRepository = reportedActualRepository;
            _fundingStreamPeriodRepository = fundingStreamPeriodRepository;
            _logger = logger;
            _heldReportedActualGroupCommandRepository = heldReportedActualGroupCommandRepository;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public Task Handle(ReportedActualsRoutingCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(AllocationDeliverDomainEventLoggingId.ReportedActualsRouting, $"ReportedActualsRoutingCommand received {message}");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            SummarisedActualOrgFspGroupKey orgFspGroupKey = GetOrgFspGroupKeyFromMessage(message);

            if (orgFspGroupKey != null)
            {
                var fundingStreamPeriodOptional = _fundingStreamPeriodRepository.GetFundingStreamPeriod(orgFspGroupKey.FundingStreamPeriodCode, connectionInfo);

                fundingStreamPeriodOptional.Match(
                    some: fsp => ProcessSummarisedActualOrgFspGroupKey(message, orgFspGroupKey, fsp, context).Wait(),
                    none: () =>
                    {
                        if (CollectionTypesWhereUnRecognisedFspsAllowed.Contains(message.SummarisedActualOrgFspGroupKey
                            .CollectionType))
                        {
                            _logger.LogInformation(AllocationDeliverDomainEventLoggingId.ReportedActualsRoutingFspNotSupported,
                                $@"ReportedActualsRoutingCommand - The fspCode is not supported: {orgFspGroupKey.FundingStreamPeriodCode} Collection Type is: {message.SummarisedActualOrgFspGroupKey.CollectionType}");
                        }
                        else
                        {
                            throw new ArgumentException($"The FSP: {orgFspGroupKey.FundingStreamPeriodCode} is not supported");
                        }
                    });
            }
            else
            {
                _logger.LogError(AllocationDeliverDomainEventLoggingId.ReportedActualsRouting, $"There are no reported actuals for this partition key {message}");
            }

            return Task.CompletedTask;
        }

        private async Task ProcessSummarisedActualOrgFspGroupKey(
            ReportedActualsRoutingCommand message,
            SummarisedActualOrgFspGroupKey orgFspGroupKey,
            FundingStreamPeriod fundingStreamPeriod,
            IMessageHandlerContext context)
        {
                if (fundingStreamPeriod.PaymentMethod == FundingStreamPeriodPaymentMethod.PayOnInstruction)
                {
                    await context.Send(new ReportedPaymentInstructionsLoadedCommand
                    {
                        PartitionKey = message.PartitionKey,
                        SummarisedActualOrgFspGroupKey = message.SummarisedActualOrgFspGroupKey
                    }).ConfigureAwait(false);

                    _logger.LogInformation(AllocationDeliverDomainEventLoggingId.ReportedActualsRouting, $"ReportedPaymentInstructionsLoadedCommand sent {message}");
                }
                else
                {
                    if (fundingStreamPeriod.MultiCollectionReturns)
                    {
                        ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

                        _heldReportedActualGroupCommandRepository.Add(new HeldReportedActualGroup(
                            partitionKey: message.GetPartitionKey(),
                            fundingStreamPeriodCode: orgFspGroupKey.FundingStreamPeriodCode,
                            organisationIdentifier: orgFspGroupKey.OrganisationId,
                            uoPCode: orgFspGroupKey.UopCode,
                            collectionType: orgFspGroupKey.CollectionType,
                            collectionReturnCode: orgFspGroupKey.CollectionReturnCode), connectionInfo);

                        _logger.LogInformation(AllocationDeliverDomainEventLoggingId.ReportedActualsRouting, $"Added actuals group to held table sent {message}");
                    }
                    else
                    {
                        await context.Send(new ReportedActualsLoadedCommand
                        {
                            PartitionKeys = message.GetPartitionKeys(),
                            SummarisedActualOrgFspGroupKeys = message.GetSummarisedActualOrgFspGroupKeys(),
                            FundingStreamPeriodCode = fundingStreamPeriod.Code
                        }).ConfigureAwait(false);

                        _logger.LogInformation(AllocationDeliverDomainEventLoggingId.ReportedActualsRouting, $"ReportedActualsLoadedCommand sent {message}");
                    }
                }
        }

        private SummarisedActualOrgFspGroupKey GetOrgFspGroupKeyFromMessage(ReportedActualsRoutingCommand message)
        {
            if (message.IsUsingAzureTableStorage())
            {
                ReportedActual reportedActual = _reportedActualRepository.GetRows(message.PartitionKey)
                    .FirstOrDefault();

                if (reportedActual != null)
                {
                    return new SummarisedActualOrgFspGroupKey
                    {
                        CollectionType = reportedActual.CollectionType,
                        CollectionReturnCode = reportedActual.CollectionReturnCode,
                        OrganisationId = reportedActual.OrganisationId,
                        FundingStreamPeriodCode = reportedActual.FundingStreamPeriodCode,
                        UopCode = reportedActual.UoPCode
                    };
                }
            }

            return message.SummarisedActualOrgFspGroupKey;
        }
    }
}
