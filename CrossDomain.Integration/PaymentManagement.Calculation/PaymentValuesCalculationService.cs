namespace PaymentManagement.Calculation
{
    using System;
    using System.Collections.Generic;
    using Dtos;
    using Extensions;
    using Optional;
    using Repositories;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class PaymentValuesCalculationService : IPaymentValuesCalculationService
    {
        public const int CalculatingDueToApprovalWithNewCalcCode = 952;
        public const int CalculatingDueToActualsWithNewCalcCode = 953;
        private readonly IPaymentValuesCalculator _paymentValuesCalculator;
        private readonly IDeliverablePaymentRepository _deliverablePaymentRepository;
        private readonly IActualEnrichmentService _actualEnrichmentService;
        private readonly IPolicyFundingStreamPeriodRepository _fspRepository;
        private readonly ILogger _logger;
        private readonly IFundingClaimReconciliationService _fundingClaimReconciliationService;

        public PaymentValuesCalculationService(
            IPaymentValuesCalculator paymentValuesCalculator,
            IDeliverablePaymentRepository deliverablePaymentRepository,
            IActualEnrichmentService actualEnrichmentService, 
            IPolicyFundingStreamPeriodRepository fspRepository,
            ILogger logger,
            IFundingClaimReconciliationService fundingClaimReconciliationService)
        {
            _paymentValuesCalculator = paymentValuesCalculator;
            _deliverablePaymentRepository = deliverablePaymentRepository;
            _actualEnrichmentService = actualEnrichmentService;
            _fspRepository = fspRepository;
            _logger = logger;
            _fundingClaimReconciliationService = fundingClaimReconciliationService;
        }

        public Allocation ProducePaymentScheduleOnApproval(allocationType allocation, ConnectionInfo connectionInfo)
        {
            var allocationFspCode = allocation.GetFspCode();
            
            if (_paymentValuesCalculator.IsFspCalculatedWithOpaReplacement(allocationFspCode, connectionInfo))
            {
                _logger.LogInformation(CalculatingDueToApprovalWithNewCalcCode, $"New Calc called on Approval : {allocation}");

                Allocation paymentSchedule = null;
                if (_fundingClaimReconciliationService.IsPayableFcrPublishedForAllocation(allocation.contractAllocationNumber, connectionInfo))
                { 
                    paymentSchedule = _fundingClaimReconciliationService.CreatePaymentScheduleFromPreviousVersion(allocation, connectionInfo);
                    _deliverablePaymentRepository.PersistPaymentScheduleAndActuals(paymentSchedule, connectionInfo);
                }
                else
                {
                    var fspDeliverableInfos = _fspRepository.GetFspDeliverableInfos(allocation.fundingStreamPeriod.fundingStreamPeriodCode, connectionInfo);

                    var cappingGroups = _fspRepository.GetCappingGroups(allocation.fundingStreamPeriod.fundingStreamPeriodCode, connectionInfo);

                    var allocationInput = allocation.ToCalculationAllocationInput(fspDeliverableInfos, cappingGroups);

                    Option<IReadOnlyCollection<DeliverablePeriodActualAndPaymentInfo>> previousVersionPaymentInfo = _actualEnrichmentService.GetPreviousVersionActualsAndPaymentValuesIfPresent(
                        allocationInput.AllocationNumber,
                        allocationInput.VersionNumber,
                        connectionInfo);

                    paymentSchedule = _paymentValuesCalculator.ProducePaymentScheduleForCurrentPeriodOnApproval(allocationInput, previousVersionPaymentInfo, connectionInfo);

                    PersistPaymentScheduleAndActuals(paymentSchedule, allocationInput, connectionInfo);
                }

                return paymentSchedule;
            }

            throw new ArgumentException($"ProducePaymentScheduleOnApproval - There is no calculation behaviour for Allocation FSP code {allocationFspCode}");
        }

        private void PersistPaymentScheduleAndActuals(Allocation paymentSchedule, CalculationAllocationInput allocationInput, ConnectionInfo connectionInfo)
        {
            paymentSchedule.EnrichWithActualValues(allocationInput);
            _deliverablePaymentRepository.PersistPaymentScheduleAndActuals(paymentSchedule, connectionInfo);
        }

        public Allocation ProducePaymentScheduleOnActualsReceived(ContractAllocationActualsType allocation, ConnectionInfo connectionInfo)
        {
            var fspDeliverableInfos = _fspRepository.GetFspDeliverableInfos(allocation.FundingStreamPeriodCode, connectionInfo);
            
            var cappingGroups = _fspRepository.GetCappingGroups(allocation.FundingStreamPeriodCode, connectionInfo);

            var optionalPaymentSchedule = _paymentValuesCalculator.ProducePaymentScheduleForCurrentPeriodOnActualsReceived(allocation.ToCalculationAllocationInput(fspDeliverableInfos, cappingGroups),
                connectionInfo);

            return optionalPaymentSchedule.Match(
                some: paymentSchedule =>
                {
                    _logger.LogInformation(CalculatingDueToActualsWithNewCalcCode, $"New Calc called on Actuals Received : {allocation}");

                    PersistActuals(allocation, connectionInfo);
                    PersistCalculatedValues(paymentSchedule, connectionInfo);

                    return paymentSchedule;
                },
                none: () => throw new ArgumentException($"ProducePaymentScheduleOnActualsReceived - There is no calculation behaviour for Allocation FSP code {allocation.FundingStreamPeriodCode}"));
        }

        private void PersistActuals(ContractAllocationActualsType allocation, ConnectionInfo connectionInfo)
        {
            _deliverablePaymentRepository.AddOrUpdateDeliverablePaymentsWithActualValues(allocation, connectionInfo);
        }

        private void PersistCalculatedValues(Allocation paymentSchedule, ConnectionInfo connectionInfo)
        {
            paymentSchedule.AllocationDeliverables
                .ForEach(ad => _deliverablePaymentRepository.AddOrUpdateDeliverablePaymentsWithCalculatedValues(paymentSchedule.AllocationNumber, paymentSchedule.VersionNumber, ad, connectionInfo));
        }
    }
}
