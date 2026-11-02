namespace FCT.Operations.FundingConfirmationReport.Services
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using DTOs;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IReportService
    {
        Task<IReadOnlyCollection<ReportRow>> GetReportRows(Period period, ConnectionInfo connectionInfo);       
    }
}