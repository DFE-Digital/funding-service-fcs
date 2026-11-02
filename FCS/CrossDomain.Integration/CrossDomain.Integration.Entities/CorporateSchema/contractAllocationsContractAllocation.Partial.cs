namespace SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract
{
    using System;
    using System.Collections.Generic;
    using System.Linq;

    public partial class contractAllocationsContractAllocation
    {
        public virtual bool ShouldSerializecontractAllocations()
        {
            return (contractAllocations != null && contractAllocations.Any());
        }

        public virtual bool ShouldSerializecontractDeliverables()
        {
            return (contractDeliverables != null && contractDeliverables.Any());
        }

        //This is called by .NET Serializer and is needed to prevent generation empty element for nullable property 
        public virtual bool ShouldSerializeProcurementAttrs()
        {
            return ProcurementAttrs != null 
                && !String.IsNullOrEmpty(ProcurementAttrs.TenderSpecReference);
        }

        /// <summary>
        /// Test whether endDate should be serialized
        /// </summary>
        public virtual bool ShouldSerializeendDate()
        {
            return endDate.HasValue;
        }

        public virtual bool ShouldSerializeallocationTerminationAttrs()
        {
            return allocationTerminationAttrs != null && (
                allocationTerminationAttrs.ShouldSerializefundingCessationDate() ||
                allocationTerminationAttrs.ShouldSerializenewStartsSuspendedReason() ||
                allocationTerminationAttrs.ShouldSerializestopNewStartsFromDate()
                );
        }

        public IReadOnlyCollection<contractDeliverablesTypeContractDeliverable> GetFlattenedDeliverables()
        {
            return FlattenDeliverables(this.contractDeliverables);
        }

        public List<contractDeliverablesTypeContractDeliverable> FlattenDeliverables(
            List<contractDeliverablesTypeContractDeliverable> hierarchicalDeliverableList,
            List<contractDeliverablesTypeContractDeliverable> flattenedList = null)
        {
            flattenedList = flattenedList ?? new List<contractDeliverablesTypeContractDeliverable>();

            foreach (var deliverable in hierarchicalDeliverableList)
            {
                flattenedList.Add(deliverable);

                flattenedList = FlattenDeliverables(deliverable.contractDeliverables, flattenedList);
            }

            return flattenedList;
        }

        internal class FundingStreamPeriodInfo
        {
            public FundingStreamPeriodInfo(string fundingTypeCode, string period)
            {
                FundingTypeCode = fundingTypeCode;
                Period = period;
            }

            public string FundingTypeCode { get; }

            public string Period { get; }
        }
    }
}
