namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.AllocationActuals;
    using CrossDomain.Integration.Entities.Data;
    using CrossDomain.Integration.Entities.DeliveryAllocation;
    using PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;
    using PolicyCache.DataStore.Model;
    using PolicyCache.DataStore.Repositories;

    public class NonCalculationPaymentScheduleCreator : IPaymentScheduleCreator
    {
        private readonly IPreviousPaymentScheduleCopier _prevPaymentScheduleCopier;
        private readonly IPayCalcPolicyQueryRepository _payCalcPolicyQueryRepository;
        private readonly IDeliverablePaymentRepository _deliverablePaymentRepository;

        public NonCalculationPaymentScheduleCreator(
            IPreviousPaymentScheduleCopier prevPaymentScheduleCopier,
            IPayCalcPolicyQueryRepository payCalcPolicyQueryRepository,
            IDeliverablePaymentRepository deliverablePaymentRepository)
        {
            _prevPaymentScheduleCopier = prevPaymentScheduleCopier;
            _payCalcPolicyQueryRepository = payCalcPolicyQueryRepository;
            _deliverablePaymentRepository = deliverablePaymentRepository;
        }

        public PaymentScheduleWithPayments CreatePaymentScheduleFromAllocation(allocationType deliveryAllocation, ConnectionInfo connectionInfo)
        {
            PolicyFundingStreamPeriod fsp = _payCalcPolicyQueryRepository.GetFundingStreamPeriod(
                deliveryAllocation.fundingStreamPeriod.fundingStreamPeriodCode, connectionInfo);

            CrossDomain.Integration.Entities.PaymentSchedule.Allocation scheduleAllocation = DeliveryAllocationToPaymentScheduleAllocationTransformer
                                                  .ToPaymentScheduleAllocation(deliveryAllocation);
            
            _prevPaymentScheduleCopier.CopyPreviousReplacedValuesOntoPaySchedule(scheduleAllocation.AllocationNumber, scheduleAllocation, connectionInfo);
            
            IReadOnlyCollection<DeliverablePayment> deliverablePayments = PaymentScheduleAllocationToDeliverablePaymentTransformer
                                                    .ToDeliverablePayments(scheduleAllocation);

            return new PaymentScheduleWithPayments(deliverablePayments, scheduleAllocation);
        }

        public PaymentScheduleWithPayments CreatePaymentScheduleFromActuals(ContractAllocationActualsType allocationActuals, ConnectionInfo connectionInfo)
        {
            CrossDomain.Integration.Entities.PaymentSchedule.Allocation paymentScheduleForAllocation = ContractAllocationActualsTypeTransformer.ToPaymentScheduleAllocation(allocationActuals);

            IReadOnlyCollection<DeliverablePayment> newDeliverablePayments = PaymentScheduleAllocationToDeliverablePaymentTransformer.ToDeliverablePayments(paymentScheduleForAllocation);

            // now add planned values to the deliverable payments
            var existingDeliverablePayments = _deliverablePaymentRepository.GetDeliverablePaymentsForAllocation(
                allocationActuals.ContractAllocationNumber, allocationActuals.ContractReference.ContractVersionNumber, connectionInfo);

            newDeliverablePayments.ToList().ForEach(dp => UpdatePlannedValueAndVolumeFromExisting(dp, existingDeliverablePayments));

            return new PaymentScheduleWithPayments(newDeliverablePayments, paymentScheduleForAllocation);
        }

        private void UpdatePlannedValueAndVolumeFromExisting(DeliverablePayment deliverablePayment, IReadOnlyCollection<DeliverablePayment> deliverablePaymentsFromDb)
        {
            var matchingDeliverablePaymentInDb = deliverablePaymentsFromDb.Single(dp => dp.AllocationNumber == deliverablePayment.AllocationNumber &&
                                                   dp.VersionNumber == deliverablePayment.VersionNumber &&
                                                   dp.DeliverableCode == deliverablePayment.DeliverableCode &&
                                                   dp.Period == deliverablePayment.Period);

            deliverablePayment.PlannedValue = matchingDeliverablePaymentInDb.PlannedValue;
            deliverablePayment.PlannedVolume = matchingDeliverablePaymentInDb.PlannedVolume;
        }
    }
}
