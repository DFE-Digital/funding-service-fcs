namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using ExcelTypes;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class PolicyCacheESFRegionInvestmentPrioritySynchronizer : ESFRegionInvestmentPriorityReader, ISynchronizeConfig
    {

        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<ESFRegionInvestmentPrioritySheetType> subnominals = ReadConfig(worksheetReader);

            PolicyCacheESFRegionInvestmentPriorityWriter.WriteToPaaSDatabase(subnominals, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<ESFRegionInvestmentPrioritySheetType> subnominals = ReadConfig(worksheetReader);

            PolicyCacheESFRegionInvestmentPriorityWriter.WriteToPaaSDatabase(subnominals, WriterBehaviour.Delete);
        }
    }
}