namespace PaymentManagement.Calculation.Services
{
    using Dtos;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface ICensusDateService
    {
        CensusPeriodInfo GetCensusPeriodInfo(string fundingStreamPeriodCode, ConnectionInfo connectionInfo);
    }
}