namespace SFA.FCT.CrossDomain.Integration.Entities.CorporateContract
{
    using System.Xml.Serialization;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Extensions;

    public partial class contractType
    {
        private List<ApprovedContractInfo> _sharedMasterApprovedContracts = new List<ApprovedContractInfo>();
        private readonly string avoidFSPNameUnderEDSKToGenerateOnlySOFANDFA = "SBPS";

        [XmlElement(Order = 90)]
        public DateTime? ContractApprovalDate { get; set; }

        [XmlElement(Order = 91)]
        public DateTime? StatusLastUpdatedDate { get; set; }

        [XmlElement(Order = 92)]
        public DateTime? LastModifiedDate { get; set; }

        [XmlElement(Order = 93)]
        public bool? DocumentationRequired { get; set; }

        [XmlElement(Order = 94)]
        public bool? SkipCaseloadAssignment { get; set; }

        [XmlElement(Order = 95)]
        public bool? SkipReviewAndInternalApproval { get; set; }

        [XmlElement(Order = 96)]
        public bool SkipDocumentMerge { get; set; }

        [XmlIgnore]
        public bool? IsNonFinancialAmendment { get; set; }

        [XmlIgnore]
        public DateTime? TerminationDate { get; set; }

        [XmlIgnore]
        public DateTime? InflightTerminationDate { get; set; }

        [XmlIgnore]
        public string TerminationReason { get; set; }

        [XmlIgnore]
        public string InflightTerminationReason { get; set; }

        [XmlIgnore]
        public bool IsNewRevisedNewOrUpdateDraft { get; set; }

        [XmlIgnore]
        public bool IsAmendment { get; set; }

        [XmlIgnore]
        public bool IsNewAmendment { get; set; }

        [XmlIgnore]
        public List<ApprovedContractInfo> SharedMasterApprovedContracts
        {
            get => _sharedMasterApprovedContracts;
            set => _sharedMasterApprovedContracts = value;
        }

        [XmlIgnore]
        public DateTime? LatestCreatedDateForNonNotificationApprovedContract { get; set; }

        [XmlIgnore]
        public bool IsVariation { get; set; }

        [XmlIgnore]
        public bool ShouldMergeAmendmentTemplate { get; set; }

        [XmlIgnore]
        public string OverrideAmendmentTemplate { get; set; }

        [XmlIgnore]
        public string OverrideTemplateName { get; set; }

        [XmlIgnore] public bool IsNotification => !IsVariation;

        [XmlIgnore]
        public DateTime? StopNewStartsDate { get; set; }

        [XmlIgnore]
        public DateTime? InflightStopNewStartsDate { get; set; }

        [XmlIgnore]
        public string NewStartsSuspendedReason { get; set; }

        [XmlIgnore]
        public string InflightNewStartsSuspendedReason { get; set; }

        [XmlIgnore]
        public CrmEntityOwner Owner { get; set; }

        [XmlIgnore]
        public Guid? PreviousVersionId { get; set; }

        [XmlIgnore]
        public Guid? ContractAdvisorId { get; set; }

        [XmlIgnore]
        public Guid? ParentContractId { get; set; }

        [XmlIgnore]
        public Guid? CrmContractId { get; set; }

        [XmlIgnore]
        public bool IsLastApprovedUnderTermination { get; set; }

        [XmlIgnore]
        public DateTime? LastApprovedTerminationDate { get; set; }

        [XmlIgnore] public bool IsModified => contractAllocations?.Any(a => a.IsModified) ?? false;

        public string GetFundingPeriod()
        {
            if (period != null)
            {
                return $"{period.periodType.periodTypeCode}{period.period1}";
            }
            else
            {
                throw new InvalidOperationException("The period is null");
            }
        }

        public bool IsPeriod(string periodNumber)
        {
            return period.period1 == periodNumber;
        }

        public IReadOnlyCollection<string> GetFspCodes()
        {
            return contractAllocations.Select(ca => ca.fundingStreamPeriodCode).Distinct().ToList();
        }

        public IReadOnlyCollection<string> GetFspCodesForAllocationsThatHaveChanged()
        {
            return contractAllocations
                .Where(ca => ca.HasBeenAddedOrUpdated)
                .Select(ca => ca.fundingStreamPeriodCode)
                .Distinct()
                .ToList();
        }

        public IReadOnlyCollection<string> GetFspCodesForAllAllocations()
        {
            return contractAllocations.Where(x => x.fundingStream.fundingStreamCode != avoidFSPNameUnderEDSKToGenerateOnlySOFANDFA)
                .Select(ca => ca.fundingStreamPeriodCode)
                .Distinct()
                .ToList();
        }

        public Contractor GetOrganisation(string contractAllocationNumber)
        {
            contractAllocationsContractAllocation alloc = contractAllocations.Single(ca => ca.contractAllocationNumber == contractAllocationNumber);

            if (alloc.HasDeliveryOrganisation())
            {
                return alloc.DeliveryOrganisationDetail;
            }

            return contractor;
        }

        public int GetNumberPartOfNumber()
        {
            return int.Parse(contractNumber.Split('-')[1]);
        }

        public bool IsRoundOneEsf()
        {
            const int round1LargestNumber = 4999;

            return fundingType.fundingTypeCode == "ESF" && GetNumberPartOfNumber() <= round1LargestNumber;
        }

        public void RemoveTimeComponentsFromDate()
        {
            this.startDate = this.startDate.GetValueOrDefault().Date;
            if (this.endDate.HasValue)
            {
                this.endDate = endDate.Value.Date;
            }

            this.contractAllocations.ForEach(ca =>
            {
                ca.startDate = ca.startDate.Date;
                if (ca.endDate.HasValue)
                {
                    ca.endDate = ca.endDate.Value.Date;
                }
            });
        }

        public void FlattenDeliverablesOnAllocations()
        {
            this.contractAllocations.ForEach(a =>
            {
                var linearDeliverables = a.GetAllDeliverables().ToList();
                linearDeliverables.ForEach(d => d.contractDeliverables.Clear());
                a.contractDeliverables = linearDeliverables;
            });
        }

        public void AlignDeliveryOrgs()
        {
            bool someAllocationsAreNotForTheContractingOrg =
                contractAllocations.Any(a => a.DeliveryOrganisation.HasValue() && a.DeliveryOrganisation != contractor.ukprn.ToString());

            if (someAllocationsAreNotForTheContractingOrg)
            {
                // all allocations should have a delivery org
                contractAllocations
                    .Where(a => !a.DeliveryOrganisation.HasValue())
                    .ToList()
                    .ForEach(a => a.DeliveryOrganisation = contractor.ukprn.ToString());
            }
            else
            {
                // no allocations should have a delivery org
                contractAllocations
                    .ToList()
                    .ForEach(a => a.DeliveryOrganisation = null);
            }
        }

        public void MergeAllocationsOnToContract(IEnumerable<ExtendedContractAllocation> allocations, ContractIntent contractIntent)
        {
            allocations.ToList().ForEach(allocationToMerge =>
            {
                var matchedExistingAllocation = this.contractAllocations.FirstOrDefault(existingAllocation =>
                    existingAllocation.contractAllocationNumber == allocationToMerge.contractAllocationNumber);
                if (matchedExistingAllocation == null)
                {
                    this.contractAllocations.Add(allocationToMerge);
                }
                else
                {
                    if (contractIntent == ContractIntent.UpdateDraft)
                    {
                        var areAnyDeliverablesAlreadyOnAllocation = allocationToMerge.contractDeliverables
                            .Any(codeToMerge => matchedExistingAllocation.contractDeliverables
                                .Select(d => d.deliverable.deliverableCode).Contains(codeToMerge.deliverable.deliverableCode));

                        areAnyDeliverablesAlreadyOnAllocation.ShouldBeFalse($"Deliverables: {string.Join(", ", allocationToMerge.contractDeliverables)} should not already be on allocation: {matchedExistingAllocation}");

                        matchedExistingAllocation.contractDeliverables.AddRange(allocationToMerge.contractDeliverables);
                    }
                    else
                    {
                        matchedExistingAllocation.contractDeliverables.ForEach(existingDeliverable =>
                        {
                            var deliverableToMerge = allocationToMerge.contractDeliverables.SingleOrDefault(d =>
                                d.deliverable.deliverableCode == existingDeliverable.deliverable.deliverableCode);

                            deliverableToMerge?.contractDeliverablePeriods.ForEach(periodToMerge =>
                            {
                                var matchedExistingPeriod = existingDeliverable.contractDeliverablePeriods.SingleOrDefault(existingPeriod =>
                                    existingPeriod.year == periodToMerge.year &&
                                    existingPeriod.period == periodToMerge.period);

                                if (matchedExistingPeriod != null)
                                {
                                    matchedExistingPeriod.plannedValue = periodToMerge.plannedValue;
                                }
                            });
                        });

                        // now add new deliverables
                        var newDeliverableNotOnExisting = allocationToMerge.contractDeliverables.Where(deliverableToMerge => matchedExistingAllocation
                            .contractDeliverables.Select(d => d.deliverable.deliverableCode)
                            .None(deliverableToMerge.deliverable.deliverableCode));

                        matchedExistingAllocation.contractDeliverables.AddRange(newDeliverableNotOnExisting);
                    }
                }
            });
        }
    }
}
