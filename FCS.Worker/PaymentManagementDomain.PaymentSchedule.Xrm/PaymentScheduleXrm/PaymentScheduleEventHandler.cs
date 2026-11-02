namespace PaymentManagementDomain.PaymentSchedule.PaymentScheduleXrm
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Extensions;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PaymentManagementDomain.Common;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.Xrm.Integration.Repositories;
    using Xrm.Extensions;
    using Xrm.Infrastructure;
    using ConnectionInfo = SFA.FCT.CrossDomain.Integration.Entities.Data.ConnectionInfo;

    public class PaymentScheduleEventHandler : IHandleMessages<PaymentScheduleEvent>
    {
        private readonly ILogger _logger;
        private readonly ICrmAllocationRepository _crmAllocationRepository;
        private readonly ICrmDeliverablePeriodRepository _crmDeliverablePeriodRepository;
        private readonly IProcessedMessageRepository _processedMessageRepository;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly PaymentManagementDomain.PaymentSchedule.PaymentScheduleXrm.Services.IPaymentScheduleService _paymentScheduleService;

        public PaymentScheduleEventHandler(
             ILogger logger,
             ICrmAllocationRepository crmAllocationRepository,
             ICrmDeliverablePeriodRepository crmDeliverablePeriodRepository,
             IProcessedMessageRepository processedMessageRepository,
             ISessionConnectionFactory sessionConnectionFactory,
             Services.IPaymentScheduleService paymentScheduleService)
        {
            _logger = logger;
            _crmAllocationRepository = crmAllocationRepository;
            _crmDeliverablePeriodRepository = crmDeliverablePeriodRepository;
            _processedMessageRepository = processedMessageRepository;
            _sessionConnectionFactory = sessionConnectionFactory;
            _paymentScheduleService = paymentScheduleService;
        }

        public async Task Handle(PaymentScheduleEvent message, IMessageHandlerContext context)
        {
            _logger.LogInformation(
                PaymentManagementLoggingEvents.PaymentManagementStart,
                $"{LogMessage.NewWorker} - Payment Schedule XRM - START: Payment Schedule Event for {message} received");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            if (_processedMessageRepository.Add(context.MessageId, connectionInfo))
            {
                string allocationNumber = message.PaymentScheduleAllocation.AllocationNumber;
                int versionNumber = message.PaymentScheduleAllocation.ContractVersionNumber;

                AllocationInfo allocationInfo = _crmAllocationRepository.GetAllocationInfoFromCrm(allocationNumber, versionNumber);
                IReadOnlyCollection<DeliverableInfo> deliverablesInCrm = _crmAllocationRepository.GetContractDeliverablesForAllocation(allocationInfo.AllocationId);

                IReadOnlyCollection<DeliverablePeriodYear> deliverablePeriodYearsInCrm = _crmDeliverablePeriodRepository.GetDeliverablePeriodYears(allocationInfo.AllocationId);

                IReadOnlyCollection<DeliverablePeriodYear> deliverablePeriodYearsOnPaymentSchedule = message.PaymentScheduleAllocation
                    .ToDeliverablePeriodYears();

                var deliverablePeriodYearsMissingFromCrm = deliverablePeriodYearsOnPaymentSchedule.Where(dpOnPaymentSchedule =>
                    !deliverablePeriodYearsInCrm.Contains(dpOnPaymentSchedule))
                    .ToList();

                _paymentScheduleService.CreateMissingDeliverablesAndTheirPeriods(
                    existingDeliverables: deliverablesInCrm,
                    allocationInfo,
                    fspCode: message.PaymentScheduleAllocation.FundingStreamPeriodCode,
                    missingDeliverablePeriodYears: deliverablePeriodYearsMissingFromCrm);

                // we get these again just in case some have been added
                deliverablesInCrm = _crmAllocationRepository.GetContractDeliverablesForAllocation(allocationInfo.AllocationId);
                deliverablePeriodYearsInCrm = _crmDeliverablePeriodRepository.GetDeliverablePeriodYears(allocationInfo.AllocationId);

                _paymentScheduleService.UpdateExistingDeliverablesAndTheirPeriods(existingDeliverables: deliverablesInCrm,
                    allocationInfo, 
                    fspCode: message.PaymentScheduleAllocation.FundingStreamPeriodCode,
                    existingDeliverablePeriodYears: deliverablePeriodYearsInCrm,
                    deliverablePeriodYearsOnPaymentSchedule);

               // message.PaymentScheduleAllocation
               //bool wasDeferred = await MessageDeferrer.DeferEventIfNecessary(
               //    bus: context,
               //    message: message,
               //    shouldDefer: () => MonitoringDeliverablesCompletedCheckNeeded(fundingType) &&
               //        MonitoringDeliverablesAddingIsInProgress(message, deliverablePeriodYearsInCrm, allocationInfo.AllocationStartDate, allocationInfo.AllocationEndDate),
               //    actionIfNotDeferred: () =>
               //    {
               //        if (ShouldCreateMissingDeliverablePeriods(fundingType))
               //        {
               //            _contractPaymentManager.CreateMissingDeliverablePeriodsOutsideOfTheBoundsOfTheAllocation(
               //                message.PaymentScheduleAllocation, allocationInfo, deliverablesInCrm,
               //                deliverablePeriodYearsInCrm);
               //        }
               //        else
               //        {
               //            _levyMissingDeliverablePeriodCreator.CreateMissingDeliverablePeriodsWhenNecessary(message.PaymentScheduleAllocation.AllocationNumber);
               //        }
               //    },
               //    prependedErrorMessage: $"{LogMessage.NewWorker} - Payment Schedule XRM: Max Deferrals - {message}");
               //if (wasDeferred)
               //{
               //    return;
               //}

              //  _contractPaymentManager.UpdateAllocationSchedulesInCrm(message.PaymentScheduleAllocation, allocationInfo, deliverablesInCrm, deliverablePeriodYearsInCrm);

                await context.Send(new AggregateDeliverablesCommand
                {
                    AllocationNumber = allocationNumber,
                    ContractVersionNumber = versionNumber,
                    SubVersionNumber = allocationInfo.Subversion,
                    FundingStreamPeriodCode = message.PaymentScheduleAllocation.FundingStreamPeriodCode
                });
            }

            _logger.LogInformation(
                PaymentManagementLoggingEvents.PaymentScheduleXrmHandlerEnd,
                $"{LogMessage.NewWorker} - Payment Schedule XRM - END. for {message}");
        }

        private static bool ShouldCreateMissingDeliverablePeriods(string fundingTypeCode)
        {
            return fundingTypeCode != "LEVY";
        }

        private static bool MonitoringDeliverablesCompletedCheckNeeded(string fundingTypeCode)
        {
            return fundingTypeCode != "LEVY";
        }

        private static bool MonitoringDeliverablesAddingIsInProgress(PaymentScheduleEvent paymentSchedule, 
            IReadOnlyCollection<DeliverablePeriodYear> deliverablePeriodYearsInCrm, 
            DateTime allocationStartDate, DateTime? allocationEndDate)
        {
            if (allocationEndDate.HasValue)
            {
                return !paymentSchedule.PaymentScheduleAllocation
                    .AreAllDeliverablePeriodsPresent(deliverablePeriodYearsInCrm, allocationStartDate, allocationEndDate.Value);
            }

            return false;
        }
    }
}
