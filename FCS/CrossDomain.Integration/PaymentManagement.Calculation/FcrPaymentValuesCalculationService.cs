namespace PaymentManagement.Calculation
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Behaviours;
    using Dtos;
    using Extensions;
    using Repositories;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.Infos;
    using Allocation = SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule.Allocation;

    public class FcrPaymentValuesCalculationService : IFcrPaymentValuesCalculationService
    {
        private readonly IDateService _dateService;
        private readonly IPaymentTimetableRepository _paymentTimetableRepository;
        private readonly IDeliverablePaymentRepository _deliverablePaymentRepository;
        private readonly IPolicyFundingStreamPeriodRepository _fundingStreamPeriodRepository;
        private readonly IOrganisationDetailsRepository _organisationDetailsRepository;

        public FcrPaymentValuesCalculationService(
            IDateService dateService,
            IPaymentTimetableRepository paymentTimetableRepository,
            IDeliverablePaymentRepository deliverablePaymentRepository,
            IPolicyFundingStreamPeriodRepository fundingStreamPeriodRepository,
            IOrganisationDetailsRepository organisationDetailsRepository)
        {
            _dateService = dateService;
            _paymentTimetableRepository = paymentTimetableRepository;
            _deliverablePaymentRepository = deliverablePaymentRepository;
            _fundingStreamPeriodRepository = fundingStreamPeriodRepository;
            _organisationDetailsRepository = organisationDetailsRepository;
        }

        public IReadOnlyCollection<Allocation> CalculateAllocationSchedules(ContractInfo contractInfo,
            ConnectionInfo connectionInfo, bool shouldStaggerPayments)
        {
            return contractInfo.AllocationInfos
                .Select(allocation => CalculateAllocationSchedule(
                    allocation,
                    contractInfo.ContractNumber,
                    contractInfo.ContractVersion,
                    connectionInfo,
                    shouldStaggerPayments))
                .ToList();
        }

        private Allocation CalculateAllocationSchedule(AllocationInfo allocationInfo, string contractNumber, int versionNumber, ConnectionInfo connectionInfo, bool shouldStaggerPayments)
        {
            CalculationAllocationInput calculationAllocationInput = CreateCalculationInput(allocationInfo, contractNumber, versionNumber, connectionInfo);

            CensusPeriodInfo currentPeriodInfo = GetCensusPeriodInfo(allocationInfo.FundingStreamPeriodCode, connectionInfo);

            IReadOnlyCollection<CalculationResultLine> calculationResultLines =
                PayOnProfileFundingClaimReconciliationPublishedBehaviour.Calculate(calculationAllocationInput, currentPeriodInfo, allocationInfo.ReconciliationValue.GetValueOrDefault());

            calculationResultLines = calculationResultLines.StaggerPaymentsIfNecessary(shouldStaggerPayments, currentPeriodInfo.GetPeriod());

            Allocation paymentSchedule = calculationResultLines.ToPaymentSchedule(calculationAllocationInput);

            paymentSchedule.EnrichWithPlannedValues(calculationAllocationInput);
            paymentSchedule.EnrichWithActualValues(calculationAllocationInput);

            return paymentSchedule;
        }

        private CensusPeriodInfo GetCensusPeriodInfo(string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            DateTime currentDate = _dateService.GetCurrentDate();

            return _paymentTimetableRepository.GetCensusPeriodInfo(fundingStreamPeriodCode, currentDate, connectionInfo);
        }
        
        private CalculationAllocationInput CreateCalculationInput(AllocationInfo allocationInfo, string contractNumber, int versionNumber, ConnectionInfo connectionInfo)
        {
            OrganisationDetails organisationDetails =
                _organisationDetailsRepository.GetOrganisationDetailsForAllocation(allocationInfo.AllocationNumber, versionNumber, connectionInfo);

            IReadOnlyCollection<DeliverablePeriodPaymentInfo> deliverablePeriods =
                _deliverablePaymentRepository.GetDeliverablePeriodPaymentInfos(allocationInfo.AllocationNumber, versionNumber, connectionInfo);

            IReadOnlyCollection<FspDeliverableInfo> fspDeliverables =
                _fundingStreamPeriodRepository.GetFspDeliverableInfos(allocationInfo.FundingStreamPeriodCode, connectionInfo);

            return allocationInfo.ToCalculationAllocationInput(
                contractNumber: contractNumber,
                versionNumber: versionNumber,
                ukprn: organisationDetails.Ukprn,
                orgId: organisationDetails.OrganisationId,
                deliverablePeriods: deliverablePeriods,
                fspDeliverables: fspDeliverables);
        }
    }
}