using Datafix.Tests.Repositories;
using PaymentGenerationDomain.Integration.DataStore.Model;
using SFA.FCS.Worker.Common.Crm;
using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Datafix.Tests.Automation.Releases.R156;
using Newtonsoft.Json;
using System.IO;
using System.Reflection;
using SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;
using Microsoft.Xrm.Sdk;
using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

namespace Datafix.Tests.Automation.Releases.R172
{
    public class InsertTTF1151SubnominalAggregationData :IApplyDataFix
    {
        public string Release => "R172";

        public int StoryNumber => 46336;

        public string Name => "Add payment for TTF-1151 allocation";

        public int Order => 1;

        public void ApplyDataFix()
        {
            string jsonResource = "Resources.R172.TTFSubnominal.json";
            var subnominalAggregationPaymentData = FromJsonMessageList<SubnominalAggregation>("Datafix.Tests", jsonResource);

            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            // Update Paas DB


            foreach (var subnominalAggregation in subnominalAggregationPaymentData)
            {
                ContractDeliverableRepository.InsertContractSubnomialsAggregationDelvierables(subnominalAggregation);
            }

            // Update data in CRM
            string crmjsonResource = "Resources.R172.TTFCRM.json";
            var crmsubnominalAggregationPaymentData = FromJsonMessageList<CRMSubnominalAggregation>("Datafix.Tests", crmjsonResource);

            foreach (var crmsubnominalAggregation in crmsubnominalAggregationPaymentData)
            {
                sfa_subnominalaggregation subnominalaggregationCreate = new sfa_subnominalaggregation
                {
                    sfa_AggregatedValue = Convert.ToDecimal(crmsubnominalAggregation.sfa_aggregatedvalue),
                    sfa_name = crmsubnominalAggregation.sfa_name,
                    sfa_Period = crmsubnominalAggregation.sfa_period,
                    sfa_PaymentType = new OptionSetValue(Convert.ToInt32(crmsubnominalAggregation.sfa_paymenttype)),
                    sfa_PeriodTypeCode = crmsubnominalAggregation.sfa_periodtypecode,
                    sfa_provider = new EntityReference(sfa_subnominalaggregation.EntityLogicalName,
                                          new Guid(crmsubnominalAggregation.sfa_provider)),
                    sfa_fundingstreamperiod = new EntityReference(sfa_subnominalaggregation.EntityLogicalName,
                                          new Guid(crmsubnominalAggregation.sfa_fundingstreamperiod)),
                    sfa_SubnominalAggregateKey = crmsubnominalAggregation.sfa_subnominalaggregatekey,
                    sfa_Posted = Convert.ToBoolean(crmsubnominalAggregation.sfa_posted),
                    sfa_SubnominalCode = crmsubnominalAggregation.sfa_subnominalcode,
                    statuscode = new OptionSetValue(Convert.ToInt32(crmsubnominalAggregation.statuscode))
                };

                Guid aggrigationId =  organizationService.Create(subnominalaggregationCreate);
                var cdpData = CrmContractDeliverableRepository.GetContractDeliverablePeridIDsByContractNumberAndPeriod("TTFU-1151", crmsubnominalAggregation.sfa_period);
                cdpData = cdpData.Where(x => x.Period == crmsubnominalAggregation.sfa_period).ToList();
                 
                foreach (var cdp in cdpData)
                {
                    if (crmsubnominalAggregation.sfa_paymenttype == "229660000")
                    {
                        if (Convert.ToDecimal(crmsubnominalAggregation.sfa_aggregatedvalue) > 0)
                        {
                            sfa_contractdeliverableperiod deliverablePeriodToUpdate = new sfa_contractdeliverableperiod
                            {
                                Id = cdp.CDPId,
                                sfa_profilesubnominal = new EntityReference(sfa_subnominalaggregation.EntityLogicalName, aggrigationId)
                            };
                            organizationService.Update(deliverablePeriodToUpdate);
                        }
                        else
                        {
                            sfa_contractdeliverableperiod deliverablePeriodToUpdate = new sfa_contractdeliverableperiod
                            {
                                Id = cdp.CDPId,
                                sfa_profilesubnominal = new EntityReference(sfa_subnominalaggregation.EntityLogicalName, aggrigationId)
                            };
                            organizationService.Update(deliverablePeriodToUpdate);
                        }
                    }
                    else if(crmsubnominalAggregation.sfa_paymenttype == "229660001")
                    {
                        sfa_contractdeliverableperiod deliverablePeriodToUpdate = new sfa_contractdeliverableperiod
                        {
                            Id = cdp.CDPId,
                            sfa_reconciliationsubnominal = new EntityReference(sfa_subnominalaggregation.EntityLogicalName, aggrigationId)
                        };
                        organizationService.Update(deliverablePeriodToUpdate);
                    }
                }
            }
        }

        private static List<T> FromJsonMessageList<T>(string nameSpace, string resourceName)
        {
            using (Stream stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            using (StreamReader streamReader = new StreamReader(stream))
            {
                return JsonConvert.DeserializeObject<List<T>>(streamReader.ReadToEnd());
            }
        }
    }

    public class CRMSubnominalAggregation
    {
        public string AllocationNumber { get; set; }
        public string sfa_period { get; set; }
        public string sfa_name { get; set; }
        public string sfa_paymenttype { get; set; }
        public string sfa_periodtypecode { get; set; }
        public string sfa_provider { get; set; }
        public string sfa_fundingstreamperiod { get; set; }
        public string sfa_subnominalaggregatekey { get; set; }
        public int sfa_posted { get; set; }
        public string sfa_aggregatedvalue { get; set; }
        public string sfa_subnominalcode { get; set; }
        public string AllocationVersionNumber { get; set; }
        public string statecode { get; set; }
        public string statuscode { get; set; }
    }

    public class SubnominalAggregation
    {
        public string AllocationNumber { get; set; }
        public string FundingStreamPeriodCode { get; set; }
        public virtual FundingStreamPeriod FundingStreamPeriod { get; set; }
        public string Period { get; set; }
        public string SubnominalCode { get; set; }
        public virtual Subnominal Subnominal { get; set; }
        public string PaymentType { get; set; }
        public string PeriodTypeCode { get; set; }
        public string OrganisationId { get; set; }
        public int Ukprn { get; set; }
        public bool PostedFlag { get; set; }
        public string AggregatedValue { get; set; }
        public bool IsSelectedForPayment { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public string AllocationVersionNumber { get; set; }
    }
   
}
