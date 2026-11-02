namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using ExcelTypes;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class FundingAllocationFundingStreamPeriodConfigSynchronizer : FundingStreamPeriodReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IReadOnlyCollection<FundingStreamPeriodSheetType> sheetRows = ReadConfig(worksheetReader);

            FundingAllocationFundingStreamPeriodConfigWriter.WriteToPaaSDatabase(sheetRows, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            IReadOnlyCollection<FundingStreamPeriodSheetType> sheetRows = ReadConfig(worksheetReader);

            FundingAllocationFundingStreamPeriodConfigWriter.WriteToPaaSDatabase(sheetRows, WriterBehaviour.Delete);
        }
    }
}