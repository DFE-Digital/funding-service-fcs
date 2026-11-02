namespace ContractManagement.DataStore.Dtos
{
    using System.Collections.Generic;

    public class ReportConfig
    {
        public ReportConfig(string description, List<string> reportFspCodes)
        {
            Description = description;
            ReportFspCodes = reportFspCodes;
        }

        public string Description { get; }

        public List<string> ReportFspCodes { get; }

        public override string ToString()
        {
            return string.Join(",", ReportFspCodes);
        }
    }
}
