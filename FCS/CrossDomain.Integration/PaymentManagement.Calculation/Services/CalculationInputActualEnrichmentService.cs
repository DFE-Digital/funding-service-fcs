namespace PaymentManagement.Calculation.Services
{
    using System.Collections.Generic;
    using Dtos;
    using Optional;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class CalculationInputActualEnrichmentService : IActualEnrichmentService
    {
        private readonly IDeliverablePaymentRepository _deliverablePaymentRepository;
        private readonly IAllocationQueryRepository _allocationQueryRepository;

        public CalculationInputActualEnrichmentService(
            IDeliverablePaymentRepository deliverablePaymentRepository,
            IAllocationQueryRepository allocationQueryRepository)
        {
            _deliverablePaymentRepository = deliverablePaymentRepository;
            _allocationQueryRepository = allocationQueryRepository;
        }

        public Option<IReadOnlyCollection<DeliverablePeriodActualAndPaymentInfo>> GetPreviousVersionActualsAndPaymentValuesIfPresent(string allocationNumber, int versionNumber,
            ConnectionInfo connectionInfo)
        {
            var optionalPreviousVersion = _allocationQueryRepository.GetPreviousVersion(
                allocationNumber,
                versionNumber,
                connectionInfo);

            return optionalPreviousVersion.Match(some:prevVersion => _deliverablePaymentRepository.GetDeliverablePeriodActualsAndPaymentValues(
                    allocationNumber,
                    prevVersion,
                    connectionInfo).Some(),
                none:() => new Option<IReadOnlyCollection<DeliverablePeriodActualAndPaymentInfo>>());
        }
    }
}
