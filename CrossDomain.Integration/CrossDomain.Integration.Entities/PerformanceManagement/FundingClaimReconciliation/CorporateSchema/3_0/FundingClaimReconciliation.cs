// ReSharper disable InconsistentNaming
namespace SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.CorporateSchema._3_0
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics.CodeAnalysis;
    using System.Xml.Serialization;

    [Serializable]
    [XmlType(Namespace = "urn:sfa:schemas:FCReconciliation")]
    [XmlRoot("FCReconciliation", Namespace = "urn:sfa:schemas:FCReconciliation", IsNullable = false)]
    [ExcludeFromCodeCoverage]
    public class FCReconciliation
    {
        public FCReconciliation()
        {
            FCReconciliationAllAttrs = new FCReconciliationAllAttrsCT();
            SchemaVersion = 3.00m;
        }

        public FCReconciliationAllAttrsCT FCReconciliationAllAttrs { get; set; }

        [XmlAttribute]
        public decimal SchemaVersion { get; set; }
    }

    [XmlType(Namespace = "urn:sfa:schemas:FCReconciliation")]
    [ExcludeFromCodeCoverage]
    public class FCReconciliationAllAttrsCT
    {
        public FCReconciliationAllAttrsCT()
        {
            FCReconciliationNonPKeyAttrs = new FCReconciliationNonPKeyAttrsCT();
            FCReconciliationPKeyAttrs = new FCReconciliationPKeyAttrsCT();
        }

        public FCReconciliationPKeyAttrsCT FCReconciliationPKeyAttrs { get; set; }

        public FCReconciliationNonPKeyAttrsCT FCReconciliationNonPKeyAttrs { get; set; }
    }

    [XmlType(Namespace = "urn:sfa:schemas:FCReconciliation")]
    [ExcludeFromCodeCoverage]
    public class FCReconciliationPKeyAttrsCT
    {
        public FCReconciliationPKeyAttrsCT()
        {
            AllocationGroup = new AllocationGroupAllAttrsCT();
            ClaimType = new ClaimTypeAllAttrsCT();
            Period = new PeriodAllAttrsCT();
            Contractor = new ContractorAllAttrsCT();
        }

        public ContractorAllAttrsCT Contractor { get; set; }

        public PeriodAllAttrsCT Period { get; set; }

        public int ClaimVersionNumber { get; set; }

        public ClaimTypeAllAttrsCT ClaimType { get; set; }

        public AllocationGroupAllAttrsCT AllocationGroup { get; set; }
    }

    [XmlType(Namespace = "urn:sfa:schemas:FCReconciliation")]
    [ExcludeFromCodeCoverage]
    public class ContractorAllAttrsCT
    {
        public ContractorAllAttrsCT()
        {
            ContractorNonPKeyAttrs = new ContractorNonPKeyAttrsCT();
            ContractorPKeyAttrs = new ContractorPKeyAttrsCT();
        }

        public ContractorPKeyAttrsCT ContractorPKeyAttrs { get; set; }

        public ContractorNonPKeyAttrsCT ContractorNonPKeyAttrs { get; set; }
    }

    [XmlType(Namespace = "urn:sfa:schemas:FCReconciliation")]
    [ExcludeFromCodeCoverage]
    public class ContractorPKeyAttrsCT
    {
        public string OrganisationIdentifier { get; set; }
    }

    [XmlType(Namespace = "urn:sfa:schemas:FCReconciliation")]
    [ExcludeFromCodeCoverage]
    public class FundingTypeNonPKeyAttrsCT
    {
        public string FundingTypeName { get; set; }
    }

    [XmlType(Namespace = "urn:sfa:schemas:FCReconciliation")]
    [ExcludeFromCodeCoverage]
    public class FundingTypePKeyAttrsCT
    {
        public string FundingTypeCode { get; set; }
    }

    [XmlType(Namespace = "urn:sfa:schemas:FCReconciliation")]
    [ExcludeFromCodeCoverage]
    public class FundingTypeAllAttrsCT
    {
        public FundingTypeAllAttrsCT()
        {
            FundingTypeNonPKeyAttrs = new FundingTypeNonPKeyAttrsCT();
            FundingPKeyAttrs = new FundingTypePKeyAttrsCT();
        }

        public FundingTypePKeyAttrsCT FundingPKeyAttrs { get; set; }

        public FundingTypeNonPKeyAttrsCT FundingTypeNonPKeyAttrs { get; set; }
    }

    [XmlType(Namespace = "urn:sfa:schemas:FCReconciliation")]
    [ExcludeFromCodeCoverage]
    public class ContractAllAttrsCT
    {
        public ContractAllAttrsCT()
        {
            FundingTypeAllAttrs = new FundingTypeAllAttrsCT();
        }

        public string ContractNumber { get; set; }

        public int ContractVersionNumber { get; set; }

        public int ContractSubVersionNumber { get; set; }

        public FundingTypeAllAttrsCT FundingTypeAllAttrs { get; set; }

        [XmlElement(DataType = "date", IsNullable = true)]
        public DateTime? ContractApprovalDate { get; set; }
    }

    [XmlType(Namespace = "urn:sfa:schemas:FCReconciliation")]
    [ExcludeFromCodeCoverage]
    public class ContractAllocationDNAttrsCT
    {
        public ContractAllocationDNAttrsCT()
        {
            ContractAttrs = new ContractAllAttrsCT();
        }

        public ContractAllAttrsCT ContractAttrs { get; set; }
    }

    [XmlType(Namespace = "urn:sfa:schemas:FCReconciliation")]
    [ExcludeFromCodeCoverage]
    public class DeliverableAllAttrsCT
    {
        public int DeliverableCode { get; set; }

        public string DeliverableName { get; set; }
    }

    [XmlType(Namespace = "urn:sfa:schemas:FCReconciliation")]
    [ExcludeFromCodeCoverage]
    public class ContractAllocationNonPKeyAttrsCT
    {
        public ContractAllocationNonPKeyAttrsCT()
        {
            ContractDeliverables = new List<ContractDeliverablesAllAttrsCTContractDeliverable>();
            AmountAttrs = new AmountAttrsCT();
        }

        public string FundingstreamPeriodCode { get; set; }

        [XmlElement(DataType = "date")]
        public DateTime AllocationStartDate { get; set; }

        [XmlElement(DataType = "date")]
        public DateTime AllocationEndDate { get; set; }

        public AmountAttrsCT AmountAttrs { get; set; }

        [XmlArrayItem("ContractDeliverable", IsNullable = false)]
        public List<ContractDeliverablesAllAttrsCTContractDeliverable> ContractDeliverables { get; set; }
    }

    [XmlType(Namespace = "urn:sfa:schemas:FCReconciliation")]
    [ExcludeFromCodeCoverage]
    public class AmountAttrsCT
    {
        public decimal? PlannedValue { get; set; }

        public decimal? ClaimedValue { get; set; }

        public decimal? ProposedReconciliationValue { get; set; }

        public decimal? ReconciliationValue { get; set; }

        public decimal? CappedClaimedValue { get; set; }

        public decimal? AdjustedCappedClaimedValue { get; set; }

        public ClaimAdjustmentAttrsCT ClaimAdjustments { get; set; }

        public decimal? EarningsBoostValue { get; set; }
    }

    [XmlType(AnonymousType = true, Namespace = "urn:sfa:schemas:FCReconciliation")]
    [ExcludeFromCodeCoverage]
    public class ContractDeliverablesAllAttrsCTContractDeliverable
    {
        public ContractDeliverablesAllAttrsCTContractDeliverable()
        {
            AmountAttrs = new AmountAttrsCT();
            Deliverable = new DeliverableAllAttrsCT();
        }

        public DeliverableAllAttrsCT Deliverable { get; set; }

        public AmountAttrsCT AmountAttrs { get; set; }
    }

    [XmlType(Namespace = "urn:sfa:schemas:FCReconciliation")]
    [ExcludeFromCodeCoverage]
    public class ContractAllocationPKeyAttrsCT
    {
        public string ContractAllocationNumber { get; set; }
    }

    [XmlType(Namespace = "urn:sfa:schemas:FCReconciliation")]
    [ExcludeFromCodeCoverage]
    public class ContractAllocationAllAttrsCT
    {
        public ContractAllocationAllAttrsCT()
        {
            ContractAllocationDNAttrs = new ContractAllocationDNAttrsCT();
            ContractAllocationNonPKeyAttrs = new ContractAllocationNonPKeyAttrsCT();
            ContractAllocationPKeyAttrs = new ContractAllocationPKeyAttrsCT();
        }

        public ContractAllocationPKeyAttrsCT ContractAllocationPKeyAttrs { get; set; }

        public ContractAllocationNonPKeyAttrsCT ContractAllocationNonPKeyAttrs { get; set; }

        public ContractAllocationDNAttrsCT ContractAllocationDNAttrs { get; set; }
    }

    [XmlType(Namespace = "urn:sfa:schemas:FCReconciliation")]
    [ExcludeFromCodeCoverage]
    public class FCReconciliationNonPKeyAttrsCT
    {
        public FCReconciliationNonPKeyAttrsCT()
        {
            ContractAllocation = new List<ContractAllocationAllAttrsCT>();
            AmountAttrs = new AmountAttrsCT();
        }

        public ReconciliationStatusST Status { get; set; }

        [XmlElement(DataType = "date")]
        public DateTime StatusLastUpdatedDate { get; set; }

        public AmountAttrsCT AmountAttrs { get; set; }

        [XmlElement("ContractAllocation")]
        public List<ContractAllocationAllAttrsCT> ContractAllocation { get; set; }
    }
    
    [XmlType(Namespace = "urn:sfa:schemas:FCReconciliation")]
    public enum ReconciliationStatusST
    {
        Draft,
        Published
    }
    
    [XmlType(Namespace = "urn:sfa:schemas:FCReconciliation")]
    [ExcludeFromCodeCoverage]
    public class AllocationGroupNonPKeyAttrsCT
    {
        public string AllocationGroupName { get; set; }
    }
    
    [XmlType(Namespace = "urn:sfa:schemas:FCReconciliation")]
    [ExcludeFromCodeCoverage]
    public class AllocationGroupPKeyAttrsCT
    {
        public string AllocationGroupCode { get; set; }
    }
    
    [XmlType(Namespace = "urn:sfa:schemas:FCReconciliation")]
    [ExcludeFromCodeCoverage]
    public class AllocationGroupAllAttrsCT
    {
        public AllocationGroupAllAttrsCT()
        {
            AllocationGroupNonPKeyAttrs = new AllocationGroupNonPKeyAttrsCT();
            AllocationGroupPKeyAttrs = new AllocationGroupPKeyAttrsCT();
        }

        public AllocationGroupPKeyAttrsCT AllocationGroupPKeyAttrs { get; set; }

        public AllocationGroupNonPKeyAttrsCT AllocationGroupNonPKeyAttrs { get; set; }
    }

    [XmlType(Namespace = "urn:sfa:schemas:FCReconciliation")]
    [ExcludeFromCodeCoverage]
    public class ClaimTypeNonPKeyAttrsCT
    {
        public string ClaimTypeName { get; set; }
    }
    
    [XmlType(Namespace = "urn:sfa:schemas:FCReconciliation")]
    [ExcludeFromCodeCoverage]
    public class ClaimTypePKeyAttrsCT
    {
        public string ClaimTypeCode { get; set; }
    }
    
    [XmlType(Namespace = "urn:sfa:schemas:FCReconciliation")]
    [ExcludeFromCodeCoverage]
    public class ClaimTypeAllAttrsCT
    {
        public ClaimTypeAllAttrsCT()
        {
            ClaimTypeNonPKeyAttrs = new ClaimTypeNonPKeyAttrsCT();
            ClaimTypePKeyAttrs = new ClaimTypePKeyAttrsCT();
        }

        public ClaimTypePKeyAttrsCT ClaimTypePKeyAttrs { get; set; }

        public ClaimTypeNonPKeyAttrsCT ClaimTypeNonPKeyAttrs { get; set; }
    }
    
    [XmlType(Namespace = "urn:sfa:schemas:FCReconciliation")]
    [ExcludeFromCodeCoverage]
    public class PeriodTypeNonPKeyAttrsCT
    {
        public PeriodTypeNameST PeriodTypeName { get; set; }
    }
    
    [XmlType(Namespace = "urn:sfa:schemas:FCReconciliation")]
    public enum PeriodTypeNameST
    {
        [XmlEnum("ACADEMIC YEAR")]
        ACADEMICYEAR,

        [XmlEnum("CALENDAR YEAR")]
        CALENDARYEAR,

        [XmlEnum("FINANCIAL YEAR")]
        FINANCIALYEAR,

        [XmlEnum("CALENDAR MONTH")]
        CALENDARMONTH,

        [XmlEnum("CALENDAR QUARTER")]
        CALENDARQUARTER
    }
    
    [XmlType(Namespace = "urn:sfa:schemas:FCReconciliation")]
    [ExcludeFromCodeCoverage]
    public class PeriodTypePKeyAttrsCT
    {
        public PeriodTypeCodeST PeriodTypeCode { get; set; }
    }
    
    [XmlType(Namespace = "urn:sfa:schemas:FCReconciliation")]
    public enum PeriodTypeCodeST
    {

        AY,
        FY,
        CY,
        CM,
        CQ
    }
    
    [XmlType(Namespace = "urn:sfa:schemas:FCReconciliation")]
    [ExcludeFromCodeCoverage]
    public class PeriodAllAttrsCT
    {
        public PeriodAllAttrsCT()
        {
            PeriodTypeNonPKeyAttrs = new PeriodTypeNonPKeyAttrsCT();
            PeriodTypePKeyAttrs = new PeriodTypePKeyAttrsCT();
        }

        public PeriodTypePKeyAttrsCT PeriodTypePKeyAttrs { get; set; }

        public PeriodTypeNonPKeyAttrsCT PeriodTypeNonPKeyAttrs { get; set; }

        public string Period { get; set; }
    }
    
    [XmlType(Namespace = "urn:sfa:schemas:FCReconciliation")]
    [ExcludeFromCodeCoverage]
    public class ContractorNonPKeyAttrsCT
    {
        public int UKPRN { get; set; }

        public string LegalName { get; set; }
    }

    [XmlType(Namespace = "urn:sfa:schemas:FCReconciliation")]
    [ExcludeFromCodeCoverage]
    public class ClaimAdjustmentAttrsCT
    {
        public decimal ClaimAdjustmentValue { get; set; }

        public string ClaimAdjustmentReason { get; set; }
    }
}
