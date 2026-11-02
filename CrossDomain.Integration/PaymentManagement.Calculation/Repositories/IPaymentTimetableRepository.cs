namespace PaymentManagement.Calculation.Repositories
{
    using System;
    using System.Collections.Generic;
    using Dtos;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IPaymentTimetableRepository
    {
        IReadOnlyCollection<CensusPeriodInfo> GetFundingStreamPeriodCensusPeriodInfos(string fundingStreamPeriodCode, ConnectionInfo connectionInfo);

        CensusPeriodInfo GetCensusPeriodInfo(string fundingStreamPeriodCode, DateTime currentDate, ConnectionInfo connectionInfo);
    }
}