namespace PaymentManagement.Calculation.Repositories
{
    using System.Collections.Generic;
    using Dtos;
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;

    public interface IDeliverablePaymentRepository
    { 
        IReadOnlyCollection<DeliverablePeriodPaymentInfo> GetDeliverablePeriodPaymentInfos(string allocationNumber, int versionNumber, ConnectionInfo connectionInfo);

        void AddOrUpdateDeliverablePaymentsWithActualValues(ContractAllocationActualsType contractAllocationActualsType, ConnectionInfo connectionInfo);

        void AddOrUpdateDeliverablePaymentsWithCalculatedValues(string allocationNumber, int versionNumber, AllocationDeliverable allocationDeliverable, ConnectionInfo connectionInfo);

        void PersistPaymentScheduleAndActuals(Allocation paymentSchedule, ConnectionInfo connectionInfo);

        IReadOnlyCollection<DeliverablePeriodActualAndPaymentInfo> GetDeliverablePeriodActualsAndPaymentValues(string allocationNumber, int versionNumber, ConnectionInfo connectionInfo);
    }
}