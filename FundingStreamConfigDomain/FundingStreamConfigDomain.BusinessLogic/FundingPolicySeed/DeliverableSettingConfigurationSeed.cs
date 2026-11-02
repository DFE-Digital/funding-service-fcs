namespace SFA.FCT.FundingStreamConfigDomain.BusinessLogic.FundingPolicySeed
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Common.PagedStorage;
    using CrossDomain.Integration.Entities;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Client;

    public class DeliverableSettingConfigurationSeed : IPagedStorageSeed<DeliverableSettingConfiguration>
    {
        private readonly IOrganizationService _organizationService;

        public DeliverableSettingConfigurationSeed(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        public int LoggingId
        {
            get { return FundingStreamConfigDomainEvents.FscDomainSeedDeliverableSettingConfiguration; }
        }

        public IEnumerable<DeliverableSettingConfiguration> GetDataEnumerable()
        {
            var deliverableDictionary = GetAllDeliverableDataDictionary();

            return GetDeliverableSettingConfigurationList(deliverableDictionary);
        }

        public string GetEntityString(DeliverableSettingConfiguration setting)
        {
            return string.Format(
                "Deliverable Code: {0}, FSP Code: {1}, Setting: {2}, Value: {3}",
                setting.DeliverableCode,
                setting.FundingStreamPeriodCode,
                setting.SettingValue.Setting.SettingName,
                setting.SettingValue.Value);
        }

        private IDictionary<Guid, DeliverableData> GetAllDeliverableDataDictionary()
        {
            using (var xrm = new OrganizationServiceContext(_organizationService))
            {
                var fundingStreamPeriodDeliverables = (
                        from d in
                            xrm.CreateQuery("sfa_fundingstreamperioddeliverable")
                        join fs in xrm.CreateQuery("sfa_fundingstreamperiod")
                            on d["sfa_fundingstreamperiodid"] equals fs["sfa_fundingstreamperiodid"]
                        select
                            new KeyValuePair<Guid, DeliverableData>(
                                d.Id,
                                new DeliverableData
                                {
                                    DeliverableCode = d.GetAttributeValue<int>("sfa_deliverablecode"),
                                    DeliverableName = d.GetAttributeValue<string>("sfa_name"),
                                    FundingStreamPeriodCode = fs.GetAttributeValue<string>("sfa_fundingstreamperiodcode"),
                                    ParentReference = (EntityReference)d.GetAttributeValue("sfa_parentdeliverableid"),
                                    ParentRelationshipOptionSetValue = d.GetAttributeValue<OptionSetValue>("sfa_parentdeliverabletype"),
                                    Settings =
                                        d.FormattedValues
                                            .Where(v => v.Key.StartsWith("sfa_setting_"))
                                            .ToDictionary(k => k.Key.Remove(0, 12), v => v.Value)
                                }))
                    .ToDictionary(e => e.Key, e => e.Value);

                return fundingStreamPeriodDeliverables;
            }
        }

        private List<DeliverableSettingConfiguration> GetDeliverableSettingConfigurationList(IDictionary<Guid, DeliverableData> deliverableDictionary)
        {
            var response = new List<DeliverableSettingConfiguration>();

            foreach (var deliverable in deliverableDictionary.Values)
            {
                // output expects deliverable name as a setting
                var dsc2 = new DeliverableSettingConfiguration()
                {
                    DeliverableCode = deliverable.DeliverableCode,
                    FundingStreamPeriodCode = deliverable.FundingStreamPeriodCode,
                    SettingValue = new SettingValueType()
                    {
                        Setting = new SettingType()
                        {
                            SettingName = "displayname"
                        },
                        Value = deliverable.DeliverableName
                    }
                };
                response.Add(dsc2);

                foreach (var setting in deliverable.Settings)
                {
                    var dsc = new DeliverableSettingConfiguration()
                    {
                        DeliverableCode = deliverable.DeliverableCode,
                        FundingStreamPeriodCode = deliverable.FundingStreamPeriodCode,
                        SettingValue = new SettingValueType()
                        {
                            Setting = new SettingType()
                            {
                                SettingName = setting.Key
                            },
                            Value = setting.Value
                        }
                    };

                    response.Add(dsc);
                }
            }

            return response;
        }
    }
}