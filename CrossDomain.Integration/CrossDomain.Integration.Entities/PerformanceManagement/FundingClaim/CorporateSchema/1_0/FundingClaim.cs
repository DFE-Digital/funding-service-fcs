// ReSharper disable InconsistentNaming
namespace SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.CorporateSchema._1_0
{
    using System;
    using System.Collections.Generic;
    using System.Xml.Serialization;

    [Serializable]
    [XmlType(AnonymousType = true, Namespace = "urn:sfa:schemas:fundingclaim")]
    [XmlRoot(Namespace = "urn:sfa:schemas:fundingclaim", IsNullable = false)]
    public class FundingClaim
    {
        public FundingClaim()
        {
            FundingClaimAllAttrs = new List<FundingClaimAllAttrsCT>();
            schemaVersion = 1.00m;
        }

        [XmlElement("FundingClaimAllAttrs", Order = 0)]
        public List<FundingClaimAllAttrsCT> FundingClaimAllAttrs { get; set; }

        [XmlAttribute]
        public decimal schemaVersion { get; set; }
    }

    [Serializable]
    [XmlType(Namespace = "urn:sfa:schemas:fundingclaim")]
    [XmlRoot(Namespace = "urn:sfa:schemas:fundingclaim", IsNullable = true)]
    public class FundingClaimAllAttrsCT
    {
        public FundingClaimAllAttrsCT()
        {
            ContractAllocations = new List<ContractAllocationAllAttrsCT>();
            FundingClaimNonPKeyAttrs = new FundingClaimNonPKeyAttrsCT();
            FundingClaimPKeyAttrs = new FundingClaimPKeyAttrsCT();
        }

        [XmlElement(Order = 0)]
        public FundingClaimPKeyAttrsCT FundingClaimPKeyAttrs { get; set; }

        [XmlElement(Order = 1)]
        public FundingClaimNonPKeyAttrsCT FundingClaimNonPKeyAttrs { get; set; }

        [XmlElement("ContractAllocations", Order = 2)]
        public List<ContractAllocationAllAttrsCT> ContractAllocations { get; set; }
    }

    [Serializable]
    [XmlType(Namespace = "urn:sfa:schemas:fundingclaim")]
    [XmlRoot(Namespace = "urn:sfa:schemas:fundingclaim", IsNullable = true)]
    public class FundingClaimPKeyAttrsCT
    {
        public FundingClaimPKeyAttrsCT()
        {
            Period = new PeriodPKeyAttrsCT();
            Contractor = new ContractorAllAttrsCT();
        }

        [XmlElement(Order = 0)]
        public ContractorAllAttrsCT Contractor { get; set; }

        [XmlElement(Order = 1)]
        public int VersionNumber { get; set; }

        [XmlElement(Order = 2)]
        public ClaimTypeNameST ClaimTypeName { get; set; }

        [XmlElement(Order = 3)]
        public PeriodPKeyAttrsCT Period { get; set; }
    }

    [Serializable]
    [XmlType(Namespace = "urn:sfa:schemas:fundingclaim")]
    [XmlRoot(Namespace = "urn:sfa:schemas:fundingclaim", IsNullable = true)]
    public class ContractorAllAttrsCT
    {
        public ContractorAllAttrsCT()
        {
            ContractorNonPKeyAttrs = new ContractorNonPKeyAttrsCT();
            ContractorPKeyAttrs = new ContractorPKeyAttrsCT();
        }

        [XmlElement(Order = 0)]
        public ContractorPKeyAttrsCT ContractorPKeyAttrs { get; set; }

        [XmlElement(Order = 1)]
        public ContractorNonPKeyAttrsCT ContractorNonPKeyAttrs { get; set; }
    }

    [Serializable]
    [XmlType(Namespace = "urn:sfa:schemas:fundingclaim")]
    [XmlRoot(Namespace = "urn:sfa:schemas:fundingclaim", IsNullable = true)]
    public class ContractorPKeyAttrsCT
    {
        [XmlElement(Order = 0)]
        public string OrganisationIdentifier { get; set; }
    }

    [Serializable]
    [XmlType(Namespace = "urn:sfa:schemas:fundingclaim")]
    [XmlRoot(Namespace = "urn:sfa:schemas:fundingclaim", IsNullable = true)]
    public class DeliverableLineNonPKeyAttrsCT
    {
        [XmlElement(IsNullable = true, Order = 0)]
        public decimal? ActualValue { get; set; }

        [XmlElement(IsNullable = true, Order = 1)]
        public decimal? ForecastValue { get; set; }

        [XmlElement(IsNullable = true, Order = 2)]
        public decimal? AdjustmentValue { get; set; }
    }

    [Serializable]
    [XmlType(Namespace = "urn:sfa:schemas:fundingclaim")]
    [XmlRoot(Namespace = "urn:sfa:schemas:fundingclaim", IsNullable = true)]
    public class DeliverableLinePKeyAttrsCT
    {
        [XmlElement(Order = 0)]
        public int DeliverableCode { get; set; }
    }

    [Serializable]
    [XmlType(Namespace = "urn:sfa:schemas:fundingclaim")]
    [XmlRoot(Namespace = "urn:sfa:schemas:fundingclaim", IsNullable = true)]
    public class DeliverableLineAllAttrsCT
    {
        public DeliverableLineAllAttrsCT()
        {
            DeliverableLineNonPKeyAttrs = new DeliverableLineNonPKeyAttrsCT();
            DeliverableLinePKeyAttrs = new DeliverableLinePKeyAttrsCT();
        }

        [XmlElement(Order = 0)]
        public DeliverableLinePKeyAttrsCT DeliverableLinePKeyAttrs { get; set; }

        [XmlElement(Order = 1)]
        public DeliverableLineNonPKeyAttrsCT DeliverableLineNonPKeyAttrs { get; set; }
    }

    [Serializable]
    [XmlType(Namespace = "urn:sfa:schemas:fundingclaim")]
    [XmlRoot(Namespace = "urn:sfa:schemas:fundingclaim", IsNullable = true)]
    public class ContractAllocationNonPKeyAttrsCT
    {
        [XmlElement(Order = 0)]
        public string FundingStreamPeriodCode { get; set; }
    }

    [Serializable]
    [XmlType(Namespace = "urn:sfa:schemas:fundingclaim")]
    [XmlRoot(Namespace = "urn:sfa:schemas:fundingclaim", IsNullable = true)]
    public class ContractAllocationPKeyAttrsCT
    {

        [XmlElement(Order = 0)]
        public string ContractAllocationNumber { get; set; }
    }

    [Serializable]
    [XmlType(Namespace = "urn:sfa:schemas:fundingclaim")]
    [XmlRoot(Namespace = "urn:sfa:schemas:fundingclaim", IsNullable = true)]
    public class ContractAllocationAllAttrsCT
    {
        public ContractAllocationAllAttrsCT()
        {
            DeliverableLines = new List<DeliverableLineAllAttrsCT>();
            ContractAllocationNonPKeyAttrs = new ContractAllocationNonPKeyAttrsCT();
            ContractAllocationPKeyAttrs = new ContractAllocationPKeyAttrsCT();
        }

        [XmlElement(Order = 0)]
        public ContractAllocationPKeyAttrsCT ContractAllocationPKeyAttrs { get; set; }

        [XmlElement(Order = 1)]
        public ContractAllocationNonPKeyAttrsCT ContractAllocationNonPKeyAttrs { get; set; }

        [XmlElement("DeliverableLines", Order = 2)]
        public List<DeliverableLineAllAttrsCT> DeliverableLines { get; set; }
    }

    [Serializable]
    [XmlType(Namespace = "urn:sfa:schemas:fundingclaim")]
    [XmlRoot(Namespace = "urn:sfa:schemas:fundingclaim", IsNullable = true)]
    public class FundingClaimNonPKeyAttrsCT
    {
        [XmlElement(Order = 0)]
        public bool HasBeenSigned { get; set; }
    }

    [Serializable]
    [XmlType(Namespace = "urn:sfa:schemas:fundingclaim")]
    [XmlRoot(Namespace = "urn:sfa:schemas:fundingclaim", IsNullable = true)]
    public class PeriodTypePKeyAttrsCT
    {
        [XmlElement(Order = 0)]
        public PeriodTypeCodeST PeriodTypeCode { get; set; }
    }

    [Serializable]
    [XmlType(Namespace = "urn:sfa:schemas:fundingclaim")]
    [XmlRoot(Namespace = "urn:sfa:schemas:fundingclaim", IsNullable = false)]
    public enum PeriodTypeCodeST
    {
        AY,
        AP,
        AQ,
        FY,
        FP,
        FQ,
        CY,
        CM,
        CQ,
        ESF,
        EOF,
        EOP,
    }

    [Serializable]
    [XmlType(Namespace = "urn:sfa:schemas:fundingclaim")]
    [XmlRoot(Namespace = "urn:sfa:schemas:fundingclaim", IsNullable = true)]
    public class PeriodPKeyAttrsCT
    {
        public PeriodPKeyAttrsCT()
        {
            PeriodTypePKeyAttrs = new PeriodTypePKeyAttrsCT();
        }

        [XmlElement(Order = 0)]
        public PeriodTypePKeyAttrsCT PeriodTypePKeyAttrs { get; set; }

        [XmlElement(Order = 1)]
        public string Period { get; set; }
    }

    [Serializable]
    [XmlType(Namespace = "urn:sfa:schemas:fundingclaim")]
    [XmlRoot(Namespace = "urn:sfa:schemas:fundingclaim", IsNullable = true)]
    public class ContractorNonPKeyAttrsCT
    {
        [XmlElement(Order = 0)]
        public int Ukprn { get; set; }
    }

    [Serializable]
    [XmlType(Namespace = "urn:sfa:schemas:fundingclaim")]
    [XmlRoot(Namespace = "urn:sfa:schemas:fundingclaim", IsNullable = false)]
    public enum ClaimTypeNameST
    {
        [XmlEnum("MID YEAR")]
        MIDYEAR,

        [XmlEnum("YEAR END")]
        YEAREND,

        FINAL,
    }

    [Serializable]
    [XmlType(AnonymousType = true, Namespace = "urn:sfa:schemas:fundingclaim")]
    [XmlRoot(Namespace = "urn:sfa:schemas:fundingclaim", IsNullable = false)]
    public class ContractAllocation
    {
        public ContractAllocation()
        {
            ContractAllocationAllAttrs = new List<ContractAllocationAllAttrsCT>();
        }

        [XmlElement("ContractAllocationAllAttrs", Order = 0)]
        public List<ContractAllocationAllAttrsCT> ContractAllocationAllAttrs { get; set; }
    }

    [Serializable]
    [XmlType(AnonymousType = true, Namespace = "urn:sfa:schemas:fundingclaim")]
    [XmlRoot(Namespace = "urn:sfa:schemas:fundingclaim", IsNullable = false)]
    public class DeliverableLine
    {
        public DeliverableLine()
        {
            DeliverableLineAllAttrs = new List<DeliverableLineAllAttrsCT>();
        }

        [XmlElement("DeliverableLineAllAttrs", Order = 0)]
        public List<DeliverableLineAllAttrsCT> DeliverableLineAllAttrs { get; set; }
    }
}
