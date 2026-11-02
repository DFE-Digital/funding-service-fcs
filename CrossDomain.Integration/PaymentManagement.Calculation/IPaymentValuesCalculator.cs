namespace PaymentManagement.Calculation
{
    using System.Collections.Generic;
    using Dtos;
    using Optional;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;

    public interface IPaymentValuesCalculator
    {
        Option<Allocation> ProducePaymentScheduleForCurrentPeriodOnActualsReceived(CalculationAllocationInput allocation, ConnectionInfo connectionInfo);

        bool IsFspCalculatedWithOpaReplacement(string fsp, ConnectionInfo connectionInfo);

        Allocation ProducePaymentScheduleForCurrentPeriodOnApproval(
            CalculationAllocationInput allocation,
            Option<IReadOnlyCollection<DeliverablePeriodActualAndPaymentInfo>> previousVersionPaymentInfoOptional,
            ConnectionInfo connectionInfo);
    }
}