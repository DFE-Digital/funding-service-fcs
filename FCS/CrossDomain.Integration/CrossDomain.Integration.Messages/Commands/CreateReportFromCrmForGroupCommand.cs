namespace SFA.FCT.CrossDomain.Integration.Messages.Commands
{
    using System.Collections.Generic;
    using System.Linq;
    using Dtos;

    public class CreateReportFromCrmForGroupCommand
    {
        public IEnumerable<ReportExtractGroup> ExtractGroups { get; set; } = new List<ReportExtractGroup>();

        public bool ShouldArchive { get; set; }

        public bool IsLatest { get; set; }

        public override string ToString()
        {
            return $"Extracts: {ExtractGroups.Count()}, Extracts: {string.Join(",", ExtractGroups.Select(g => g.ExtractName))}, Latest: {IsLatest}";
        }
    }
}
