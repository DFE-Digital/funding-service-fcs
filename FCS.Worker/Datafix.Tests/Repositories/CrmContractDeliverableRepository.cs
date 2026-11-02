namespace Datafix.Tests.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Datafix.Tests.Automation.Releases.R140;
    using Datafix.Tests.Automation.Releases.R148;
    using Microsoft.Xrm.Sdk;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using Datafix.Tests.Automation.Releases.R153;
    using Datafix.Tests.Dtos;
    using Microsoft.Xrm.Client.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using SFA.FCT.ContractCreateDomain.Implementation.Extensions;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    public static class CrmContractDeliverableRepository
    {
        public static IReadOnlyCollection<Guid> GetContractDeliverableIdsForLatestContractCreatedAfterDate(
            string contractNumber,
            DateTime fromDate)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                var res = (
                        from contract in context.sfa_contractSet
                        join alloc in context.sfa_contractallocationSet on contract.sfa_contractId.Value equals alloc.sfa_ContractId.Id
                        join d in context.sfa_contractdeliverableSet on alloc.sfa_contractallocationId equals d.sfa_ContractAllocationId.Id

                        where contract.sfa_LatestVersion == true
                              && contract.sfa_number == contractNumber

                        select new { Id = d.sfa_contractdeliverableId.Value, CreatedOn = d.CreatedOn.Value }
                    )
                    .ToList();

                return res.Where(row => row.CreatedOn > fromDate).Select(i => i.Id).ToList();
            }
        }

        public static List<ContractDeliverableIds> GetContractDeliverableIdsForLatestContractCreated(
           string contractNumber, string allocationNumber, string deliverableCode, string periodName)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                var res = (
                        from dp in context.sfa_contractdeliverableperiodSet
                        join d in context.sfa_contractdeliverableSet on dp.sfa_ContractDeliverableId.Id equals d.Id
                        join a in context.sfa_contractallocationSet on d.sfa_ContractAllocationId.Id equals a.Id
                        join contract in context.sfa_contractSet on a.sfa_ContractId.Id equals contract.Id

                        where
                        contract.sfa_LatestVersion == true
                              && contract.sfa_number == contractNumber
                              && dp.sfa_PeriodName == periodName
                              && a.sfa_contractallocationnumber == allocationNumber
                              && d.sfa_DeliverableCode == deliverableCode
                        select new ContractDeliverableIds { CdId = d.sfa_contractdeliverableId.Value, CdpId = dp.Id }
                    )
                    .ToList();

                return res.ToList();
            }
        }

        public static List<DeliveryUKPRNOrg> GetContractDeliverableIdsForUKPRN(
           string ukprn)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                var res = (
                     from c in context.sfa_contractSet
                     join p in context.sfa_periodSet on c.sfa_PeriodId.Id equals p.sfa_periodId
                     join ca in context.sfa_contractallocationSet on c.sfa_contractId.Value equals ca.sfa_ContractId.Id
                     join cd in context.sfa_contractdeliverableSet on ca.sfa_contractallocationId.Value equals cd.sfa_ContractAllocationId.Id

                     where
                     c.sfa_LatestVersion == true
                           && c.sfa_UKPRN == ukprn
                              && p.sfa_Period == "2324"
                     //     && ca.sfa_deliveryorganisationukprn != c.sfa_UKPRN
                     select new DeliveryUKPRNOrg
                     {
                         CdId = cd.sfa_contractdeliverableId.Value,
                         Deliveryorganisationukprn = ca.sfa_deliveryorganisationukprn,
                         Contractallocationnumber = ca.sfa_contractallocationnumber,
                         Deliverablecode = cd.sfa_DeliverableCode,
                         ContractNumber = c.sfa_number,
                         DeliverableName = cd.sfa_deliverablename
                     }
                 )
                 .ToList();

                return res.Where(x => x.Deliveryorganisationukprn != null && x.Deliveryorganisationukprn != ukprn).ToList();
            }
        }

        public static List<ContractAllocation> GetContractAllocationsForUKPRN(
          string ukprn)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                var res = (
                     from c in context.sfa_contractSet
                     join p in context.sfa_periodSet on c.sfa_PeriodId.Id equals p.sfa_periodId.Value
                     join ca in context.sfa_contractallocationSet on c.sfa_contractId.Value equals ca.sfa_ContractId.Id
                     where
                     c.sfa_LatestVersion == true
                           && c.sfa_UKPRN == ukprn
                              && p.sfa_Period == "2324"

                     select new ContractAllocation
                     {
                         AllocationNumber = ca.sfa_contractallocationnumber,
                         Ukprn = ca.sfa_deliveryorganisationukprn,
                         Period = p.sfa_Period,
                         ContractVersion = c.sfa_Version
                     }
                 )
                 .ToList();

                return res.Where(x => x.Ukprn != null && x.Ukprn != ukprn).ToList();
            }
        }

        public static List<ContractDeliverablePeriod> GetContractDeliverablePeridByAllocationNumber(string allocationNumber)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {

                var res = (
                     from c in context.sfa_contractSet
                     join p in context.sfa_periodSet on c.sfa_PeriodId.Id equals p.sfa_periodId.Value
                     join ca in context.sfa_contractallocationSet on c.sfa_contractId.Value equals ca.sfa_ContractId.Id
                     join cd in context.sfa_contractdeliverableSet on ca.sfa_contractallocationId.Value equals cd.sfa_ContractAllocationId.Id
                     join cdp in context.sfa_contractdeliverableperiodSet on cd.sfa_contractdeliverableId.Value equals cdp.sfa_ContractDeliverableId.Id

                     where
                     c.sfa_LatestVersion == true
                           && ca.sfa_contractallocationnumber == allocationNumber
                              && p.sfa_Period == "2324"

                     select new ContractDeliverablePeriod
                     {
                         AllocationNumber = ca.sfa_contractallocationnumber,
                         BalancingpaymentAmount = cdp.sfa_BalancingPaymentAmount,
                         NetPaymentAmount = cdp.sfa_NetPaymentAmount,
                         ProfilePaymentAmount = cdp.sfa_ProfilePaymentAmount,
                         paymentPosted = cdp.sfa_PaymentPosted,
                         CDPId = cdp.sfa_contractdeliverableperiodId.Value,
                         ProfileSubnominalId = cdp.sfa_profilesubnominal != null ? Convert.ToString(cdp.sfa_profilesubnominal.Id) : null,
                         DeliverableCode = cd.sfa_DeliverableCode,
                         PeriodName = cdp.sfa_PeriodName,
                         Period = cdp.sfa_Period,
                         ContractVersion = c.sfa_Version
                     }
                 )
                 .ToList();

                return res.ToList();
            }
        }



        public static SubnominalAggregationData GetSubnominalAggreagetion(
        string key)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                var res = (
                     from sa in context.sfa_subnominalaggregationSet
                     where sa.sfa_SubnominalAggregateKey == key

                     select new SubnominalAggregationData
                     {
                         SAId = sa.sfa_subnominalaggregationId.Value,
                         SubnominalCode = sa.sfa_name,
                         AggregateValue = sa.sfa_AggregatedValue,
                         AggregateKey = sa.sfa_SubnominalAggregateKey
                     }
                 )
                 .FirstOrDefault();

                return res;
            }
        }

        public static IReadOnlyCollection<Guid> GetCdpIdsLatestAllocation(Guid cdId)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                var data = context.sfa_contractdeliverableperiodSet.Where(x => x.sfa_ContractDeliverableId.Id == cdId).Select(x => x.Id).ToList();

                data = context.sfa_contractdeliverableperiodSet.Where(x => x.sfa_ContractDeliverableId.Id == cdId).Select(x => x.sfa_contractdeliverableperiodId.Value).ToList();
                return data;
            }
        }

        public static Guid GetSubnominolAggregationId(string key)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                var data = context.sfa_subnominalaggregationSet.Where(x => x.sfa_SubnominalAggregateKey == key).Select(x => x.sfa_subnominalaggregationId.Value).FirstOrDefault();
                return data;
            }
        }

        public static List<Guid> GetSubnominolAggregationId1()
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                var data = context.sfa_fundingstreamperioddeliverableSet.Where(x => x.sfa_DeliverableCode == 688).Select(x => x.Id).ToList();
                return data;
            }
        }


        public static ContractAllocation GetContractAllocationsbyAllocationNo(
  string allocationNumber, int? latestVersion)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                var res = (
                     from c in context.sfa_contractSet
                     join ca in context.sfa_contractallocationSet on c.sfa_contractId.Value equals ca.sfa_ContractId.Id
                     where
                     c.sfa_Version == latestVersion
                           && ca.sfa_contractallocationnumber == allocationNumber


                     select new ContractAllocation
                     {
                         ContractId = c.Id,
                         CAID = ca.sfa_contractallocationId.Value,
                         AllocationNumber = ca.sfa_contractallocationnumber,
                         Ukprn = ca.sfa_deliveryorganisationukprn,
                         ContractVersion = c.sfa_Version
                     }
                 ).FirstOrDefault();

                return res;
            }
        }

        public static List<ContractDeliverable> GetContractDeliverablebyAllocationNo(
 string allocationNumber, string prevVersion, string insertedDelCode)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            int? previousVersion = Convert.ToInt32(prevVersion);

            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                var res = (
                     from c in context.sfa_contractSet
                     join ca in context.sfa_contractallocationSet on c.sfa_contractId.Value equals ca.sfa_ContractId.Id
                     join cd in context.sfa_contractdeliverableSet on ca.sfa_contractallocationId.Value equals cd.sfa_ContractAllocationId.Id
                     //                     join cdp in context.sfa_contractdeliverableperiodSet on cd.sfa_contractdeliverableId.Value equals cdp.sfa_ContractDeliverableId.Id

                     where
                     c.sfa_Version == previousVersion
                           && ca.sfa_contractallocationnumber == allocationNumber
                           && cd.sfa_DeliverableCode != insertedDelCode

                     select new ContractDeliverable
                     { //sfa_contractdeliverableState
                         statusCode = cd.statuscode.Value,
                         stateCode = cd.statecode.Value,
                         sfa_ContractAllocationId = ca.sfa_contractallocationId.Value,
                         AllocationNumber = ca.sfa_contractallocationnumber,
                         sfa_ActualValue = cd.sfa_ActualValue,
                         sfa_AllocationRef = cd.sfa_AllocationRef,
                         //sfa_contractdeliverableId = cd.sfa_contractdeliverableId.Value,
                         sfa_DeliverableCode = cd.sfa_DeliverableCode,
                         sfa_DeliverableDescription = cd.sfa_DeliverableDescription,
                         sfa_UnitCost = cd.sfa_UnitCost,
                         sfa_ContractId = c.sfa_contractId.Value,
                         sfa_deliverablename = cd.sfa_deliverablename,
                         sfa_DisplayOrder = cd.sfa_DisplayOrder,
                         sfa_FundingStreamPeriodDeliverableId = cd.sfa_FundingStreamPeriodDeliverableId.Id,
                         sfa_ParentDeliverableId = cd.sfa_ParentDeliverableId.Id,
                         sfa_PlannedValue = cd.sfa_PlannedValue,
                         sfa_PlannedVolume = cd.sfa_PlannedVolume,
                         Contractdeliverableperiod = GetDeliverablePeriod(cd.sfa_contractdeliverableId.Value)
                     }
                 ).ToList();

                return res;
            }

        }

        private static List<sfa_contractdeliverableperiod> GetDeliverablePeriod(Guid deliverableId)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
              return  (from p in context.sfa_contractdeliverableperiodSet
                         where p.sfa_ContractDeliverableId.Id == deliverableId
                        orderby p.sfa_DisplayOrder                 
                       select new sfa_contractdeliverableperiod
                       {
                           sfa_name = p.sfa_name,
                          sfa_PeriodName = p.sfa_PeriodName,
                          sfa_Period = p.sfa_Period,
                          sfa_Year = p.sfa_Year,
                          sfa_ContractDeliverableId = p.sfa_ContractDeliverableId,
                          OwnerId = p.OwnerId,
                          sfa_PeriodTypeId = p.sfa_PeriodTypeId,
                          sfa_DisplayOrder = p.sfa_DisplayOrder,
                          sfa_PaymentPosted = p.sfa_PaymentPosted,
                          sfa_profilesubnominal = p.sfa_profilesubnominal,
                          sfa_CappingSubnominal = p.sfa_CappingSubnominal,
                          sfa_ActualValue = p.sfa_ActualValue,
                          sfa_ActualVolume = p.sfa_ActualVolume,
                          sfa_BalancingPaymentAmount = p.sfa_BalancingPaymentAmount,
                          sfa_CappedPaymentAmount = p.sfa_CappedPaymentAmount,
                          sfa_NetPaymentAmount = p.sfa_NetPaymentAmount,
                          sfa_PlannedValue = p.sfa_PlannedValue,
                          sfa_PlannedVolume = p.sfa_PlannedVolume,
                          sfa_ProfilePaymentAmount =p.sfa_ProfilePaymentAmount,
                          sfa_ReconciliationPaymentAmount = p.sfa_ReconciliationPaymentAmount,
                          sfa_reconciliationsubnominal = p.sfa_reconciliationsubnominal,
                          sfa_UnitCost = p.sfa_UnitCost,
                          sfa_aggregate = p.sfa_aggregate
                       }).ToList();

              
            }
        }

        public static void InsertDeliverablePeriod(sfa_contractdeliverableperiod basedOnContractDeliverablePeriod, EntityReference deliverableToRelateTo)
        {
            IOrganizationService _organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            var deliverablePeriodEntity = new sfa_contractdeliverableperiod
            {
                sfa_name = basedOnContractDeliverablePeriod.sfa_name,
                sfa_PeriodName = basedOnContractDeliverablePeriod.sfa_PeriodName,
                sfa_Period = basedOnContractDeliverablePeriod.sfa_Period,
                sfa_Year = basedOnContractDeliverablePeriod.sfa_Year,
                sfa_ContractDeliverableId = deliverableToRelateTo,
                OwnerId = basedOnContractDeliverablePeriod.OwnerId,
                sfa_PeriodTypeId = basedOnContractDeliverablePeriod.sfa_PeriodTypeId,
                sfa_DisplayOrder = basedOnContractDeliverablePeriod.sfa_DisplayOrder,
                sfa_PaymentPosted = basedOnContractDeliverablePeriod.sfa_PaymentPosted,
                sfa_profilesubnominal = basedOnContractDeliverablePeriod.sfa_profilesubnominal,
                sfa_CappingSubnominal = basedOnContractDeliverablePeriod.sfa_CappingSubnominal,
                sfa_ActualValue = basedOnContractDeliverablePeriod.sfa_ActualValue,
                sfa_ActualVolume = basedOnContractDeliverablePeriod.sfa_ActualVolume,
                sfa_BalancingPaymentAmount = basedOnContractDeliverablePeriod.sfa_BalancingPaymentAmount,
                sfa_CappedPaymentAmount = basedOnContractDeliverablePeriod.sfa_CappedPaymentAmount,
                sfa_NetPaymentAmount = basedOnContractDeliverablePeriod.sfa_NetPaymentAmount,
                sfa_PlannedValue = basedOnContractDeliverablePeriod.sfa_PlannedValue,
                sfa_PlannedVolume = basedOnContractDeliverablePeriod.sfa_PlannedVolume,
                sfa_ProfilePaymentAmount = basedOnContractDeliverablePeriod.sfa_ProfilePaymentAmount,
                sfa_ReconciliationPaymentAmount = basedOnContractDeliverablePeriod.sfa_ReconciliationPaymentAmount,
                sfa_reconciliationsubnominal = basedOnContractDeliverablePeriod.sfa_reconciliationsubnominal,
                sfa_UnitCost = basedOnContractDeliverablePeriod.sfa_UnitCost,
                sfa_aggregate = basedOnContractDeliverablePeriod.sfa_aggregate
            };

            _organizationService.Create(deliverablePeriodEntity);
        }

        public static List<ContractDeliverablePeriodWithSubnominal> GetContractDeliverablePeridIDsByAllocationNumber(string allocationNumber)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {

                var res = (
                     from c in context.sfa_contractSet
                     join ca in context.sfa_contractallocationSet on c.sfa_contractId.Value equals ca.sfa_ContractId.Id
                     join cd in context.sfa_contractdeliverableSet on ca.sfa_contractallocationId.Value equals cd.sfa_ContractAllocationId.Id
                     join cdp in context.sfa_contractdeliverableperiodSet on cd.sfa_contractdeliverableId.Value equals cdp.sfa_ContractDeliverableId.Id

                     where
                     cdp.sfa_ReconciliationPaymentAmount != 0 &&
                     cdp.sfa_ReconciliationPaymentAmount != null
                           && ca.sfa_contractallocationnumber == allocationNumber
                     select new ContractDeliverablePeriodWithSubnominal
                     {                         
                         CDPId = cdp.sfa_contractdeliverableperiodId.Value,
                         ReconciliationSubnominal = cdp.sfa_reconciliationsubnominal != null ? Convert.ToString(cdp.sfa_reconciliationsubnominal.Id) : null,
                      }
                 )
                 .ToList();

                return res.ToList();
            }
        }

        public static List<ContractDeliverablePeriodWithSubnominal1> GetContractDeliverablePeridIDsByContractNumberAndPeriod(string contractNumber, string period)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {

                var res = (
                     from c in context.sfa_contractSet
                     join ca in context.sfa_contractallocationSet on c.sfa_contractId.Value equals ca.sfa_ContractId.Id
                     join cd in context.sfa_contractdeliverableSet on ca.sfa_contractallocationId.Value equals cd.sfa_ContractAllocationId.Id
                     join cdp in context.sfa_contractdeliverableperiodSet on cd.sfa_contractdeliverableId.Value equals cdp.sfa_ContractDeliverableId.Id

                     where
                     c.sfa_number == contractNumber &&
                     cdp.sfa_name == period
                     select new ContractDeliverablePeriodWithSubnominal1
                     {
                         CDPId = cdp.sfa_contractdeliverableperiodId.Value,
                         Period = cdp.sfa_name,
                     }
                 )
                 .ToList();

                return res.ToList();
            }
        }
    }
}
