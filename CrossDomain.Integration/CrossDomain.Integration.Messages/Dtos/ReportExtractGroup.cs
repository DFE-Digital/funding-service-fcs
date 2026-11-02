namespace SFA.FCT.CrossDomain.Integration.Messages.Dtos
{
    using System.Collections.Generic;
    public class ReportExtractGroup
    {
        public IEnumerable<string> FspCodes { get; set; }

        public string ExtractName { get; set; }

        /// <summary>
        /// This is for testing only
        /// </summary>
        public string Suffix { get; set; } = string.Empty;

        public bool ArchiveClosedContracts { get; set; }

        public override string ToString()
        {
            return $"ExtractName: {ExtractName}, Fsps: {string.Join(",", FspCodes)}, ArchiveClosedContracts: {ArchiveClosedContracts}";
        }
    }
}
