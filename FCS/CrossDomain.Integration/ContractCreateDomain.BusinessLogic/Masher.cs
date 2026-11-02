namespace SFA.FCT.ContractCreateDomain.BusinessLogic
{
    using System.Linq;
    using CrossDomain.Integration.Entities.ContractRequest;

    public class Masher : IMasher
    {
        public contractType Mash(contractType crmContract, contractType importContract)
        {
            if (crmContract != null)
            {
                crmContract.contractor = importContract.contractor;
                crmContract.endDate = importContract.endDate;
                crmContract.startDate = importContract.startDate;

                foreach (var importChildContract in importContract.contracts)
                {
                    if (importChildContract.CRMIntent == intent.New)
                    {
                        crmContract.contracts.Add(importChildContract);
                    }
                    else
                    {
                        var currentCrmContract = crmContract.contracts.SingleOrDefault(
                            c => c.contractNumber == importChildContract.contractNumber);

                        switch (importChildContract.CRMIntent)
                        {
                            case intent.DeleteDraft:

                                if (currentCrmContract == null)
                                {
                                    // Persist non-existent record for further validation.
                                    importChildContract.crmNotPresent = true;

                                    // Use the import version instead.
                                    crmContract.contracts.Add(importChildContract);
                                }
                                else
                                {
                                    crmContract.contracts.Remove(currentCrmContract);
                                }

                                break;
                            case intent.UpdateDraft:
                            case intent.Amendment:
                            case intent.UpdateDraftAmendment:

                                if (currentCrmContract == null)
                                {
                                    // Persist non-existent record for further validation.
                                    importChildContract.crmNotPresent = true;

                                    // Use the import version instead.
                                    crmContract.contracts.Add(importChildContract);
                                }
                                else
                                {
                                    currentCrmContract.IsWithdrawnContractWithContractNumberPresentInCrm =
                                        importChildContract.IsWithdrawnContractWithContractNumberPresentInCrm;

                                    MashChildContract(currentCrmContract, importChildContract);
                                }

                                break;
                        }
                    }
                }
            }
            else
            {
                crmContract = importContract;
                MasterContractNotPresent(crmContract);
            }

            // removed because duplicate correlation id's added to a dictionary as key - PopulateEmptyCorrelationIds(crmContract);
            return crmContract;
        }

        private static void MashChildContract(contractType crmContract, contractType importContract)
        {
            crmContract.correlationId = importContract.correlationId;
            crmContract.description = importContract.description;
            crmContract.contractor = importContract.contractor;
            crmContract.endDate = importContract.endDate;
            crmContract.startDate = importContract.startDate;
            crmContract.CRMIntent = importContract.CRMIntent;
            crmContract.period = importContract.period;
            crmContract.contractType1 = importContract.contractType1;
            crmContract.amendmentType = importContract.amendmentType;
            crmContract.ApprovedAllocationValues = importContract.ApprovedAllocationValues;

            foreach (var importAllocation in importContract.contractAllocations)
            {
                if (importAllocation.CRMIntent == intent.New)
                {
                    crmContract.contractAllocations.Add(importAllocation);
                }
                else
                {
                    var currentCrmAllocation = crmContract.contractAllocations.SingleOrDefault(
                        c => c.contractAllocationNumber == importAllocation.contractAllocationNumber);

                    switch (importAllocation.CRMIntent)
                    {
                        case intent.DeleteDraft:
                        case intent.DeleteDraftAmendment:
                            if (currentCrmAllocation == null)
                            {
                                // Persist non-existent record for further validation.
                                importAllocation.crmNotPresent = true;

                                // Use the import version instead.
                                crmContract.contractAllocations.Add(importAllocation);
                            }
                            else
                            {
                                crmContract.contractAllocations.Remove(currentCrmAllocation);
                            }

                            break;

                        case intent.UpdateDraft:
                        case intent.Amendment:
                        case intent.UpdateDraftAmendment:
                            if (currentCrmAllocation == null)
                            {
                                // Persist non-existent record for further validation.
                                importAllocation.crmNotPresent = true;

                                // Use the import version instead.
                                crmContract.contractAllocations.Add(importAllocation);
                            }
                            else
                            {
                                MashAllocation(currentCrmAllocation, importAllocation);
                            }

                            break;
                    }
                }
            }
        }

        private static void MashAllocation(contractAllocation crmAllocation, contractAllocation importAllocation)
        {
            crmAllocation.correlationId = importAllocation.correlationId;
            crmAllocation.tenderSpecificationReference = importAllocation.tenderSpecificationReference;
            crmAllocation.tenderAwardReference = importAllocation.tenderAwardReference;
            crmAllocation.LEPCode = importAllocation.LEPCode;
            crmAllocation.LEPName = importAllocation.LEPName;
            crmAllocation.UoPCode = importAllocation.UoPCode;
            crmAllocation.fundingStreamCode = importAllocation.fundingStreamCode;
            crmAllocation.investmentPriority = importAllocation.investmentPriority;
            crmAllocation.endDate = importAllocation.endDate;
            crmAllocation.startDate = importAllocation.startDate;
            crmAllocation.description = importAllocation.description;
            crmAllocation.CRMIntent = importAllocation.CRMIntent;
            crmAllocation.period = importAllocation.period;
            crmAllocation.amendmentReason = importAllocation.amendmentReason;
            crmAllocation.activityDescription = importAllocation.activityDescription;
            crmAllocation.agreementNumber = importAllocation.agreementNumber;
            crmAllocation.specificationTitle = importAllocation.specificationTitle;
            crmAllocation.regionType = importAllocation.regionType;
            crmAllocation.learningRatePremium = importAllocation.learningRatePremium;
            crmAllocation.lotReference = importAllocation.lotReference;
            crmAllocation.DeliveryOrganisation = importAllocation.DeliveryOrganisation;
            crmAllocation.DeliveryOrganisationDetail = importAllocation.DeliveryOrganisationDetail;
            crmAllocation.HasBeenAdded = importAllocation.HasBeenAdded;
            crmAllocation.HasBeenUpdated = importAllocation.HasBeenUpdated;

            foreach (var importDeliverable in importAllocation.contractDeliverables)
            {
                if (importDeliverable.CRMIntent == intent.New)
                {
                    crmAllocation.contractDeliverables.Add(importDeliverable);
                }
                else
                {
                    var currentCrmDeliverable = crmAllocation.contractDeliverables.SingleOrDefault(
                        c => c.deliverable.deliverableCode == importDeliverable.deliverable.deliverableCode
                             && c.deliverable.fundingStreamCode == importDeliverable.deliverable.fundingStreamCode);

                    switch (importDeliverable.CRMIntent)
                    {
                        case intent.DeleteDraft:
                        case intent.DeleteDraftAmendment:
                            if (currentCrmDeliverable == null)
                            {
                                // Persist non-existent record for further validation.
                                importDeliverable.crmNotPresent = true;

                                // Use the import version instead.
                                crmAllocation.contractDeliverables.Add(importDeliverable);
                            }
                            else
                            {
                                crmAllocation.contractDeliverables.Remove(currentCrmDeliverable);
                            }

                            break;
                        case intent.UpdateDraft:
                        case intent.Amendment:
                        case intent.UpdateDraftAmendment:
                            if (currentCrmDeliverable == null)
                            {
                                // Persist non-existent record for further validation.
                                importDeliverable.crmNotPresent = true;

                                // Use the import version instead.
                                crmAllocation.contractDeliverables.Add(importDeliverable);
                            }
                            else
                            {
                                MashDeliverable(currentCrmDeliverable, importDeliverable);
                            }

                            break;
                    }
                }
            }
        }

        private static void MashDeliverable(contractDeliverable crmDeliverable, contractDeliverable importDeliverable)
        {
            crmDeliverable.correlationId = importDeliverable.correlationId;
            crmDeliverable.deliverableDescription = importDeliverable.deliverableDescription;
            crmDeliverable.CRMIntent = importDeliverable.CRMIntent;
            crmDeliverable.unitCost = importDeliverable.unitCost;

            foreach (var importPeriod in importDeliverable.contractDeliverablePeriods)
            {
                var currentCrmPeriod = crmDeliverable.contractDeliverablePeriods.SingleOrDefault(
                    c => c.period == importPeriod.period && c.year == importPeriod.year);

                if (currentCrmPeriod == null)
                {
                    crmDeliverable.contractDeliverablePeriods.Add(importPeriod);
                }
                else
                {
                    MashPeriod(currentCrmPeriod, importPeriod);
                }
            }
        }

        private static void MashPeriod(contractDeliverablePeriodType currentCrmPeriod, contractDeliverablePeriodType importPeriod)
        {
            currentCrmPeriod.correlationId = importPeriod.correlationId;
            currentCrmPeriod.periodType = importPeriod.periodType;
            currentCrmPeriod.plannedValue = importPeriod.plannedValue;
            currentCrmPeriod.plannedVolume = importPeriod.plannedVolume;
            currentCrmPeriod.unitCost = importPeriod.unitCost;
            currentCrmPeriod.aggregate = importPeriod.aggregate;
        }

        private static void MasterContractNotPresent(contractType masterContract)
        {
            masterContract.crmNotPresent = true;
            masterContract.contracts.ForEach(c =>
            {
                c.crmNotPresent = true;
                c.contractAllocations.ForEach(ca =>
                {
                    ca.crmNotPresent = true;
                    ca.contractDeliverables.ForEach(d =>
                    {
                        d.crmNotPresent = true;
                    });
                });
            });
        }
    }
}