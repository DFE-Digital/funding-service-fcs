namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using ExcelTypes;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class ContractTypeSynchronizer : ContractTypeReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<ContractTypeSheetType> contractTypeRows = ReadConfig(worksheetReader);

            ContractTypeWriter.WriteToPaaSDatabase(contractTypeRows, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<ContractTypeSheetType> contractTypeRows = ReadConfig(worksheetReader);

            ContractTypeWriter.WriteToPaaSDatabase(contractTypeRows, WriterBehaviour.Delete);
        }
    }
}
