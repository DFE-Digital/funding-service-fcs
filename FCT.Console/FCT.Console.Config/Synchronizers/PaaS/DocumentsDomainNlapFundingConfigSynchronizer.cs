namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using ExcelTypes;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class DocumentsDomainNlapFundingConfigSynchronizer : NlapFundingConfigReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<NlapFundingConfigSheet> rows = ReadConfig(worksheetReader);

            DocumentsDomainNlapFundingConfigWriter.WriteToPaasDatabase(rows, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<NlapFundingConfigSheet> rows = ReadConfig(worksheetReader);

            DocumentsDomainNlapFundingConfigWriter.WriteToPaasDatabase(rows, WriterBehaviour.Delete);
        }
    }
}
