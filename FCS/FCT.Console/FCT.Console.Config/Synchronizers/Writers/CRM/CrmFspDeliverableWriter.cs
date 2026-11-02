namespace FCT.Console.Config.Synchronizers.Writers.CRM
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    public class CrmFspDeliverableWriter : CrmConfigWriter<FundingStreamPeriodDeliverablesSheetType, sfa_fundingstreamperioddeliverable>
    {
        private IDictionary<string, IList<sfa_fundingstreamperioddeliverable>> _allFundingStreamPeriodDeliverables = new Dictionary<string, IList<sfa_fundingstreamperioddeliverable>>();
        private IDictionary<Guid, sfa_deliverable> _allDeliverables = new Dictionary<Guid, sfa_deliverable>();
        private readonly IDictionary<string, sfa_fundingstreamperiod> _allFundingStreamPeriods = new Dictionary<string, sfa_fundingstreamperiod>();
        private readonly IDictionary<string, EntityReference> _fundingStreamEntityReferences = new Dictionary<string, EntityReference>(); 

        protected override void UpdateMatchingEntity(FundingStreamPeriodDeliverablesSheetType row,
            sfa_fundingstreamperioddeliverable matchingFsp)
        {
            sfa_fundingstreamperioddeliverable parentDel = null;
            var matchingDel = _allFundingStreamPeriodDeliverables[row.FundingStreamPeriodCode]
                .Single(d => d.sfa_DeliverableCode == row.DeliverableCode);

            var del = _allDeliverables[matchingDel.sfa_DeliverableId.Id];

            if (row.ParentDeliverableCode != null)
            {
                parentDel = GetParentDeliverable(row);
            }

            matchingFsp.sfa_name = row.DeliverableName;
            matchingFsp.sfa_ParentDeliverableId = parentDel?.ToEntityReference();
            matchingFsp.sfa_setting_AllowActuals = row.AllowActuals;
            matchingFsp.sfa_setting_AllowPayment = row.AllowPayment;
            matchingFsp.sfa_setting_AllowProfile = row.AllowProfile;
            matchingFsp.sfa_DeliverableId = del.ToEntityReference();
            matchingFsp.sfa_setting_PlanningUnitEnum = ParsePlanningUnit(row.PlanningUnit);
            matchingFsp.sfa_setting_AllowCustomDeliverableDescription = row.AllowCustomDeliverableDesc;
            matchingFsp.sfa_PaymentCappingGroup =
                CrmOptionSetFactory.CreateCappingGroupFromString(row.DeliverableCappingGroup);
            matchingFsp.sfa_setting_displayorder =row.DisplayOrder;
            matchingFsp.sfa_setting_Mandatory = row.IsMandatory;
            matchingFsp.sfa_FundingStreamId = GetFundingStreamIdForFundingStreamPeriod(row.FundingStreamPeriodCode);

            if (matchingFsp.sfa_ParentDeliverableId != null)
            {
                matchingFsp.sfa_ParentDeliverableTypeEnum =
                    (sfa_fundingstreamperioddeliverable_sfa_parentdeliverabletype)Enum.Parse(
                        typeof(sfa_fundingstreamperioddeliverable_sfa_parentdeliverabletype),
                        row.DeliverableRelationshipType);
            }
        }

        protected override sfa_fundingstreamperioddeliverable CreateEntity(FundingStreamPeriodDeliverablesSheetType row)
        {
            sfa_fundingstreamperioddeliverable parentDel = null;

            var fsp = _allFundingStreamPeriods[row.FundingStreamPeriodCode];

            sfa_deliverable del = GetMatchingDeliverable(row.DeliverableCode, row.FundingStreamPeriodCode);

            if (row.ParentDeliverableCode != null)
            {
                parentDel = GetParentDeliverable(row);
            }

            sfa_fundingstreamperioddeliverable fspDeliverable = new sfa_fundingstreamperioddeliverable
            {
                sfa_DeliverableCode = row.DeliverableCode,
                sfa_ParentDeliverableId = parentDel?.ToEntityReference(),
                sfa_name = row.DeliverableName,
                sfa_setting_AllowActuals = row.AllowActuals,
                sfa_setting_AllowPayment = row.AllowPayment,
                sfa_setting_AllowProfile = row.AllowProfile,
                sfa_FundingStreamPeriodId = fsp.ToEntityReference(),
                sfa_DeliverableId = del.ToEntityReference(),
                sfa_setting_PlanningUnitEnum = ParsePlanningUnit(row.PlanningUnit),
                sfa_setting_AllowCustomDeliverableDescription = row.AllowCustomDeliverableDesc,
                sfa_fundingstreamperioddeliverableId = Guid.NewGuid(),
                sfa_PaymentCappingGroup = CrmOptionSetFactory.CreateCappingGroupFromString(row.DeliverableCappingGroup),
                sfa_setting_displayorder = row.DisplayOrder,
                sfa_FundingStreamId = GetFundingStreamIdForFundingStreamPeriod(row.FundingStreamPeriodCode),
                sfa_setting_Mandatory = row.IsMandatory
        };

            if (fspDeliverable.sfa_ParentDeliverableId != null)
            {
                fspDeliverable.sfa_ParentDeliverableTypeEnum =
                    (sfa_fundingstreamperioddeliverable_sfa_parentdeliverabletype) Enum.Parse(
                        typeof (sfa_fundingstreamperioddeliverable_sfa_parentdeliverabletype),
                        row.DeliverableRelationshipType);
            }

            _allFundingStreamPeriodDeliverables[row.FundingStreamPeriodCode].Add(fspDeliverable);
            return fspDeliverable;
        }

        protected override IEnumerable<sfa_fundingstreamperioddeliverable> GetMatchingEntities(
            XrmServiceContext crmContext,
            FundingStreamPeriodDeliverablesSheetType row)
        {
            if (!_allFundingStreamPeriodDeliverables.Any())
            {
                _allFundingStreamPeriodDeliverables = GetAllFundingStreamAndDeliverableEntities(crmContext);
            }
            if (!_allDeliverables.Any())
            {
                _allDeliverables = GetAllDeliverables(crmContext);
            }

            if (_allFundingStreamPeriodDeliverables.ContainsKey(row.FundingStreamPeriodCode)) // cannot look for rows where FSP no longer existent
            {
                return _allFundingStreamPeriodDeliverables[row.FundingStreamPeriodCode]
                    .Where(d => d.sfa_DeliverableCode == row.DeliverableCode);
            }

            return Enumerable.Empty<sfa_fundingstreamperioddeliverable>();
        }

        private IDictionary<string, IList<sfa_fundingstreamperioddeliverable>> GetAllFundingStreamAndDeliverableEntities
            (XrmServiceContext crmContext)
        {
            var fundingStreamPeriodDeliverables = new Dictionary<string, IList<sfa_fundingstreamperioddeliverable>>();

            IReadOnlyCollection<sfa_fundingstreamperiod> fundingStreamPeriods = GetCrmFundingStreamPeriods(crmContext);
            IReadOnlyCollection<sfa_fundingstreamperioddeliverable> fspDeliverables = GetCrmFspDeliverables(crmContext);

            PopulateAllFundingStreamPeriods(fundingStreamPeriods);

            AddAllFundingStreamPeriodsToDictionary(fundingStreamPeriods, fundingStreamPeriodDeliverables);

            foreach (var sfaFspDeliverable in fspDeliverables)
            {
                var fundingStreamPeriodIdToMatch = sfaFspDeliverable.sfa_FundingStreamPeriodId?.Id;

                //some erreous fspDeliverables in CRM with no linked FundingStreamPeriod
                if (fundingStreamPeriodIdToMatch != null)
                {
                    var deliverableFundingStreamPeriodCode = fundingStreamPeriods
                        .Single(fsp => fsp.Id == fundingStreamPeriodIdToMatch)
                        .sfa_fundingstreamperiodcode;

                    if (fundingStreamPeriodDeliverables.ContainsKey(deliverableFundingStreamPeriodCode))
                    {
                        fundingStreamPeriodDeliverables[deliverableFundingStreamPeriodCode].Add(sfaFspDeliverable);
                    }
                }
            }

            return fundingStreamPeriodDeliverables;
        }

        private void AddAllFundingStreamPeriodsToDictionary(IReadOnlyCollection<sfa_fundingstreamperiod> fundingStreamPeriods, Dictionary<string, IList<sfa_fundingstreamperioddeliverable>> fundingStreamPeriodDeliverables)
        {
            fundingStreamPeriods.ForEach(fsp => fundingStreamPeriodDeliverables.Add(fsp.sfa_fundingstreamperiodcode, new List<sfa_fundingstreamperioddeliverable>()));
        }

        private void PopulateAllFundingStreamPeriods(IReadOnlyCollection<sfa_fundingstreamperiod> fundingStreamPeriods)
        {
            fundingStreamPeriods.ForEach(fsp => _allFundingStreamPeriods.Add(fsp.sfa_fundingstreamperiodcode, fsp));
        }

        private IReadOnlyCollection<sfa_fundingstreamperioddeliverable> GetCrmFspDeliverables(XrmServiceContext crmContext)
        {
            return (from d in crmContext.sfa_fundingstreamperioddeliverableSet
                   select d).ToList();
        }

        private IReadOnlyCollection<sfa_fundingstreamperiod> GetCrmFundingStreamPeriods(XrmServiceContext crmContext)
        {
            return (from fsp in crmContext.sfa_fundingstreamperiodSet
                   select fsp).ToList();
        }

        private IDictionary<Guid, sfa_deliverable> GetAllDeliverables(XrmServiceContext crmContext)
        {
            return crmContext.sfa_deliverableSet.ToDictionary(d => d.Id, d => d);
        }

        private sfa_fundingstreamperioddeliverable GetParentDeliverable(FundingStreamPeriodDeliverablesSheetType row)
        {
            return _allFundingStreamPeriodDeliverables[row.FundingStreamPeriodCode].Single(
                    d => d.sfa_DeliverableCode == row.ParentDeliverableCode);
        }

        private sfa_deliverable GetMatchingDeliverable(int deliverableCode, string fundingStreamPeriodCode)
        {
            var fundingStream =
                _allFundingStreamPeriods[fundingStreamPeriodCode].sfa_FundingStreamCodeId;

            return _allDeliverables
                .Single(d => Equals(d.Value.sfa_FundingStreamId, fundingStream)
                             && d.Value.sfa_DeliverableCode == deliverableCode).Value;
        }

        private sfa_planningunit ParsePlanningUnit(string planningUnit)
        {
            if (planningUnit == "Value/Volume")
            {
                return sfa_planningunit.VolumeandValue;
            }

            return (sfa_planningunit)Enum.Parse(typeof(sfa_planningunit), planningUnit);
        }

        private EntityReference GetFundingStreamIdForFundingStreamPeriod(string fundingStreamPeriodCode)
        {
            if (!_fundingStreamEntityReferences.ContainsKey(fundingStreamPeriodCode))
            {
                EntityReference fundingStreamEntityReference = GetFundingStreamIdForFundingStreamPeriodFromCrm(fundingStreamPeriodCode);
                _fundingStreamEntityReferences.Add(fundingStreamPeriodCode, fundingStreamEntityReference);
            }

            return _fundingStreamEntityReferences[fundingStreamPeriodCode];
        }

        private EntityReference GetFundingStreamIdForFundingStreamPeriodFromCrm(string fundingStreamPeriodCode)
        {
            using (var crmContext = new XrmServiceContext(CrmHelper.GetConnection()))
            {
                var fundingStreamPeriodQuery = from fsp in crmContext.sfa_fundingstreamperiodSet
                                               where fsp.sfa_fundingstreamperiodcode == fundingStreamPeriodCode
                                               select fsp;

                return fundingStreamPeriodQuery.Single().sfa_FundingStreamCodeId;
            }
        }
    }
}
