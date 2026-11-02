namespace PaymentManagement.Calculation
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Dtos;
    using Extensions;
    using Optional;
    using Repositories;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;

    public class PaymentValuesCalculator : IPaymentValuesCalculator
    {
        private const int CalculatingWithBehaviour = 954;

        private readonly IPolicyFundingStreamPeriodRepository _fspRepository;
        private readonly ICensusDateService _censusDateService;
        private readonly IDeliverablePaymentRepository _deliverablePaymentRepository;
        private readonly IBehaviourFactory _behaviourFactory;
        private readonly ILogger _logger;

        public PaymentValuesCalculator(
            IPolicyFundingStreamPeriodRepository fspRepository,
            ICensusDateService censusDateService,
            IDeliverablePaymentRepository deliverablePaymentRepository,
            ILogger logger,
            IBehaviourFactory behaviourFactory)
        {
            _fspRepository = fspRepository;
            _deliverablePaymentRepository = deliverablePaymentRepository;
            _logger = logger;
            _behaviourFactory = behaviourFactory;
            _censusDateService = censusDateService;
        }

        public Allocation ProducePaymentScheduleForCurrentPeriodOnApproval(
            CalculationAllocationInput allocation,
            Option<IReadOnlyCollection<DeliverablePeriodActualAndPaymentInfo>> previousVersionPaymentInfoOptional,
            ConnectionInfo connectionInfo)
        {
            if (allocation.IsNew() && !IsPayOnProfile(allocation.FundingStreamPeriodCode, connectionInfo))
            { 
                return allocation.ToPaymentSchedule();
            }

            var currentPeriodInfo = _censusDateService.GetCensusPeriodInfo(allocation.FundingStreamPeriodCode, connectionInfo);

            var behaviourOption = _behaviourFactory.GetBehaviour(allocation.FundingStreamPeriodCode, currentPeriodInfo?.GetPeriod(), connectionInfo);

            return behaviourOption.Match(
                some: behaviour =>
                {
                    _logger.LogInformation(CalculatingWithBehaviour, $"The Calc Behaviour: {behaviour.Name}, Allocation: {allocation}");

                    List<DeliverablePeriodPaymentInfo> paymentValuesOnPreviousVersion = previousVersionPaymentInfoOptional
                        .ValueOr(new List<DeliverablePeriodActualAndPaymentInfo>())
                        .Select(prevVersion => prevVersion.ToPaymentInfo()).ToList();

                    allocation.SetOverDelivery(behaviour.CappingPeriodsForOverDelivery);

                    allocation.MergePaymentValuesIncludingActualsOntoInput(paymentValuesOnPreviousVersion);

                    Allocation allocationPaymentSchedule = Calculate(allocation, behaviour, currentPeriodInfo);

                    allocationPaymentSchedule.EnrichWithPlannedValues(allocation);

                    return allocationPaymentSchedule;
                },
                none: () => throw new ArgumentException($"Behaviour not supported for FSP: {allocation.FundingStreamPeriodCode}"));
        }

        public Option<Allocation> ProducePaymentScheduleForCurrentPeriodOnActualsReceived(CalculationAllocationInput allocation, ConnectionInfo connectionInfo)
        {
            var currentPeriodInfo = _censusDateService.GetCensusPeriodInfo(allocation.FundingStreamPeriodCode, connectionInfo);

            var behaviourOption = _behaviourFactory.GetBehaviour(allocation.FundingStreamPeriodCode, currentPeriodInfo?.GetPeriod(), connectionInfo);

            return behaviourOption.Match(
                some: behaviour =>
                {
                    _logger.LogInformation(CalculatingWithBehaviour, $"The Calc Behaviour: {behaviour.Name}, Allocation: {allocation}");
                    var currentVersionPayments = _deliverablePaymentRepository.GetDeliverablePeriodPaymentInfos(
                        allocation.AllocationNumber,
                        allocation.VersionNumber,
                        connectionInfo);

                    var fspDeliverableInfos = _fspRepository.GetFspDeliverableInfos(allocation.FundingStreamPeriodCode, connectionInfo);

                    // merge
                    allocation.MergePaymentValuesNotIncludingActualsOntoInput(currentVersionPayments, fspDeliverableInfos);

                    allocation.SetOverDelivery(behaviour.CappingPeriodsForOverDelivery);

                    return Calculate(allocation, behaviour, currentPeriodInfo).Some();
                },
                none: () => new Option<Allocation>());
        }

        private bool IsPayOnProfile(string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            return _fspRepository.GetPaymentMethod(fundingStreamPeriodCode, connectionInfo) == PaymentMethod.PayOnProfile;
        }

        private Allocation Calculate(CalculationAllocationInput allocation, Behaviour behaviour, CensusPeriodInfo currentPeriodInfo)
        {
            var resultLines = behaviour.CalculateCappingAmount(allocation, currentPeriodInfo);

            return resultLines.ToPaymentSchedule(allocation);
        }

        public bool IsFspCalculatedWithOpaReplacement(string fsp, ConnectionInfo connectionInfo)
        {
            var currentPeriodInfo = _censusDateService.GetCensusPeriodInfo(fsp, connectionInfo);

            return _behaviourFactory.GetBehaviour(fsp, currentPeriodInfo?.GetPeriod(), connectionInfo).HasValue;
        }
    }
}
