using Datafix.Tests.Dtos;
using Datafix.Tests.Repositories; 
using Microsoft.Xrm.Sdk; 
using Newtonsoft.Json; 
using SFA.FCS.Worker.Common.Crm;
using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
using SFA.FCT.CrossDomain.Integration.Entities.Xrm; 
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection; 

namespace Datafix.Tests.Automation.Releases.R156
{
    public class APPSandANLPAllocationFix : IApplyDataFix
    {
        public string Release => "R156";
        public int StoryNumber => 41365;
        public string Name => "ANLP and APPS Allocation";
        public int Order => 1;
        public void ApplyDataFix()
        {
            try
            {
                string jsonResource = "Resources.R156.ANLPandAPPS.json";
                var affectedAllocations = FromJsonMessageList<AffectedAllocations>("Datafix.Tests", jsonResource);

                foreach (var affectedAllocation in affectedAllocations)
                { 
                    var deliverableData = CrmContractDeliverableRepository.GetContractDeliverablebyAllocationNo(affectedAllocation.AllocationNumber, affectedAllocation.PreviosVersion, affectedAllocation.InsertedDelCode);
                                        
                    foreach (var deliverable in deliverableData)
                    {
                        var allocationsData = CrmContractDeliverableRepository.GetContractAllocationsbyAllocationNo(affectedAllocation.AllocationNumber, Convert.ToInt32(affectedAllocation.LatestVersion));
                        deliverable.sfa_ContractAllocationId = allocationsData.CAID;
                        deliverable.sfa_ContractId = allocationsData.ContractId;
                        
                        // create DeliverablePeriods in CRM
                        var deliverableId = CreateDeliverable(deliverable);
                       
                        //Create deliverable Period in CRM
                        foreach (var Contractdeliverableperiod in deliverable.Contractdeliverableperiod)
                        {
                            CrmContractDeliverableRepository.InsertDeliverablePeriod(Contractdeliverableperiod, new EntityReference(CrmEntityName.ContractDeliverable, deliverableId));
                        }
                        
                    }

                    var delPaymentData = DeliverablePaymentRepository.GeDeliveryPaymentValues(affectedAllocation.AllocationNumber, affectedAllocation.InsertedDelCode, affectedAllocation.PreviosVersion);

                    //Insert DeliverablePayments data into PaaS
                    DeliverablePaymentRepository.AddDeliverablePaymentsForAllocation(delPaymentData, affectedAllocation.AllocationNumber, affectedAllocation.LatestVersion, affectedAllocation.InsertedDelCode);
                }
            }
            catch (Exception ex)
            {

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

        public Guid CreateDeliverable(ContractDeliverable contractDeliverable)
        {
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            var parentDeliverableEntityReference = (contractDeliverable.sfa_ParentDeliverableId.HasValue)
                ? new EntityReference(sfa_contractdeliverable.EntityLogicalName, contractDeliverable.sfa_ParentDeliverableId.Value)
                : null;

            var newDeliverable = new sfa_contractdeliverable
            {
                sfa_DeliverableCode = contractDeliverable.sfa_DeliverableCode,
                sfa_deliverablename = contractDeliverable.sfa_deliverablename,
                sfa_ParentDeliverableId = parentDeliverableEntityReference,
                sfa_ContractAllocationId = new EntityReference(sfa_contractallocation.EntityLogicalName, contractDeliverable.sfa_ContractAllocationId),
                sfa_FundingStreamPeriodDeliverableId =
                    new EntityReference(sfa_fundingstreamperioddeliverable.EntityLogicalName,
                        contractDeliverable.sfa_FundingStreamPeriodDeliverableId),
                sfa_ContractId = new EntityReference(sfa_contract.EntityLogicalName, contractDeliverable.sfa_ContractId),
                sfa_AllocationRef = contractDeliverable.sfa_AllocationRef,
                sfa_DisplayOrder = contractDeliverable.sfa_DisplayOrder,
                sfa_DeliverableDescription = contractDeliverable.sfa_DeliverableDescription,
                sfa_PlannedValue = contractDeliverable.sfa_PlannedValue,
                sfa_ActualValue = contractDeliverable.sfa_ActualValue,
                sfa_UnitCost = contractDeliverable.sfa_UnitCost,
                sfa_PlannedVolume = contractDeliverable.sfa_PlannedVolume
            };

            Guid id = organizationService.Create(newDeliverable);

            try
            {
                var updateDeliverable = new sfa_contractdeliverable
                {
                    Id = id,
                    sfa_contractdeliverableId = id
                };
                organizationService.Update(updateDeliverable);
            }
            catch (Exception)
            {

            }
            return id;
        }


    }
    public class AffectedAllocations
    {
        public Guid ContractId { get; set; }
        public string AllocationNumber { get; set; }
        public string ContractNo { get; set; }
        public string LatestVersion { get; set; }
        public string PreviosVersion { get; set; }
        public string InsertedDelCode { get; set; }
    }

}
