namespace SFA.FCT.AllocationDeliveryDomain.MDEnrich.Endpoint
{
    using System;
    using System.Data.Entity.Validation;
    using System.Linq;
    using BusinessLogic;
    using Common;
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities.DeliveryAllocation;
    using CrossDomain.Integration.Events;
    using Framework.Logging.Interfaces;
    using NServiceBus;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using CrossDomain.Integration.Entities.CorporateContract;
    using System.Threading.Tasks;
    using CrossDomain.Integration.Entities.Data;
    using Infrastructure;

    public class ContractApprovedHandler : IHandleMessages<ContractApprovedEvent>
    {
        public ILogger Logger { get; set; }

        public IContractAllocationTransformer Transformer { get; set; }

        public IMonitoringDeliverableStore Store { get; set; }

        public IMonitoringDeliverableEnrichment Enrichment { get; set; }

        public ISessionConnectionFactory SessionConnectionFactory { get; set; }

        public async Task Handle(ContractApprovedEvent message, IMessageHandlerContext context)
        {
            var correlationId = context.MessageHeaders[Headers.CorrelationId];
            
            ConnectionInfo connectionInfo = SessionConnectionFactory.GetConnection(context);
            
            var result = ContractApprovedEventValidator.Validate(message);
            if (!result.Result)
            {
                Logger.LogInformation(
                    AllocationDeliverDomainEventLoggingId.ContractApprovedReceived,
                    result.ContextMessage,
                    correlationId,
                    message.CorporateContract);
                return;
            }

            Logger.LogInformation(
                AllocationDeliverDomainEventLoggingId.ContractApprovedReceived,
                "ContractApprovedEvent received by AllocationDeliveryDomain, CorrelationId: {0}, Contract:{1}",
                correlationId,
                message.CorporateContract);

            List<allocationType> allocations = message.CorporateContract.contracts
                .SelectMany(c => c.contractAllocations
                    .Select(ca => Transformer.Transform(c, ca, correlationId)))
                .ToList();

            if (message.CorporateContract.fundingType.fundingTypeCode == "ESF")
            {
                var contract = message.CorporateContract.contracts[0];
                foreach (contractAllocationsContractAllocation contractAllocation in contract.contractAllocations)
                {
                    Store.StoreESFAllocation(contractAllocation, contract.contractNumber, connectionInfo);
                }
            }

            try
            {
                foreach (allocationType allocation in allocations)
                {
                    Enrichment.Enrich(allocation);
                    Store.RemoveAllocation(allocation, connectionInfo);
                    Store.StoreAllocation(allocation, connectionInfo);
                }

                foreach (allocationType allocation in allocations)
                {
                    AllocationDeliveryCommencedEvent allocationDeliveryCommencedEvent =
                        new AllocationDeliveryCommencedEvent
                        {
                            Allocation = allocation
                        };
                    await context.Publish(allocationDeliveryCommencedEvent).ConfigureAwait(false);
                }
            }
            catch (DbEntityValidationException ex)
            {
                var errorMessages = ex.EntityValidationErrors
                    .SelectMany(x => x.ValidationErrors)
                    .Select(x => x.ErrorMessage);

                var fullErrorMessage = String.Join("; ", errorMessages);

                var exceptionMessage = String.Concat(ex.Message, " The validation errors are: ", fullErrorMessage);

                Logger.LogError(AllocationDeliverDomainEventLoggingId.AllocationDeliverableInsertError, ex,
                    "An error occurred inserting deliverables for allocation, CorrelationID:{0}, Contract{1}, Error: {2}",
                    correlationId, message.CorporateContract, exceptionMessage);

                throw;
            }
            catch (Exception ex)
            {
                Logger.LogError(AllocationDeliverDomainEventLoggingId.AllocationDeliverableInsertError, ex,
                    "An error occurred inserting deliverables for allocation, CorrelationID:{0}, Contract{1}",
                    correlationId, message.CorporateContract);
                throw;
            }
        }

        //public void Handle(ContractApprovedEvent message)
        //{
        //    string correlationId = Bus.CurrentMessageContext.Headers[Headers.CorrelationId];

        //    var result = ContractApprovedEventValidator.Validate(message);
        //    if (!result.Result)
        //    {
        //        Logger.LogInformation(
        //            AllocationDeliverDomainEventLoggingId.ContractApprovedReceived,
        //            result.ContextMessage,
        //            correlationId,
        //            message.CorporateContract);
        //        return;
        //    }

        //    Logger.LogInformation(
        //        AllocationDeliverDomainEventLoggingId.ContractApprovedReceived,
        //        "ContractApprovedEvent received by AllocationDeliveryDomain, CorrelationId: {0}, Contract:{1}",
        //        correlationId,
        //        message.CorporateContract);

        //    List<allocationType> allocations = message.CorporateContract.contracts
        //        .SelectMany(c => c.contractAllocations
        //            .Select(ca => Transformer.Transform(c, ca, correlationId)))
        //        .ToList();

        //    if (message.CorporateContract.fundingType.fundingTypeCode == "ESF")
        //    {
        //        var contract = message.CorporateContract.contracts[0];
        //        foreach (contractAllocationsContractAllocation contractAllocation in contract.contractAllocations)
        //        {
        //            Store.StoreESFAllocation(contractAllocation, contract.contractNumber);
        //        }
        //    }

        //    try
        //    {
        //        foreach (allocationType allocation in allocations)
        //        {
        //            Enrichment.Enrich(allocation);
        //            Store.RemoveAllocation(allocation);
        //            Store.StoreAllocation(allocation);
        //        }

        //        Store.Context.SaveChanges();

        //        foreach (allocationType allocation in allocations)
        //        {
        //            AllocationDeliveryCommencedEvent allocationDeliveryCommencedEvent =
        //                new AllocationDeliveryCommencedEvent
        //                {
        //                    Allocation = allocation
        //                };
        //            Bus.Publish<AllocationDeliveryCommencedEvent>(allocationDeliveryCommencedEvent);
        //        }
        //    }
        //    catch (DbEntityValidationException ex)
        //    {
        //        var errorMessages = ex.EntityValidationErrors
        //            .SelectMany(x => x.ValidationErrors)
        //            .Select(x => x.ErrorMessage);

        //        var fullErrorMessage = String.Join("; ", errorMessages);

        //        var exceptionMessage = String.Concat(ex.Message, " The validation errors are: ", fullErrorMessage);

        //        Logger.LogError(AllocationDeliverDomainEventLoggingId.AllocationDeliverableInsertError, ex,
        //            "An error occurred inserting deliverables for allocation, CorrelationID:{0}, Contract{1}, Error: {2}",
        //            correlationId, message.CorporateContract, exceptionMessage);

        //        throw;
        //    }
        //    catch (Exception ex)
        //    {
        //        Logger.LogError(AllocationDeliverDomainEventLoggingId.AllocationDeliverableInsertError, ex,
        //            "An error occurred inserting deliverables for allocation, CorrelationID:{0}, Contract{1}",
        //            correlationId, message.CorporateContract);
        //        throw;
        //    }
        //}
    }
}
