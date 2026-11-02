namespace PaymentGenerationDomain.BusinessLogic
{
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IOutstandingPaymentsChecker
    {
        bool HasOutstandingPaymentsForAllocation(string fundingStreamPeriodCode, string allocationNumber, ConnectionInfo connectionInfo);
    }
}
