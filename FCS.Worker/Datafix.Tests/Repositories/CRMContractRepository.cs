using Microsoft.Xrm.Sdk;
using SFA.FCS.Worker.Common.Crm;
using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
using SFA.FCT.CrossDomain.Integration.Entities;
using System;
using SFA.FCT.ContractCreateDomain.Implementation.Extensions;

using System.Collections.Generic;
using System.Linq; 

namespace Datafix.Tests.Repositories
{
    public static class CRMContractRepository
    {
        public static contractType GetContractForId(Guid contractId)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (XrmServiceContext xrmContext = new XrmServiceContext(organizationService))
            {
                var contractsList = from m in xrmContext.sfa_contractSet
                                    join f in xrmContext.sfa_fundingtypeSet on m.sfa_FundingType.Id equals f.sfa_fundingtypeId
                                    join o in xrmContext.AccountSet on m.sfa_ProviderName.Id equals o.AccountId
                                    join c in xrmContext.sfa_contractSet on m.sfa_contractId equals c.sfa_ParentContractId.Id
                                    where c.sfa_contractId == contractId
                                    select new contractType
                                    {
                                        Id = m.Id,
                                        contractNumber = m.sfa_number,
                                        status = GetContractStatusName(m),
                                        subStatus = m.sfa_SubStatus != null ? m.sfa_SubStatus.Name : null,
                                        contractType1 = m.sfa_ContractType != null ? m.sfa_ContractType.Name : null,
                                        description = m.sfa_Description,
                                        contractVersionNumber = m.sfa_Version.GetValueOrDefault(),
                                        contractSubVersionNumber = m.sfa_SubVersion.GetValueOrDefault(),
                                        startDate = m.sfa_StartDate.GetValueOrDefault().ToUniversalTime(),
                                        endDate = m.sfa_EndDate.GetValueOrDefault().ToUniversalTime(),
                                        contractor = GetContractor(m, o),
                                        hierarchyType = hierarchyType.MASTERCONTRACT,
                                        fundingTypeCode = f.sfa_fundingtypecode,
                                        contracts = new List<contractType> { GetChildContractForId(contractId, xrmContext, m) }
                                    };

                return contractsList.SingleOrDefault();
            }
        }
        private static contractType GetChildContractForId(
       Guid contractId,
       XrmServiceContext xrmContext,
       sfa_contract m)
        {
            return (from c in xrmContext.sfa_contractSet
                    join f in xrmContext.sfa_fundingtypeSet on c.sfa_FundingType.Id equals f.sfa_fundingtypeId
                    join o in xrmContext.AccountSet on c.sfa_ProviderName.Id equals o.AccountId
                    where c.sfa_contractId == contractId
                    select new contractType
                    {
                        Id = c.Id,
                        Owner = GetOwner(c),
                        ContractAdvisorId = (c.sfa_ContractAdviser != null) ? c.sfa_ContractAdviser.Id : Guid.Empty,
                        PreviousVersionId = (c.sfa_PreviousVersion != null) ? c.sfa_PreviousVersion.Id : Guid.Empty,
                        ParentContractId = c.sfa_ParentContractId.Id,
                        contractNumber = c.sfa_number,
                        description = c.sfa_Description,
                        period = GetPeriod(xrmContext, c.sfa_PeriodId),
                        contractVersionNumber = c.sfa_Version.GetValueOrDefault(),
                        contractSubVersionNumber = c.sfa_SubVersion.GetValueOrDefault(),
                        startDate = c.sfa_StartDate.GetValueOrDefault().ToUniversalTime(),
                        endDate = c.sfa_EndDate.GetValueOrDefault().ToUniversalTime(),
                        contractType1 = (c.sfa_ContractType != null) ? c.sfa_ContractType.Name : string.Empty,
                        contractor = GetContractor(m, o),
                        hierarchyType = hierarchyType.CONTRACT,
                        status = GetContractStatusName(c),
                        subStatus = c.sfa_SubStatus != null ? c.sfa_SubStatus.Name : null,
                        fundingTypeCode = f.sfa_fundingtypecode,
                        amendmentType = GetAmendmentType(c),
                        contractAllocations = GetContractAllocationsForContract(xrmContext, c.Id),
                        SkipDocumentMerge = c.sfa_skipdocumentmerge,
                        SkipCaseloadAssignment = c.sfa_skipcaseloadassignment,
                        SkipReviewAndInternalApproval = c.sfa_skipreviewandinternalapproval,
                        TerminationDate = c.sfa_terminationdate,
                        InflightTerminationDate = c.sfa_inflightterminationdate,
                        TerminationReason = c.sfa_terminationreason != null ? c.sfa_terminationreasonEnum.ToString() : null,
                        StopNewStartsDate = c.sfa_defaultstopnewstartsdate,
                        NewStartsSuspendedReason = c.sfa_defaultnewstartssuspendedreason.GetNewStartSuspendedReasonText(),
                        InflightStopNewStartsDate = c.sfa_inflightstopnewstartsdate,
                        InflightNewStartsSuspendedReason = c.sfa_inflightnewstartssuspendedreason.GetNewStartSuspendedReasonText(),
                        InflightTerminationReason = c.sfa_inflightterminationreason.GetText<sfa_TerminationReasons>()
                    }).SingleOrDefault();
        }

        private static List<contractAllocation> GetContractAllocationsForContract(XrmServiceContext xrmContext, Guid contractId)
        {
            return (from a in xrmContext.sfa_contractallocationSet
                    join f in xrmContext.sfa_fundingstreamSet on a.sfa_FundingStreamId.Id equals f.sfa_fundingstreamId
                    join fsp in xrmContext.sfa_fundingstreamperiodSet on a.sfa_FundingStreamPeriodId.Id equals fsp.sfa_fundingstreamperiodId
                    join c in xrmContext.sfa_contractSet on a.sfa_ContractId.Id equals c.sfa_contractId
                    where c.sfa_contractId == contractId
                    orderby a.sfa_contractallocationnumber
                    select new contractAllocation
                    {
                        amendmentReason = a.sfa_AmendmentReason,
                        period = a.sfa_PeriodId == null ? GetPeriod(xrmContext, c.sfa_PeriodId) : GetPeriod(xrmContext, a.sfa_PeriodId),
                        fundingStreamCode = f.sfa_fundingstreamcode,
                        fundingStreamPeriodCode = fsp.sfa_fundingstreamperiodcode,
                        contractAllocationNumber = a.sfa_contractallocationnumber,
                        description = a.sfa_description,
                        hierarchyType = contractAllocationHierarchyType.CONTRACTALLOCATION,
                        startDate = a.sfa_startdate.GetValueOrDefault().ToUniversalTime(),
                        endDate = a.sfa_enddate.GetValueOrDefault().ToUniversalTime(),
                        maximumContractValue = a.sfa_maximumcontractvalue.GetValueOrDefault(),
                        contractDeliverables = GetContractDeliverablesForAllocation(xrmContext, a.Id),
                        UoPCode = a.sfa_UoPcode,
                        DeliveryOrganisation = a.sfa_deliveryorganisationukprn,
                        DeliveryOrganisationDetail = GetContractorIfPresent(xrmContext, a.sfa_deliveryorganisationprovider),
                        activityDescription = a.sfa_ProjectDescription,
                        agreementNumber = a.sfa_AgreementNumber,
                        investmentPriority = a.sfa_Priority,
                        learningRatePremium = a.sfa_LearningRatePremium,
                        LEPCode = a.sfa_LEPcode,
                        LEPName = a.sfa_LEPName,
                        lotReference = a.sfa_lotreference,
                        regionType = a.sfa_RegionType,
                        specificationTitle = a.sfa_SpecificationTitle,
                        tenderAwardReference = a.sfa_awardreference,
                        tenderSpecificationReference = a.sfa_ITTReference,
                        TerminationDate = a.sfa_terminationdate,
                        InflightTerminationDate = a.sfa_inflightterminationdate,
                        StopNewStartsDate = a.sfa_stopnewstartsdate,
                        InflightNewStartsSuspendedReason = a.sfa_inflightnewstartssuspendedreason.GetNewStartSuspendedReasonText(),
                        InflightStopNewStartsDate = a.sfa_inflightstopnewstartsdate,
                        NewStartsSuspendedReason = a.sfa_newstartssuspendedreason.GetNewStartSuspendedReasonText()
                    }).ToList();
        }

        private static List<contractDeliverable> GetContractDeliverablesForAllocation(
         XrmServiceContext xrmContext,
         Guid allocationId)
        {
            return (from d in xrmContext.sfa_contractdeliverableSet
                    join a in xrmContext.sfa_contractallocationSet on d.sfa_ContractAllocationId.Id equals a.sfa_contractallocationId
                    join f in xrmContext.sfa_fundingstreamSet on a.sfa_FundingStreamId.Id equals f.sfa_fundingstreamId
                    where d.sfa_ContractAllocationId.Id == allocationId
                    orderby d.sfa_DisplayOrder
                    select new contractDeliverable
                    {
                        unitCost = d.sfa_UnitCost.GetValueOrDefault(),
                        deliverableDescription = d.sfa_DeliverableDescription,
                        deliverable = GetDeliverable(d, f),
                        plannedValue = d.sfa_PlannedValue.GetValueOrDefault(),
                        plannedVolume = d.sfa_PlannedVolume.GetValueOrDefault(),
                        contractDeliverablePeriods = GetDeliverablePeriodsForDeliverable(xrmContext, d.Id)
                    }).ToList();
        }

        private static List<contractDeliverablePeriodType> GetDeliverablePeriodsForDeliverable(XrmServiceContext xrmContext, Guid deliverableId)
        {
            return (from p in xrmContext.sfa_contractdeliverableperiodSet
                    join pt in xrmContext.sfa_periodtypeSet on p.sfa_PeriodTypeId.Id equals pt.sfa_periodtypeId
                    where p.sfa_ContractDeliverableId.Id == deliverableId
                    orderby p.sfa_DisplayOrder
                    select new contractDeliverablePeriodType
                    {
                        year = p.sfa_Year.GetValueOrDefault(),
                        periodType = new periodTypeType
                        {
                            periodTypeCode = pt.sfa_periodtypecode,
                            periodTypeName = pt.sfa_PeriodTypeName
                        },
                        period = p.sfa_Period.GetValueOrDefault(),
                        unitCost = p.sfa_UnitCost.GetValueOrDefault(),
                        plannedValue = p.sfa_PlannedValue.GetValueOrDefault(),
                        plannedVolume = p.sfa_PlannedVolume.GetValueOrDefault(),
                        aggregate = p.sfa_aggregate.GetValueOrDefault()
                    }).ToList();
        }


        private static deliverableType GetDeliverable(sfa_contractdeliverable d, sfa_fundingstream f)
        {
            return new deliverableType
            {
                deliverableCode = int.Parse(d.sfa_DeliverableCode),
                deliverableName = d.sfa_deliverablename,
                fundingStreamCode = f.sfa_fundingstreamcode
            };
        }

    
        private static Contractor GetContractorIfPresent(XrmServiceContext xrmContext, EntityReference accountEntityReference)
        {
            Contractor contractor = null;
            if (accountEntityReference != null)
            {
                var account = xrmContext.AccountSet.SingleOrDefault(a => a.Id == accountEntityReference.Id);

                if (account != null)
                {
                    contractor = new Contractor
                    {
                        legalName = account.Name,
                        ukprn = int.Parse(account.sfa_UKPRN),
                        Upin = account.sfa_orgupin
                    };
                }
            }

            return contractor ?? new Contractor();
        }
        private static string GetContractStatusName(sfa_contract contract)
        {
            return Enum.GetName(typeof(sfa_contractstatus), contract.sfa_ContractStatus.Value);
        }
        private static Contractor GetContractor(sfa_contract contract, Account organisation)
        {
            return new Contractor
            {
                ukprn = int.Parse(contract.sfa_UKPRN),
                legalName = contract.sfa_ProviderName.Name,
                Upin = organisation.sfa_orgupin,
                registeredCompanyNumber = organisation.sfa_companynumber,
                CharityNumber = organisation.sfa_charitynumber,
                addressLine1 = organisation.Address1_Line1,
                addressLine2 = organisation.Address1_Line2,
                addressLine3 = organisation.Address1_Line3,
                addressLine4 = organisation.Address1_Line4,
                town = organisation.Address1_Town,
                county = organisation.Address1_County,
                postcode = organisation.Address1_PostCode
            };
        }
        private static amendmentType GetAmendmentType(sfa_contract contract)
        {
            amendmentType at = amendmentType.None;

            switch (contract.sfa_AmendmentTypeEnum)
            {
                case sfa_amendmenttype.Notification:
                    at = amendmentType.Notification;
                    break;

                case sfa_amendmenttype.Variation:
                    at = amendmentType.Variation;
                    break;
            }

            return at;
        }
        private static periodType GetPeriod(XrmServiceContext xrmContext, EntityReference periodId)
        {
            var period = new periodType();
            if (periodId != null)
            {
                period = (
                    from p in xrmContext.sfa_periodSet
                    join pt in xrmContext.sfa_periodtypeSet on
                        p.sfa_PeriodTypeId.Id equals pt.sfa_periodtypeId
                    where p.sfa_periodId.Equals(periodId.Id)
                    select new periodType
                    {
                        period = p.sfa_Period,
                        periodType1 = new periodTypeType
                        {
                            periodTypeCode = pt.sfa_periodtypecode,
                            periodTypeName = pt.sfa_PeriodTypeName
                        }
                    }).FirstOrDefault();
            }

            return period;
        }
        private static CrmEntityOwner GetOwner(sfa_contract contract)
        {
            var owner = new CrmEntityOwner();
            if (contract.OwnerId != null)
            {
                owner.OwnerId = contract.OwnerId.Id;
                if (contract.OwnerId.LogicalName == "team")
                {
                    owner.OwnerType = OwnerType.Team;
                }
                else
                {
                    owner.OwnerType = OwnerType.SystemUser;
                }
            }

            return owner;
        }
    }
}
