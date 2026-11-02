namespace SFA.FCT.CrossDomain.Integration.Entities.CorporateContract
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics.CodeAnalysis;
    using System.Linq;
    using System.Xml.Serialization;
    using Extensions;

    [SuppressMessage("StyleCop.CSharp.NamingRules", "SA1300:ElementMustBeginWithUpperCaseLetter", Justification = "as per schema")]
    public partial class contractAllocationsContractAllocation
    {
        private contractor _deliveryOrganisationDetail;

        // Recursive method for assembling hierarchy
        public List<contractDeliverablesTypeContractDeliverable> AssembleChildDeliverables(
            List<contractDeliverablesTypeContractDeliverable> flatDeliverableList, int? parentDeliverableCode)
        {
            // if no parent codes on any deliverables then cannot do hierarchy therefore
            // return flat list
            if (flatDeliverableList.Count(x => x.ParentDeliverableCode == null) == flatDeliverableList.Count)
            {
                return flatDeliverableList;
            }

            var hierarchicalDeliverableList = flatDeliverableList.Where(x => x.ParentDeliverableCode == parentDeliverableCode).ToList();
            hierarchicalDeliverableList.ForEach(d
                =>
            {
                d.contractDeliverables = AssembleChildDeliverables(
                    flatDeliverableList,
                    d.deliverable.deliverableCode);
            });
            return hierarchicalDeliverableList;
        }

        public List<contractDeliverablesTypeContractDeliverable> FlattenDeliverables(
            List<contractDeliverablesTypeContractDeliverable> hierarchicalDeliverableList, 
            List<contractDeliverablesTypeContractDeliverable> flattenedList = null,
            int? parentDeliverablId = null)
        {
            flattenedList = flattenedList ?? new List<contractDeliverablesTypeContractDeliverable>();
            
            foreach (var deliverable in hierarchicalDeliverableList)
            {
                deliverable.ParentDeliverableCode = parentDeliverablId;
                flattenedList.Add(deliverable);

                // check null if you must
                flattenedList = FlattenDeliverables(deliverable.contractDeliverables, flattenedList, deliverable.deliverable.deliverableCode);
            }

            return flattenedList;
        }

        public IReadOnlyCollection<contractDeliverablesTypeContractDeliverable> GetAllDeliverables()
        {
            // we want to remove duplicates
            return new HashSet<contractDeliverablesTypeContractDeliverable>(FlattenDeliverables(
                this.contractDeliverables)).ToList();
        }
        public decimal TotalAggregatedPlannedValue()
        {
            return FlattenDeliverables(contractDeliverables).Sum(fd => fd.AggregatedPlannedValue);
        }

        public string GetFundingStreamPeriodCode()
        {
            return fundingStreamPeriodCode ?? fundingStream.fundingStreamCode + period.period1;
        }

        public string GetAllocationPrefix()
        {
            return contractAllocationNumber.Split('-')[0];
        }

        public override string ToString()
        {
            return contractAllocationNumber;
        }

        [XmlElement(Order = 20)]
        public string ActivityDescription { get; set; }

        [XmlElement(Order = 21)]
        public string AgreementNumber { get; set; }

        [XmlElement(Order = 22)]
        public string SpecificationTitle { get; set; }

        [XmlElement(Order = 23)]
        public string RegionType { get; set; }

        [XmlElement(Order = 24)]
        public string LearningRatePremium { get; set; }

        [XmlElement(Order = 25)]
        public string InvestmentPriority { get; set; }

        [XmlElement(Order = 26)]
        public string LEPCode { get; set; }

        [XmlElement(Order = 27)]
        public string LEPName { get; set; }

        [XmlIgnore]
        public string DeliveryOrganisation { get; set; }

        [XmlIgnore]
        public contractor DeliveryOrganisationDetail
        {
            get => _deliveryOrganisationDetail ?? (_deliveryOrganisationDetail = new contractor());
            set => _deliveryOrganisationDetail = value;
        }

        [XmlIgnore]
        public DateTime? FundingCessationDate { get; set; }

        [XmlIgnore]
        public DateTime? StopNewStartsDate { get; set; }

        [XmlIgnore]
        public string NewStartsSuspendedReason { get; set; }

        [XmlIgnore]
        public bool HasBeenAddedOrUpdated { get; set; } = false;

        [XmlIgnore]
        public bool HasBeenAdded { get; set; } = false;

        [XmlIgnore]
        public string OriginalAllocationNumber { get; set; }

        [XmlIgnore]
        public DateTime? InflightStopNewStartsDate { get; set; }

        [XmlIgnore]
        public string InflightNewStartsSuspendedReason { get; set; }

        [XmlIgnore]
        public DateTime? InflightTerminationDate { get; set; }

        public bool IsModified => StopNewStartsDate.HasValue || !string.IsNullOrEmpty(NewStartsSuspendedReason);

        public bool HasDeliveryOrganisation()
        {
            bool hasLegalName = DeliveryOrganisationDetail?.legalName.HasValue() ?? false;

            return DeliveryOrganisation.HasValue() && hasLegalName;
        }

        public int GetDeliverOrgOrDefault(int defaultUkprn)
        {
            return HasDeliveryOrganisation() ? DeliveryOrganisationDetail.ukprn : defaultUkprn;
        }
    }
}
