namespace FCT.Operations.Cda.ReportGeneration
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Dtos;
    using Extensions;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Dtos;

    public class ReportCreationService : IReportCreationService
    {
        private readonly IClosedContractRepository _closedContractRepository;
        private readonly IOverrideDateRepository _overrideDateRepository;

        public ReportCreationService(
            IClosedContractRepository closedContractRepository,
            IOverrideDateRepository overrideDateRepository)
        {
            _closedContractRepository = closedContractRepository;
            _overrideDateRepository = overrideDateRepository;
        }

        public async Task<IReadOnlyCollection<Report>> GetReports(
            IReadOnlyCollection<CdaRow> rows,
            IEnumerable<ReportExtractGroup> reportExtractGroups,
            bool isLatest,
            ConnectionInfo connectionInfo)
        {
            var fspGroups = rows.ToLookup(r => r.FundingStreamPeriodCode);
            var currentDate = await _overrideDateRepository.GetDate(connectionInfo);
            var lastYear = currentDate.Year - 1;
            var isLastApproved = !isLatest;

            return reportExtractGroups.SelectMany(extractGroup =>
            {
                string suffix = string.IsNullOrEmpty(extractGroup.Suffix) ? string.Empty : $"{extractGroup.Suffix}";
                string extractName = string.IsNullOrEmpty(extractGroup.ExtractName)
                    ? string.Empty
                    : extractGroup.ExtractName;
                List<Report> reports = new List<Report>();
                List<CdaRow> groupRows = extractGroup.FspCodes.SelectMany(fspCode => fspGroups[fspCode]).ToList();
                if (extractGroup.ArchiveClosedContracts)
                {
                    var contractNumbersClosedInPreviousYears = _closedContractRepository
                        .GetContractNumbersClosedInPreviousYears(extractGroup.FspCodes, lastYear, connectionInfo)
                        .Result;

                    var openAndClosedCdaRows = groupRows.SplitToOpenAndClosed(contractNumbersClosedInPreviousYears);
                    groupRows = openAndClosedCdaRows.OpenContractRows;

                    if (isLastApproved)
                    {
                        reports.AddRange(openAndClosedCdaRows.ClosedYears.Select(closedYear => new Report(closedYear.closedContractRows,
                            $"CDA {extractName} (Closed in {closedYear.year}).csv", isArchiveClosedContractReport:true)
                        {
                            ArchivedYear = closedYear.year
                        }));
                    }
                }

                if (isLatest)
                {
                    Report latestReport = new Report(groupRows, $"CDA Latest Version {extractName}{suffix}.csv");
                    reports.Add(latestReport);
                }
                else
                {
                    Report lastApprovedReport =
                        new Report(groupRows, $"CDA Last Approved Version {extractName}{suffix}.csv");
                    reports.Add(lastApprovedReport);
                }

                return reports;
            }).ToList();
        }
    }
}

    
