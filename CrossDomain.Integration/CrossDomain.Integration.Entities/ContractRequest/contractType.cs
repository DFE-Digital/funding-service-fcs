namespace SFA.FCT.CrossDomain.Integration.Entities.ContractRequest
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics.CodeAnalysis;
    using System.Xml.Serialization;
    using System.Linq;

    [Serializable]
    [XmlType(Namespace = "contractrequest")]
    [XmlRoot(Namespace = "contractrequest", IsNullable = true)]
    [SuppressMessage("ReSharper", "InconsistentNaming")]
    public class contractType
    {
        public contractType()
        {
            contractor = new contractor();
            contractAllocations = new List<contractAllocation>();
            period = new periodType();
            contracts = new List<contractType>();
            ApprovedAllocationValues = new List<AllocationValueData>();
        }

        [XmlElement(Order = 0)]
        public string correlationId { get; set; }

        [XmlArray(Order = 1)]
        [XmlArrayItem("contract", IsNullable = false)]
        public List<contractType> contracts { get; set; }

        [XmlElement(Order = 2)]
        public string fundingTypeCode { get; set; }

        [XmlElement(Order = 3)]
        public periodType period { get; set; }

        [XmlArray(Order = 4)]
        [XmlArrayItem(IsNullable = false)]
        public List<contractAllocation> contractAllocations { get; set; }

        [XmlElement(Order = 5)]
        public string contractNumber { get; set; }

        [XmlElement(IsNullable = true, Order = 6)]
        public int? contractVersionNumber { get; set; }

        [XmlElement(IsNullable = true, Order = 7)]
        public int? contractSubVersionNumber { get; set; }

        [XmlElement(Order = 8)]
        public string description { get; set; }

        [XmlElement(Order = 9)]
        public contractor contractor { get; set; }

        [XmlElement(Order = 10)]
        public hierarchyType hierarchyType { get; set; }

        [XmlElement("contractType", Order = 11)]
        public string contractType1 { get; set; }

        [XmlElement(DataType = "date", IsNullable = true, Order = 12)]
        public DateTime? startDate { get; set; }

        [XmlElement(DataType = "date", IsNullable = true, Order = 13)]
        public DateTime? endDate { get; set; }

        [XmlElement(Order = 14)]
        public string status { get; set; }

        [XmlElement(Order = 15)]
        public string subStatus { get; set; }

        [XmlElement(Order = 16)]
        public bool crmNotPresent { get; set; }

        [XmlAttribute]
        public intent CRMIntent { get; set; }

        [XmlAttribute]
        public amendmentType amendmentType { get; set; }

        [XmlIgnore]
        public bool IsPresentInCrm { get; set; }

        [XmlIgnore]
        public bool IsContractWithMatchingUKPRNPeriodAndFundingTypePresentInCrm { get; set; }

        [XmlIgnore]
        public bool IsContractNumberWithMatchingUKPRNPeriodAndFundingTypePresentInCrm { get; set; }

        [XmlIgnore]
        public bool IsDraftContractWithContractNumberPresentInCrm { get; set; }

        [XmlIgnore]
        public bool IsApprovedContractWithContractNumberPresentInCrm { get; set; }

        [XmlIgnore]
        public bool IsWithdrawnContractWithContractNumberPresentInCrm { get; set; }

        [XmlIgnore]
        public bool IsNonWithdrawnOrSupersededDraftContractWithContractNumberPresentInCrm { get; set; }

        [XmlIgnore]
        public bool IsMasterContractWithMatchingMasterContractNumberPresentInCrm { get; set; }

        [XmlIgnore]
        public bool IsDraftOrApprovedContractForUkprnPresentInCrm { get; set; }

        [XmlIgnore]
        public decimal? ValueVariation { get; set; }

        [XmlIgnore]
        public Guid? PreviousVersionId { get; set; }

        [XmlIgnore]
        public Guid? Id { get; set; }

        [XmlIgnore]
        public CrmEntityOwner Owner { get; set; }

        [XmlIgnore]
        public Guid? ContractAdvisorId { get; set; }

        [XmlIgnore]
        public Guid? ParentContractId { get; set; }

        [XmlIgnore]
        public IEnumerable<AllocationValueData> ApprovedAllocationValues { get; set; }

        [XmlIgnore]
        public bool? SkipCaseloadAssignment { get; set; }

        [XmlIgnore]
        public bool? SkipReviewAndInternalApproval { get; set; }

        [XmlIgnore]
        public bool? SkipDocumentMerge { get; set; }

        [XmlIgnore]
        public DateTime? TerminationDate { get; set; }

        [XmlIgnore]
        public DateTime? InflightTerminationDate { get; set; }

        [XmlIgnore]
        public string TerminationReason { get; set; }

        [XmlIgnore]
        public string InflightTerminationReason { get; set; }

        [XmlIgnore]
        public DateTime? StopNewStartsDate { get; set; }

        [XmlIgnore]
        public DateTime? InflightStopNewStartsDate { get; set; }

        [XmlIgnore]
        public string NewStartsSuspendedReason { get; set; }

        [XmlIgnore]
        public string InflightNewStartsSuspendedReason { get; set; }

        public bool HasUnnumberedAllocations()
        {
            return
                contractAllocations != null
                && contractAllocations.Any(a => string.IsNullOrEmpty(a.contractAllocationNumber));
        }

        public bool IsLevyContract()
        {
            return fundingTypeCode == "LEVY";
        }

        public bool HasContractNumber()
        {
            return !string.IsNullOrEmpty(contractNumber);
        }

        public bool IsNewRevisedNewOrUpdateDraft()
        {
            IReadOnlyCollection<intent> newIntents = new List<intent>
            {
                intent.New, intent.RevisedNew, intent.UpdateDraft
            };

            return newIntents.Contains(this.CRMIntent);
        }

        public bool IsAmendment()
        {
            IReadOnlyCollection<intent> amendmentIntents = new List<intent>
            {
                intent.Amendment, intent.UpdateDraftAmendment
            };

            return amendmentIntents.Contains(this.CRMIntent);
        }

        public void EnsureAllAllocationsHaveTheSameModificationDetails(bool isContractModified)
        {
            var allocationWithModificationDetails = contractAllocations.FirstOrDefault(a => a.HasModificationDetails);
            if (isContractModified && allocationWithModificationDetails != null)
            {
                contractAllocations.ForEach(a =>
                {
                    a.InflightStopNewStartsDate = allocationWithModificationDetails.InflightStopNewStartsDate;
                    a.StopNewStartsDate = allocationWithModificationDetails.StopNewStartsDate;
                    a.InflightNewStartsSuspendedReason = allocationWithModificationDetails.InflightNewStartsSuspendedReason;
                    a.NewStartsSuspendedReason = allocationWithModificationDetails.NewStartsSuspendedReason;
                });
            }
        }

        internal bool IsNewAmendment()
        {
            return CRMIntent == intent.NewAmendment;
        }
    }
}
