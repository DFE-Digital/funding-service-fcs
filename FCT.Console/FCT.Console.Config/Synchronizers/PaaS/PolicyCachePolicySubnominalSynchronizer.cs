namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using ExcelTypes;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class PolicyCachePolicySubnominalSynchronizer : SubnominalPaymentTypesReader, ISynchronizeConfig, IInitializeConfigStorage
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<SubnominalsSheetType> subnominals = ReadConfig(worksheetReader);

            PolicyCachePolicySubnominalWriter.WriteToPaaSDatabase(subnominals, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<SubnominalsSheetType> subnominals = ReadConfig(worksheetReader);

            PolicyCachePolicySubnominalWriter.WriteToPaaSDatabase(subnominals, WriterBehaviour.Delete);
        }

        public void InitializeConfigStorage()
        {
            PolicyCachePolicySubnominalWriter.ClearPaasDatabaseTable();
        }
    }
}