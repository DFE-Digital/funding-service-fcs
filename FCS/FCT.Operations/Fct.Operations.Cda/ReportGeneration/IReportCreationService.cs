namespace FCT.Operations.Cda.ReportGeneration
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Dtos;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Dtos;

    public interface IReportCreationService
    {
        Task<IReadOnlyCollection<Report>> GetReports(
            IReadOnlyCollection<CdaRow> rows,
            IEnumerable<ReportExtractGroup> reportExtractGroups,
            bool isLatest,
            ConnectionInfo connectionInfo);
    }
}