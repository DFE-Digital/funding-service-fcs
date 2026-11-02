namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using DTO;
    using Microsoft.Xrm.Client.Services;
    using Services;

    public static class CrmFundingStreamPeriodDeliverableRepository
    {
        public static IReadOnlyCollection<FundingStreamPeriodDeliverableSettingInfo> GetAllFundingStreamPeriodDeliverableSettings()
        {
            var organizationService = CrmConnectionFactory.GetConnection();
            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                var crmData = (
                    from fspd in context.sfa_fundingstreamperioddeliverableSet
                    join fsp in context.sfa_fundingstreamperiodSet on fspd.sfa_FundingStreamPeriodId.Id equals fsp.Id
                    select new
                    {
                        FundingStreamPeriodCode = fsp.sfa_fundingstreamperiodcode,
                        FundingStreamPeriodDeliverable = fspd
                    }).ToList();

                return crmData.SelectMany(fspd => new List<FundingStreamPeriodDeliverableSettingInfo>
                {
                    new FundingStreamPeriodDeliverableSettingInfo
                    (
                        fundingStreamPeriodCode: fspd.FundingStreamPeriodCode,
                        deliverableCode: fspd.FundingStreamPeriodDeliverable.sfa_DeliverableCode.Value,
                        settingName: "allowactuals",
                        settingValue: fspd.FundingStreamPeriodDeliverable.sfa_setting_AllowActuals.Value ? "Yes" : "No"
                    ),
                    new FundingStreamPeriodDeliverableSettingInfo
                    (
                        fundingStreamPeriodCode: fspd.FundingStreamPeriodCode,
                        deliverableCode: fspd.FundingStreamPeriodDeliverable.sfa_DeliverableCode.Value,
                        settingName: "allowcustomdeliverabledescription",
                        settingValue: fspd.FundingStreamPeriodDeliverable.sfa_setting_AllowCustomDeliverableDescription.Value ? "Yes" : "No"
                    ),
                    new FundingStreamPeriodDeliverableSettingInfo
                    (
                        fundingStreamPeriodCode: fspd.FundingStreamPeriodCode,
                        deliverableCode: fspd.FundingStreamPeriodDeliverable.sfa_DeliverableCode.Value,
                        settingName: "allowpayment",
                        settingValue: fspd.FundingStreamPeriodDeliverable.sfa_setting_AllowPayment.Value ? "Yes" : "No"
                    ),
                    new FundingStreamPeriodDeliverableSettingInfo
                    (
                        fundingStreamPeriodCode: fspd.FundingStreamPeriodCode,
                        deliverableCode: fspd.FundingStreamPeriodDeliverable.sfa_DeliverableCode.Value,
                        settingName: "allowprofile",
                        settingValue: fspd.FundingStreamPeriodDeliverable.sfa_setting_AllowProfile.Value ? "Yes" : "No"
                    ),
                    new FundingStreamPeriodDeliverableSettingInfo
                    (
                        fundingStreamPeriodCode: fspd.FundingStreamPeriodCode,
                        deliverableCode: fspd.FundingStreamPeriodDeliverable.sfa_DeliverableCode.Value,
                        settingName: "displayname",
                        settingValue: fspd.FundingStreamPeriodDeliverable.sfa_name.ToString()
                    ),
                    new FundingStreamPeriodDeliverableSettingInfo
                    (
                        fundingStreamPeriodCode: fspd.FundingStreamPeriodCode,
                        deliverableCode: fspd.FundingStreamPeriodDeliverable.sfa_DeliverableCode.Value,
                        settingName: "displayorder",
                        settingValue: fspd.FundingStreamPeriodDeliverable.sfa_setting_displayorder.ToString()
                    ),
                    new FundingStreamPeriodDeliverableSettingInfo
                    (
                        fundingStreamPeriodCode: fspd.FundingStreamPeriodCode,
                        deliverableCode: fspd.FundingStreamPeriodDeliverable.sfa_DeliverableCode.Value,
                        settingName: "mandatory",
                        settingValue: fspd.FundingStreamPeriodDeliverable.sfa_setting_Mandatory.Value ? "Mandatory" : "Optional"
                    ),
                    new FundingStreamPeriodDeliverableSettingInfo
                    (
                        fundingStreamPeriodCode: fspd.FundingStreamPeriodCode,
                        deliverableCode: fspd.FundingStreamPeriodDeliverable.sfa_DeliverableCode.Value,
                        settingName: "planningunit",
                        settingValue: fspd.FundingStreamPeriodDeliverable.sfa_setting_PlanningUnitEnum.ToString()
                    )
                }).ToList();
            }
        }
    }
}
