namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using ExcelTypes;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class FundingAllocationCfsCodesToContractTypeSynchronizer : CfsCodesToContractTypeReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IReadOnlyCollection<CfsCodesToContractTypeSheetType> cfsCodesToContractTypeSheetTypes = ReadConfig(worksheetReader);

            FundingAllocationCfsCodesToContractTypeConfigWriter.WriteToPaaSDatabase(cfsCodesToContractTypeSheetTypes, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            IReadOnlyCollection<CfsCodesToContractTypeSheetType> cfsCodesToContractTypeSheetTypes = ReadConfig(worksheetReader);

            FundingAllocationCfsCodesToContractTypeConfigWriter.WriteToPaaSDatabase(cfsCodesToContractTypeSheetTypes, WriterBehaviour.Delete);
        }
    }
}