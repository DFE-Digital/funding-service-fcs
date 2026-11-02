namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using SFA.FCT.DocumentsDomain.DataStore.Models;
    using SFA.FCT.DocumentsDomain.DataStore;

    public static class DocumentsDomainFundingStreamPeriodWriter
    {
        public static void WriteToPaaSDatabase(IReadOnlyCollection<FundingStreamPeriodSheetType> rows, WriterBehaviour behaviour)
        {
            using (var context = new DocumentsDomainDbContext())
            {
                ConfigWriter<FundingStreamPeriodSheetType, FundingStreamPeriod> writer =
                    new ConfigWriter<FundingStreamPeriodSheetType, FundingStreamPeriod>(context, context.FundingStreamPeriods);

                writer.Write(rows, TransformSheetTypesToEntities, GetKeyFundingStreamPeriod, behaviour);

                context.SaveChanges();
            }
        }

        private static IEnumerable<FundingStreamPeriod> TransformSheetTypesToEntities(IEnumerable<FundingStreamPeriodSheetType> sheetTypes)
        {
            return sheetTypes.Select(st => new FundingStreamPeriod(
                st.FundingStreamPeriodCode,
                st.SummaryOfFundingDisplayName,
                st.ContractDocumentDisplayOrder,
                st.ShouldGenerateFundingAgreement,
                st.ShouldUseContractAllocationDescription,
                st.Template,
                st.ExtraPagesTemplate,
                st.FSPGroup,
                st.FundingAgreementDisplayName)
            );
        }

        private static object[] GetKeyFundingStreamPeriod(FundingStreamPeriod entity)
        {
            return new object[] { entity.FundingStreamPeriodCode };
        }
    }
}
