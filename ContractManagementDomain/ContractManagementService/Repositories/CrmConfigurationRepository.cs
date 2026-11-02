namespace ContractManagementService.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Globalization;
    using System.Linq;
    using System.Net.Http;
    using System.Threading.Tasks;
    using System.Web;
    using Extensions;
    using Services;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;

    public class CrmConfigurationRepository : ICrmConfigurationRepository
    {
        private readonly HttpClient _httpClient;
        private readonly string _restApiUrl;
        private readonly IFcsConfiguration _appConfiguration;

        public CrmConfigurationRepository(IFcsConfiguration appConfiguration)
        {
            _appConfiguration = appConfiguration;
            _restApiUrl = appConfiguration["CRM:ResourceId"] + "/api/data/v9.1/";
            _httpClient = new HttpClient();
        }

        public async Task<FundingConfigurationType> GetFundingConfiguration(string period, string periodType, string fundingType)
        {
            FundingConfigurationDataType[] fundingConfigurationDataTypes = new FundingConfigurationDataType[0];

            var accessToken = CrmAccessTokenFactory.GetAccessToken(_appConfiguration);
            string fetchXml = @$"<fetch mapping='logical'>  
                                    <entity name='sfa_fundingstream'>   
                                      <attribute name='sfa_fundingstreamcode'/>
                                      <attribute name='sfa_fundingstreamid'/>
                                      <attribute name='sfa_fundingstreamname'/>        
                                      <link-entity name='sfa_fundingtype_fundingstream' from='sfa_fundingstreamid' to='sfa_fundingstreamid' link-type='inner' alias='ftfs'>
                                        <link-entity name='sfa_fundingtype' from='sfa_fundingtypeid' to='sfa_fundingtypeid' link-type='inner' alias='ft'>
                                                 <attribute name='sfa_fundingtypecode'/>
                                                <filter type='and'>   
                                                    <condition attribute='sfa_fundingtypecode' operator='eq' value='{fundingType}' />   
                                                </filter>
                                        </link-entity>
                                      </link-entity>
                                      <link-entity name='sfa_fundingstreamperiod' from='sfa_fundingstreamcodeid' to='sfa_fundingstreamid' link-type='inner' alias='fsp'>
                                                <attribute name='sfa_fundingstreamperiodcode' />
                                         <link-entity name='sfa_period' from='sfa_periodid' to='sfa_periodid' link-type='inner' alias='p'>
                                                <attribute name='sfa_period' />
                                                <attribute name='sfa_startdate' />
                                                <attribute name='sfa_enddate' />
                                                 <filter type='and'>
                                                    <condition attribute='sfa_period' operator='eq' value='{period}' />
                                                </filter>
                                            <link-entity name='sfa_periodtype' from='sfa_periodtypeid' to='sfa_periodtypeid' link-type='inner' alias='pt'>
                                                <attribute name='sfa_periodtypecode' />
                                                <attribute name='sfa_periodtypename' />
                                                <filter type='and'>
                                                    <condition attribute='sfa_periodtypecode' operator='eq' value='{periodType}' />
                                                </filter>
                                            </link-entity>
                                         </link-entity>
                                      </link-entity>
                                      </entity>   
                                </fetch>";

            var encoded = HttpUtility.UrlEncode(fetchXml);

            var url = $"{_restApiUrl}sfa_fundingstreams?fetchXml={encoded}";
            var content =  await CrmHttpApiCaller.HttpGetAsync(url, _httpClient, accessToken);

            if (content["value"].HasValues)
            {
                var fcDataTypeRows = content["value"].ToList();
                fundingConfigurationDataTypes = fcDataTypeRows.Select(row => new FundingConfigurationDataType
                {
                    FundingTypeCode = fundingType,
                    FundingStreamCode = (string) row["sfa_fundingstreamcode"],
                    FundingStreamId = (string) row["sfa_fundingstreamid"],
                    FundingStreamName = (string) row["sfa_fundingstreamname"],
                    FundingStreamCodeId = (string) row["sfa_fundingstreamid"],
                    FundingStreamPeriodCode = (string) row["fsp.sfa_fundingstreamperiodcode"],
                    Period = period,
                    FundingPeriodStartDate = ToDateTime((string)row["p.sfa_startdate"]),
                    FundingPeriodEndDate = ToDateTime((string)row["p.sfa_enddate"]),
                    PeriodTypeCode = periodType,
                    PeriodTypeName = (string) row["pt.sfa_periodtypename"],
                }).ToArray();
            }

            return new FundingConfigurationType
            {
                FundingConfigurationList = fundingConfigurationDataTypes
            };
        }

        public async Task<FSCDeliverableStructureDefinitionResponse> GetDeliverableConfiguration(string fundingStreamPeriodCode)
        {
            var deliverableInfos = await QueryFundingStreamPeriodDeliverables(fundingStreamPeriodCode);

            return new FSCDeliverableStructureDefinitionResponse
            {
                DeliverableStructureList = deliverableInfos.Select(d => new DeliverableConfigurationType
                {
                    DeliverableCode = d.DeliverableCode,
                    DeliverableName = d.DeliverableName,
                    ParentDetails = new DeliverableConfigurationTypeParentDetails
                    {
                        ParentDeliverableCode = d.ParentDeliverableCode,
                        ParentRelationship = d.ParentDeliverableCode.HasValue
                            ? (DeliverableParentRelationshipType?) DeliverableParentRelationshipType.Aggregate
                            : null
                    },
                    Settings = new List<DeliverableSettingsType>
                    {
                        new DeliverableSettingsType
                        {
                            SettingCode = "planningunit",
                            SettingValue = d.SettingPlanningUnit
                        },
                        new DeliverableSettingsType
                        {
                            SettingCode = "allowactuals",
                            SettingValue = d.SettingAllowActuals
                        },
                        new DeliverableSettingsType
                        {
                            SettingCode = "allowpayment",
                            SettingValue = d.SettingAllowPayment
                        },
                        new DeliverableSettingsType
                        {
                            SettingCode = "mandatory",
                            SettingValue = d.SettingMandatory
                        },
                        new DeliverableSettingsType
                        {
                            SettingCode = "displayorder",
                            SettingValue = d.SettingDisplayOrder.ToString()
                        },
                        new DeliverableSettingsType
                        {
                            SettingCode = "allowcustomdeliverabledescription",
                            SettingValue = d.SettingAllowCustomDeliverableDescription
                        },
                        new DeliverableSettingsType
                        {
                            SettingCode = "allowprofile",
                            SettingValue = d.SettingAllowProfile
                        },
                    }
                }).ToList()
            };
        }

        private static DateTime ToDateTime(string date)
        {
            return DateTime.Parse(date, CultureInfo.CreateSpecificCulture("en-US"));
        }

        private async Task<List<DeliverableInfo>> QueryFundingStreamPeriodDeliverables(string fundingStreamPeriodCode)
        {
            var accessToken = CrmAccessTokenFactory.GetAccessToken(_appConfiguration);
            string fetchXml = @$"<fetch mapping='logical'>  
                                    <entity name='sfa_fundingstreamperioddeliverable'>         
                                       <attribute name='sfa_deliverablecode'/>
                                       <attribute name='sfa_name'/>
                                       <attribute name='sfa_fundingstreamperioddeliverableid'/>
                                       <attribute name='sfa_setting_planningunit'/>
                                       <attribute name='sfa_setting_allowcustomdeliverabledescription'/>
                                       <attribute name='sfa_setting_allowpayment'/>
                                       <attribute name='sfa_setting_allowactuals'/>
                                       <attribute name='sfa_setting_mandatory'/>
                                       <attribute name='sfa_setting_allowprofile'/>
                                       <attribute name='sfa_setting_displayorder'/>
                                       <link-entity name='sfa_fundingstreamperiod' from='sfa_fundingstreamperiodid' to='sfa_fundingstreamperiodid' link-type='inner' alias='fsp'>
                                        <filter type='and'>   
                                          <condition attribute='sfa_fundingstreamperiodcode' operator='eq' value='{fundingStreamPeriodCode}' />   
                                        </filter>
                                       </link-entity>
                                       <link-entity name='sfa_fundingstreamperioddeliverable' from='sfa_fundingstreamperioddeliverableid' to='sfa_parentdeliverableid' link-type='outer' alias='pd'>
                                          <attribute name='sfa_deliverablecode'/>
                                          <attribute name='sfa_fundingstreamperioddeliverableid'/>
                                       </link-entity>
                                     </entity>   
                                </fetch>";

            var encoded = HttpUtility.UrlEncode(fetchXml);

            var url = $"{_restApiUrl}sfa_fundingstreamperioddeliverables?fetchXml={encoded}";
            var content = await CrmHttpApiCaller.HttpGetAsync(url, _httpClient, accessToken);

            if (content["value"].HasValues)
            {
                var deliverableRows = content["value"].ToList();
                return deliverableRows.Select(row => new DeliverableInfo
                {
                   DeliverableCode = int.Parse((string)row["sfa_deliverablecode"]),
                   DeliverableName = (string)row["sfa_name"],
                   ParentDeliverableCode = ((string)row["pd.sfa_deliverablecode"]).ToInt(),
                   SettingPlanningUnit = GetPlanningUnit(row["sfa_setting_planningunit"].ToString()),
                   SettingAllowCustomDeliverableDescription = GetYesOrNoValue(row["sfa_setting_allowcustomdeliverabledescription"].ToString()),
                   SettingAllowPayment = GetYesOrNoValue(row["sfa_setting_allowpayment"].ToString()),
                   SettingAllowActuals = GetYesOrNoValue(row["sfa_setting_allowactuals"].ToString()),
                   SettingMandatory = row["sfa_setting_mandatory"].ToString() == "True" ? "Mandatory" : "Optional",
                   SettingAllowProfile = GetYesOrNoValue(row["sfa_setting_allowprofile"].ToString()),
                   SettingDisplayOrder = int.Parse((string)row["sfa_setting_displayorder"])

                }).ToList();
            }

            return new List<DeliverableInfo>();
        }

        private string GetYesOrNoValue(string text)
        {
            return text == "True" ? "Yes" : "No";
        }

        private string GetPlanningUnit(string planningUnitVal)
        {
            if (planningUnitVal == "229660000")
            {
                return "Value";
            }

            if (planningUnitVal == "229660001")
            {
                return "Volume";
            }

            return "Volume and Value";
        }

        private class DeliverableInfo
        {
            public int DeliverableCode { get; set; }
            public string DeliverableName { get; set; }
            public int? ParentDeliverableCode { get; set; }
            public string SettingPlanningUnit { get; set; }
            public string SettingAllowCustomDeliverableDescription { get; set; }
            public string SettingAllowPayment { get; set; }
            public string SettingAllowActuals { get; set; }
            public string SettingMandatory { get; set; }
            public string SettingAllowProfile { get; set; }
            public int SettingDisplayOrder { get; set; }
        }

        internal class DeliverableData
        {
            public int DeliverableCode { get; set; }

            public string DeliverableName { get; set; }

            public string FundingStreamPeriodCode { get; set; }

            public bool HasParent { get; set; }

            public int ParentId { get; set; }

            public DeliverableParentRelationshipType ParentRelationshipType { get; set; }

            public Guid ParentReference { get; set; }

            //public OptionSetValue ParentRelationshipOptionSetValue { get; set; }

            public IDictionary<string, string> Settings { get; set; }
        }
    }
}
