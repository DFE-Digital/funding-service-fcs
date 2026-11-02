namespace FCT.Console.Config.Synchronizers.PaaS
{
    using System.Collections.Generic;
    using Excel;
    using ExcelTypes;
    using Readers;
    using Writers;
    using Writers.PAAS;

    public class PolicyCacheFundingStreamPeriodPayCalcPolicySynchronizer : FundingStreamPeriodPayCalcPolicyReader, ISynchronizeConfig
    {
        public void AddOrUpdateConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<FundingStreamPeriodPayCalcPolicySheetType> rows = ReadConfig(worksheetReader);

            PolicyCacheFundingStreamPeriodPayCalcPolicyWriter.WriteToPaasDatabase(rows, WriterBehaviour.AddOrUpdate);
        }

        public void DeleteConfig(IWorksheetReader worksheetReader)
        {
            IEnumerable<FundingStreamPeriodPayCalcPolicySheetType> rows = ReadConfig(worksheetReader);

            PolicyCacheFundingStreamPeriodPayCalcPolicyWriter.WriteToPaasDatabase(rows, WriterBehaviour.Delete);
        }
    }
}
