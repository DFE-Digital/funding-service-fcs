namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using ExcelTypes;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class FundingAllocationFundingTypeConfigSynchronizer : FundingTypeReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IReadOnlyCollection<FundingTypeSheetType> sheetRows = ReadConfig(worksheetReader);

            FundingAllocationFundingTypeConfigWriter.WriteToPaaSDatabase(sheetRows, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            IReadOnlyCollection<FundingTypeSheetType> sheetRows = ReadConfig(worksheetReader);

            FundingAllocationFundingTypeConfigWriter.WriteToPaaSDatabase(sheetRows, WriterBehaviour.Delete);
        }
    }
}