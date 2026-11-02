namespace PaymentGenerationDomain.Integration.DataStore.Repositories
{
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IPaymentTimetableRepository
    {
        bool HasOutstandingPaymentTimetablesForFundingStreamPeriod(string fundingStreamPeriodCode, ConnectionInfo connectionInfo);
    }
}
