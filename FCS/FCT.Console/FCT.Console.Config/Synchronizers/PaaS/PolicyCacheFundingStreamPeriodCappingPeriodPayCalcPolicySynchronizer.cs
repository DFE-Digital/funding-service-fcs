namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using ExcelTypes;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class PolicyCacheFundingStreamPeriodCappingPeriodPayCalcPolicySynchronizer : FundingStreamPeriodCappingPeriodPayCalcPolicyReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<FundingStreamPeriodCappingPeriodPayCalcPolicySheetType> rows = ReadConfig(worksheetReader);

            PolicyCacheFundingStreamPeriodCappingPeriodPayCalcPolicyWriter.WriteToPaasDatabase(rows, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<FundingStreamPeriodCappingPeriodPayCalcPolicySheetType> rows = ReadConfig(worksheetReader);

            PolicyCacheFundingStreamPeriodCappingPeriodPayCalcPolicyWriter.WriteToPaasDatabase(rows, WriterBehaviour.Delete);
        }
    }
}