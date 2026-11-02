namespace FCT.Operations.FundingConfirmationReport.Services
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using DTOs;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IlaReportService
    {
         Task<IReadOnlyCollection<ReportRow>> GetLAReportRows(Period period, ConnectionInfo connectionInfo);
    }
}