namespace SFA.FCT.CrossDomain.Integration.Entities.ContractRequest
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics.CodeAnalysis;
    using System.Xml.Serialization;
    using Extensions;

    [Serializable]
    [XmlType(Namespace = "contractrequest")]
    [XmlRoot(Namespace = "contractrequest", IsNullable = true)]
    [SuppressMessage("ReSharper", "InconsistentNaming")]
    public class contractAllocation
    {
        public contractAllocation()
        {
            contractDeliverables = new List<contractDeliverable>();
            period = new periodType();
        }

        [XmlElement(Order = 0)]
        public string correlationId { get; set; }

        [XmlElement(Order = 1)]
        public periodType period { get; set; }

        [XmlElement(Order = 2)]
        public int ukprn { get; set; }

        [XmlElement(Order = 3)]
        public string fundingStreamCode { get; set; }

        [XmlElement(Order = 4)]
        public string LEPCode { get; set; }

        [XmlElement(Order = 5)]
        public string LEPName { get; set; }

        [XmlElement(Order = 6)]
        public string UoPCode { get; set; }

        [XmlElement(Order = 7)]
        public string tenderSpecificationReference { get; set; }

        [XmlElement(Order = 8)]
        public string lotReference { get; set; }

        [XmlElement(Order = 9)]
        public string tenderAwardReference { get; set; }

        [XmlElement(Order = 10)]
        public string activityDescription { get; set; }

        [XmlElement(Order = 11)]
        public string description { get; set; }

        [XmlElement(Order = 12)]
        public string investmentPriority { get; set; }

        [XmlElement(Order = 13)]
        public string agreementNumber { get; set; }

        [XmlElement(Order = 14)]
        public string specificationTitle { get; set; }

        [XmlElement(Order = 15)]
        public string regionType { get; set; }

        [XmlElement(Order = 16)]
        public string learningRatePremium { get; set; }

        [XmlElement(Order = 17)]
        public contractAllocationHierarchyType hierarchyType { get; set; }

        [XmlElement(DataType = "date", IsNullable = true, Order = 18)]
        public DateTime? startDate { get; set; }

        [XmlElement(DataType = "date", IsNullable = true, Order = 19)]
        public DateTime? endDate { get; set; }

        [XmlElement(Order = 20)]
        public string contractAllocationNumber { get; set; }

        [XmlElement(Order = 21)]
        public decimal maximumContractValue { get; set; }

        [XmlElement(Order = 22)]
        public string fundingStreamPeriodCode { get; set; }

        [XmlArray(Order = 23)]
        [XmlArrayItem(IsNullable = false)]
        public List<contractDeliverable> contractDeliverables { get; set; }

        [XmlElement(Order = 24)]
        public bool crmNotPresent { get; set; }

        [XmlAttribute]
        public intent CRMIntent { get; set; }

        [XmlAttribute]
        public string amendmentReason { get; set; }

        [XmlIgnore]
        public decimal? ValueVariation { get; set; }

        [XmlIgnore]
        public string DeliveryOrganisation { get; set; }

        [XmlIgnore]
        public contractor DeliveryOrganisationDetail { get; set; } = new contractor();

        [XmlIgnore]
        public DateTime? TerminationDate { get; set; }

        [XmlIgnore]
        public DateTime? InflightTerminationDate { get; set; }

        [XmlIgnore]
        public DateTime? StopNewStartsDate { get; set; }

        [XmlIgnore]
        public bool HasBeenAddedOrUpdated => HasBeenAdded || HasBeenUpdated;

        // Indicates if the allocation has been added since the 'Last Approved' contract
        [XmlIgnore]
        public bool HasBeenAdded { get; set; } = false;

        [XmlIgnore]
        public bool HasBeenUpdated { get; set; } = false;

        [XmlIgnore]
        public string NewStartsSuspendedReason { get; set; }

        [XmlIgnore]
        public DateTime? InflightStopNewStartsDate { get; set; }

        [XmlIgnore]
        public string InflightNewStartsSuspendedReason { get; set; }


        public bool HasDeliveryOrganisation()
        {
            return !string.IsNullOrEmpty(DeliveryOrganisation);
        }

        public bool HasModificationDetails => NewStartsSuspendedReason.HasValue() || StopNewStartsDate.HasValue;
    }
}
