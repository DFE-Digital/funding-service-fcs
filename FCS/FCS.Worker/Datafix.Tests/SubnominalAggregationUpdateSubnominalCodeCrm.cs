namespace Datafix.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCS.Worker.Common.Crm;

    public class SubnominalAggregationUpdateSubnominalCodeCrm //: IApplyDataFix
    {
        public string Release => "R71";
        public int StoryNumber => 26707;
        public string Name => "SubnominalAggregation Update SubnominalCode CRM";
        public int Order => 1;
        public void ApplyDataFix()
        {
            SubnominalAggregation_UpdateSubnominalCode_Crm();
        }

        public void SubnominalAggregation_UpdateSubnominalCode_Crm()
        {
            var subnominalCodeMapDictionary = ConstructSubnominalCodeMapDictionary();

            var subnominalAggregationInfosToBeChanged = GetSubnominalAggregationInfosToBeUpdatedFromCrm();

            Console.WriteLine($@"Found { subnominalAggregationInfosToBeChanged.Count } SubnominalAggregations to be changed");

            subnominalAggregationInfosToBeChanged.ForEach(subnominalAggregationInfo =>
            {
                var newSubnominalCode = subnominalCodeMapDictionary[subnominalAggregationInfo.SubnominalCode];

                var newSubnominalAggregateKey = ConstructNewSubnominalAggregateKey(subnominalAggregationInfo.SubnominalAggregateKey, newSubnominalCode);

                Console.WriteLine($@"Updating: { subnominalAggregationInfo.SubnominalAggregateKey }, Funding Stream Period Code {subnominalAggregationInfo.FundingStreamPeriodCode}. New SubnominalCode is {newSubnominalCode}");

                UpdateCrmSubnominalAggregation(subnominalAggregationInfo.CrmId, newSubnominalCode, newSubnominalAggregateKey);
            });
        }

        private static Dictionary<string, string> ConstructSubnominalCodeMapDictionary()
        {
            var mapDictionary = new Dictionary<string, string>();

            mapDictionary.Add("2240150", "2240151");
            mapDictionary.Add("2240160", "2240161");
            mapDictionary.Add("2340150", "2340151");
            mapDictionary.Add("2340160", "2340161");

            return mapDictionary;
        }

        private IReadOnlyCollection<SubnominalAggregationInfo> GetSubnominalAggregationInfosToBeUpdatedFromCrm()
        {
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var xrmContext = new XrmServiceContext(organizationService))
            {
                return (from fsp in xrmContext.sfa_fundingstreamperiodSet
                        join sa in xrmContext.sfa_subnominalaggregationSet on fsp.Id equals sa.sfa_fundingstreamperiod.Id
                        where
                             sa.sfa_Period == "Aug-19" &&

                            (fsp.sfa_fundingstreamperiodcode == "ANLAP2018" ||
                             fsp.sfa_fundingstreamperiodcode == "16-18NLAP2018") &&

                            (sa.sfa_name == "2240150" ||
                             sa.sfa_name == "2240160" ||
                             sa.sfa_name == "2340150" ||
                             sa.sfa_name == "2340160")

                        select new SubnominalAggregationInfo(sa.sfa_subnominalaggregationId.Value, sa.sfa_name, 
                            sa.sfa_SubnominalAggregateKey, fsp.sfa_fundingstreamperiodcode)).ToList();
            }
        }

        private static string ConstructNewSubnominalAggregateKey(string oldSubnominalAggregateKey, string newSubnominalCode)
        {
            // sample oldSubnominalAggregateKey - "2240150_YNLP-732_Aug-19"
            var aggKeyParts = oldSubnominalAggregateKey.Split('_');
            return $"{newSubnominalCode}_{aggKeyParts[1]}_{aggKeyParts[2]}";
        }

        private void UpdateCrmSubnominalAggregation(
            Guid crmId,
            string newSubnominalCode,
            string newSubnominalAggregateKey)
        {
            var subnominalaggregation = new sfa_subnominalaggregation
            {
                Id = crmId,
                sfa_name = newSubnominalCode,
                sfa_SubnominalCode = newSubnominalCode,
                sfa_SubnominalAggregateKey = newSubnominalAggregateKey,
                EntityState = EntityState.Changed
            };

            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            organizationService.Update(subnominalaggregation);
        }

        public class SubnominalAggregationInfo
        {
            public SubnominalAggregationInfo(Guid crmId, string subnominalCode, string subnominalAggregateKey, string fundingStreamPeriodCode)
            {
                CrmId = crmId;
                SubnominalCode = subnominalCode;
                SubnominalAggregateKey = subnominalAggregateKey;
                FundingStreamPeriodCode = fundingStreamPeriodCode;
            }

            public Guid CrmId { get; }

            public string SubnominalCode { get; }

            public string SubnominalAggregateKey { get; }

            public string FundingStreamPeriodCode { get; }
        }
    }
}