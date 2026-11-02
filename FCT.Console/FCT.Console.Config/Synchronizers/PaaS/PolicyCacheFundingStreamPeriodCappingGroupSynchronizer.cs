namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using ExcelTypes;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class PolicyCacheFundingStreamPeriodCappingGroupSynchronizer : FundingStreamPeriodCappingGroupsReader, ISynchronizeConfig
    {

        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<FundingStreamPeriodCappingGroupSheetType> subnominals = ReadConfig(worksheetReader);

            PolicyCacheFundingStreamPeriodCappingGroupWriter.WriteToPaaSDatabase(subnominals, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<FundingStreamPeriodCappingGroupSheetType> subnominals = ReadConfig(worksheetReader);

            PolicyCacheFundingStreamPeriodCappingGroupWriter.WriteToPaaSDatabase(subnominals, WriterBehaviour.Delete);
        }
    }
}