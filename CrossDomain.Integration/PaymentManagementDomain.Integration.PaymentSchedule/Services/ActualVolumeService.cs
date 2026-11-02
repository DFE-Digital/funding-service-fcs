namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Dtos;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;
    using Allocation = CrossDomain.Integration.Entities.PaymentSchedule.Allocation;

    public class ActualVolumeService : IActualVolumeService
    {
        private readonly IDeliverablePaymentRepository _deliverablePaymentRepository;
        private readonly IAllocationRepository _allocationRepository;

        public ActualVolumeService(IDeliverablePaymentRepository deliverablePaymentRepository, IAllocationRepository allocationRepository)
        {
            _deliverablePaymentRepository = deliverablePaymentRepository;
            _allocationRepository = allocationRepository;
        }

        public void UpdatePaymentScheduleWithPreviousVersionVolume(Allocation paymentScheduleForAllocation, ConnectionInfo connectionInfo)
        {
            string allocationNumber = paymentScheduleForAllocation.AllocationNumber;

            if (_allocationRepository.HasPreviousAllocationVersion(
                allocationNumber,
                paymentScheduleForAllocation.VersionNumber,
                connectionInfo))
            {
                int previousVersion = _allocationRepository.GetPreviousApprovedContractVersionNumberFromPaymentSchedule(
                    allocationNumber,
                    paymentScheduleForAllocation.VersionNumber, connectionInfo);

                var previousDeliverablePayments = _deliverablePaymentRepository.GetDeliverablePeriodActualVolumesForAllocation(allocationNumber, previousVersion, connectionInfo);

                UpdatePaymentScheduleVolumeWithPreviousValues(paymentScheduleForAllocation,
                    previousDeliverablePayments);
            }
        }

        private static void UpdatePaymentScheduleVolumeWithPreviousValues(Allocation paymentScheduleForAllocation, IReadOnlyCollection<DeliverablePeriodActualVolume> previousDeliverablePayments)
        {
            paymentScheduleForAllocation.AllocationDeliverables.ForEach(ad =>
            {
                ad.ScheduledPayments.ForEach(sp =>
                    {
                        var previousDeliverablePayment = previousDeliverablePayments.FirstOrDefault(dp =>
                            dp.Period == sp.Period && dp.DeliverableCode == ad.DeliverableCode);

                        sp.ActualVolume = previousDeliverablePayment?.Volume;
                    });
            });
        }
    }
}
