namespace FCT.Console.Config.Synchronizers.Writers.CRM
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using MoreLinq;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    public class CrmDeliverableWriter : CrmConfigWriter<DeliverablesSheetType, sfa_deliverable>
    {
        private IDictionary<string, IList<sfa_deliverable>> _allFundingStreamDeliverables  = new Dictionary<string, IList<sfa_deliverable>>();
        private readonly IDictionary<string, sfa_fundingstream> _allFundingStreams = new Dictionary<string, sfa_fundingstream>();

        protected override void UpdateMatchingEntity(DeliverablesSheetType row, sfa_deliverable matchingDeliverable)
        {
            matchingDeliverable.sfa_DeliverableName = row.DeliverableName;
            matchingDeliverable.sfa_BusinessCode = row.BusinessCode;
            matchingDeliverable.sfa_DeliverableStatusEnum = (sfa_deliverablestatus)Enum.Parse(typeof(sfa_deliverablestatus), row.Status, ignoreCase:true);
            matchingDeliverable.sfa_EffectiveDate = row.EffectiveDate;
        }

        protected override sfa_deliverable CreateEntity(DeliverablesSheetType row)
        {
            var fundingStreamEntity = _allFundingStreams[row.FundingStreamCode];

            sfa_deliverable deliverable = new sfa_deliverable
            {
                sfa_DeliverableCode = row.DeliverableCode,
                sfa_DeliverableName = row.DeliverableName,
                sfa_BusinessCode = row.BusinessCode,
                sfa_FundingStreamId = fundingStreamEntity.ToEntityReference(),
                sfa_DeliverableStatusEnum =
                    (sfa_deliverablestatus) Enum.Parse(typeof (sfa_deliverablestatus), row.Status),
                sfa_EffectiveDate = row.EffectiveDate
            };

            return deliverable;
        }

        protected override IEnumerable<sfa_deliverable> GetMatchingEntities(XrmServiceContext crmContext, DeliverablesSheetType row)
        {
            if (!_allFundingStreamDeliverables.Any())
            {
                _allFundingStreamDeliverables = GetAllFundingStreamAndDeliverableEntities(crmContext);
            }

            if (row.PolicyStatus == PolicyStatus.Removed && !_allFundingStreamDeliverables.ContainsKey(row.FundingStreamCode))
            {
                return Enumerable.Empty<sfa_deliverable>();
            }

            return _allFundingStreamDeliverables[row.FundingStreamCode].Where(d => d.sfa_DeliverableCode == row.DeliverableCode);
        }

        private IDictionary<string, IList<sfa_deliverable>> GetAllFundingStreamAndDeliverableEntities(XrmServiceContext crmContext)
        {
            var fundingStreamDeliverables = new Dictionary<string, IList<sfa_deliverable>>();

            IReadOnlyCollection<sfa_fundingstream> fundingStreams = GetCrmFundingStreams(crmContext);
            IReadOnlyCollection<sfa_deliverable> deliverables = GetCrmDeliverables(crmContext);

            PopulateAllFundingStreams(fundingStreams);

            AddAllFundingStreamsToDictionary(fundingStreams, fundingStreamDeliverables);

            foreach (var sfaDeliverable in deliverables)
            {
                var deliverableFundingStreamCode = fundingStreams
                    .Single(fs => fs.Id == sfaDeliverable.sfa_FundingStreamId.Id)
                    .sfa_fundingstreamcode;

                if (fundingStreamDeliverables.ContainsKey(deliverableFundingStreamCode))
                {
                    fundingStreamDeliverables[deliverableFundingStreamCode].Add(sfaDeliverable);
                }
            }

            return fundingStreamDeliverables;
        }

        private void PopulateAllFundingStreams(IEnumerable<sfa_fundingstream> fundingstreams)
        {
            fundingstreams.ForEach(fs => _allFundingStreams.Add(fs.sfa_fundingstreamcode, fs));
        }

        private void AddAllFundingStreamsToDictionary(IReadOnlyCollection<sfa_fundingstream> fundingStreams, Dictionary<string, IList<sfa_deliverable>> fundingStreamDictionary)
        {
            fundingStreams.ForEach(fs => fundingStreamDictionary.Add(fs.sfa_fundingstreamcode, new List<sfa_deliverable>()));
        }

        private static IReadOnlyCollection<sfa_deliverable> GetCrmDeliverables(XrmServiceContext crmContext)
        {
            return (from d in crmContext.sfa_deliverableSet
                   select d).ToList();
        }

        private static IReadOnlyCollection<sfa_fundingstream> GetCrmFundingStreams(XrmServiceContext crmContext)
        {
            return (from fs in crmContext.sfa_fundingstreamSet
                   select fs).ToList();
        }
    }
}
