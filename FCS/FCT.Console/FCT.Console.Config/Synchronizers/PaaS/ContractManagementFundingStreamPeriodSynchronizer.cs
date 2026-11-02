namespace FCT.Console.Config.Synchronizers.PaaS
{
    using Excel;
    using Readers;
    using System.Collections.Generic;
    using ExcelTypes;
    using Writers;
    using Writers.PAAS;

    public class ContractManagementFundingStreamPeriodSynchronizer : FundingStreamPeriodReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<FundingStreamPeriodSheetType> sheetObjects = ReadConfig(worksheetReader);

            ContractManagementFundingStreamPeriodWriter.WriteToPaaSDatabase(sheetObjects, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<FundingStreamPeriodSheetType> sheetObjects = ReadConfig(worksheetReader);

            ContractManagementFundingStreamPeriodWriter.WriteToPaaSDatabase(sheetObjects, WriterBehaviour.Delete);
        }
    }
}