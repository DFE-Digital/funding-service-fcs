namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using ExcelTypes;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class PayGenSubnominalSynchronizer : SubnominalsReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<SubnominalsSheetType> subnominals = ReadConfig(worksheetReader);

            PayGenSubnominalWriter.WriteToPaaSDatabase(subnominals, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<SubnominalsSheetType> subnominals = ReadConfig(worksheetReader);

            PayGenSubnominalWriter.WriteToPaaSDatabase(subnominals, WriterBehaviour.Delete);
        }
    }
}