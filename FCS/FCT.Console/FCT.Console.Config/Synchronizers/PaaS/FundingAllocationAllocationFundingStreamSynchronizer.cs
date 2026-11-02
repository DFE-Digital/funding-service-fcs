namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using ExcelTypes;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class FundingAllocationAllocationFundingStreamSynchronizer : AllocationFundingStreamReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IReadOnlyCollection<AllocationFundingStreamSheetType> allocationFundingStreamSheetTypes = ReadConfig(worksheetReader);

            FundingAllocationAllocationFundingStreamConfigWriter.WriteToPaaSDatabase(allocationFundingStreamSheetTypes, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            IReadOnlyCollection<AllocationFundingStreamSheetType> allocationFundingStreamSheetTypes = ReadConfig(worksheetReader);

            FundingAllocationAllocationFundingStreamConfigWriter.WriteToPaaSDatabase(allocationFundingStreamSheetTypes, WriterBehaviour.Delete);
        }
    }
}