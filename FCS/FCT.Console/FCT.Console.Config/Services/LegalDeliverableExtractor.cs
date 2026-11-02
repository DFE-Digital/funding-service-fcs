namespace FCT.Console.Config.Services
{
    using ExcelTypes;
    using System.Collections.Generic;
    using System.Linq;
    using MoreLinq;

    public static class LegalDeliverableExtractor
    {
        public static IReadOnlyCollection<FundingStreamPeriodDeliverablesSheetType> ExtractLegalDeliverables(
            IReadOnlyCollection<FundingStreamPeriodDeliverablesSheetType> fundingStreamPeriodDeliverablesSheetTypes)
        {
            List<FundingStreamPeriodDeliverablesSheetType> legalDeliverableSheetTypes = new List<FundingStreamPeriodDeliverablesSheetType>();

            fundingStreamPeriodDeliverablesSheetTypes
                .GroupBy(sheet => sheet.FundingStreamPeriodCode)
                .ForEach(fspGrouping =>
                {
                    IDictionary<int, DeliverableInfo> fspDeliverables =
                        fspGrouping.ToDictionary(d => d.DeliverableCode,
                            d => new DeliverableInfo(d, d.ParentDeliverableCode, d.AllowProfile));

                    fspDeliverables
                        .Where(d => d.Value.ParentDeliverableCode.HasValue)
                        .ForEach(d =>
                        {
                            fspDeliverables[d.Value.ParentDeliverableCode.Value].ChildDeliverables.Add(d.Value);
                        });

                    legalDeliverableSheetTypes.AddRange(
                        fspDeliverables
                            .Where(g => g.Value.IsLegalDeliverable())
                            .Select(g => g.Value.FundingStreamPeriodSheetType)
                            .ToList());
                });
            return legalDeliverableSheetTypes;
        }

        private class DeliverableInfo
        {
            private readonly bool _allowProfile;

            public DeliverableInfo(FundingStreamPeriodDeliverablesSheetType fundingStreamPeriodSheetType,int? parentDeliverableCode, bool allowProfile)
            {
                FundingStreamPeriodSheetType = fundingStreamPeriodSheetType;
                ParentDeliverableCode = parentDeliverableCode;
                _allowProfile = allowProfile;
                ChildDeliverables = new List<DeliverableInfo>();
            }

            public int? ParentDeliverableCode { get; }

            public IList<DeliverableInfo> ChildDeliverables { get; }

            public  FundingStreamPeriodDeliverablesSheetType FundingStreamPeriodSheetType { get; }

            public bool IsLegalDeliverable()
            {
                return _allowProfile || ChildDeliverables.Any(d => d.IsLegalDeliverable());
            }
        }
    }
}
