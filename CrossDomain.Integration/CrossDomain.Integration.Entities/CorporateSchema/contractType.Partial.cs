namespace SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract
{
    using System.Linq;
    using System;

    public partial class contractType
    {
        public virtual bool ShouldSerializecontracts()
        {
            return (contracts != null && contracts.Any());
        }

        public virtual bool ShouldSerializecontractAllocations()
        {
            return (contractAllocations != null && contractAllocations.Any());
        }

        public virtual bool ShouldSerializeTerminationContractAttrs()
        {
            bool HasContractTerminationValues() =>
                TerminationContractAttrs?.terminationDate != null && TerminationContractAttrs.terminationDate != DateTime.MinValue;

            bool HasAllocationTerminationValues(contractAllocationsContractAllocation a) =>
                a.allocationTerminationAttrs?.fundingCessationDate != null;

            return HasContractTerminationValues() || contractAllocations.Any(HasAllocationTerminationValues);
        }

        public virtual bool ShouldSerializefundingStream()
        {
            return (fundingStream != null && !string.IsNullOrEmpty(fundingStream.fundingStreamCode)
                && !string.IsNullOrEmpty(fundingStream.fundingStreamName)
                && !string.IsNullOrEmpty(fundingStream.fundingTypeCode));
        }

        /// <summary>
        /// Test whether ContractApprovalDate should be serialized
        /// </summary>
        public virtual bool ShouldSerializeContractApprovalDate()
        {
            return ContractApprovalDate.HasValue;
        }

        /// <summary>
        /// Test whether StatusLastUpdatedDate should be serialized
        /// </summary>
        public virtual bool ShouldSerializeStatusLastUpdatedDate()
        {
            return StatusLastUpdatedDate.HasValue;
        }

        /// <summary>
        /// Test whether LastModifiedDate should be serialized
        /// </summary>
        public virtual bool ShouldSerializeLastModifiedDate()
        {
            return LastModifiedDate.HasValue;
        }

        /// <summary>
        /// Test whether startDate should be serialized
        /// </summary>
        public virtual bool ShouldSerializestartDate()
        {
            return startDate.HasValue;
        }

        /// <summary>
        /// Test whether endDate should be serialized
        /// </summary>
        public virtual bool ShouldSerializeendDate()
        {
            return endDate.HasValue;
        }

        /// <summary>
        /// Test whether contractValue should be serialized
        /// </summary>
        public virtual bool ShouldSerializecontractValue()
        {
            return contractValue.HasValue;
        }

        /// <summary>
        /// Test whether parentContractVersionNumber should be serialized
        /// </summary>
        public virtual bool ShouldSerializeparentContractVersionNumber()
        {
            return parentContractVersionNumber.HasValue;
        }
    }
}
