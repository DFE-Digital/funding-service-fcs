using Datafix.Tests.Repositories;
using SFA.FCS.Worker.Common.Crm;
using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Datafix.Tests.Automation.Releases.R171
{
    internal class FCRPaymentUpdate : IApplyDataFix
    {
        public string Release => "R171";

        public int StoryNumber => 46240;

        public string Name => "Update payment for selected FCRs to zero";

        public int Order => 1;

        public void ApplyDataFix()
        {
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
           
            // Update Paas DB
                       
            foreach (var allocationNumber in allocationNumbers)
            {
                // Update Subnominal Aggregation table
                ContractDeliverableRepository.UpdateContractSubnomialsDelvierables(allocationNumber);
                //Update DeliveryPayment Table
                ContractDeliverableRepository.UpdateContractDelvierablesPayment(allocationNumber);
            }


            // Update CRM DB
            foreach (var allocationNumber in allocationNumbers)
            {
                var cdpData = CrmContractDeliverableRepository.GetContractDeliverablePeridIDsByAllocationNumber(allocationNumber);
                foreach (var cdp in cdpData)
                {
                    sfa_contractdeliverableperiod deliverablePeriodToUpdate = new sfa_contractdeliverableperiod
                    {
                        Id = cdp.CDPId,
                        sfa_ReconciliationPaymentAmount = 0,
                        sfa_NetPaymentAmount = 0,
                        sfa_PaymentPosted = false
                    };
                      organizationService.Update(deliverablePeriodToUpdate);
                    if (cdp.ReconciliationSubnominal != null)
                    {
                        sfa_subnominalaggregation subnominalaggregationToUpdate = new sfa_subnominalaggregation
                        {
                            Id = new Guid(cdp.ReconciliationSubnominal),
                            sfa_AggregatedValue = 0
                        };
                        organizationService.Update(subnominalaggregationToUpdate);
                    }                  
                }
            }
        }


        private readonly List<string> allocationNumbers = new List<string>()
        {
            "AECA-2747",
            "AECA-2830",
            "AECA-2885",
            "AECA-2958",
            "AECA-2991",
        };
    }
}
