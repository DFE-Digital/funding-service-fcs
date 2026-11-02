namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using ExcelTypes;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class DocumentsDomainContractReferenceConfigSynchronizer : ContractReferenceDataReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<ContractReferenceDataSheet> rows = ReadConfig(worksheetReader);

            DocumentsDomainContractReferenceConfigWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<ContractReferenceDataSheet> rows = ReadConfig(worksheetReader);

            DocumentsDomainContractReferenceConfigWriter.WriteToPaaSDatabase(rows, WriterBehaviour.Delete);
        }
    }
}