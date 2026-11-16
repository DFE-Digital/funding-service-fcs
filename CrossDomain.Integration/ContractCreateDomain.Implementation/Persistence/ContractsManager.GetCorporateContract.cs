namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics.CodeAnalysis;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using CrossDomain.Integration.Entities.Xrm.OptionSets;
    using Extensions;
    using Microsoft.Crm.Sdk.Messages;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Query;
    using Contractor = CrossDomain.Integration.Entities.CorporateContract.Contractor;
    using contractType = CrossDomain.Integration.Entities.CorporateContract.contractType;
    using corporateContract = CrossDomain.Integration.Entities.CorporateContract;
    using deliverableType = CrossDomain.Integration.Entities.CorporateContract.deliverableType;
    using hierarchyType = CrossDomain.Integration.Entities.CorporateContract.hierarchyType;

    public partial class ContractsManager
    {
        public corporateContract.Contract GetCorporateContract(string contractNumber, string masterContractNumber)
        {
            return GetCorporateContract(contractNumber, masterContractNumber, true);
        }

        public corporateContract.Contract GetCorporateContract(string contractNumber, string masterContractNumber, bool lastApproved)
        {
            var matchingContract = GetMatchingCorporateContract(contractNumber, masterContractNumber, lastApproved);

            if (matchingContract?.contractNumber != null)
            {
                AdjustCRMDates(matchingContract);

                AddMissingFieldsToContractAllocations(matchingContract);

                return matchingContract;
            }

            return null;
        }

        public corporateContract.Contract GetCorporateContractForSpecificVersion(string contractNumber, string masterContractNumber, int versionNumber)
        {
            var matchingContract = GetMatchingCorporateContractForSpecificVersion(contractNumber, masterContractNumber, versionNumber);

            if (matchingContract?.contractNumber != null)
            {
                AdjustCRMDates(matchingContract);

                AddMissingFieldsToContractAllocations(matchingContract);

                return matchingContract;
            }

            return null;
        }

        public SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.Contract GetCorporateContractForSpecificVersion(string contractNumber, int version, int subVersion)
        {
            var matchingContract = GetMatchingCorporateContractForSpecificVersion(contractNumber, version, subVersion);

            if (matchingContract?.contractNumber != null)
            {
                AdjustCRMDates(matchingContract);

                AddMissingFieldsToContractAllocations(matchingContract);

                return matchingContract;
            }

            return null;
        }

        public IList<corporateContract.ContractSummary> GetApprovedContracts(DateTime earliestDateTime)
        {
            // get list of contracts approved since parameter date
            using (var xrmContext = new XrmServiceContext(OrganizationService))
            {
                // Crm Date must be > 1900
                earliestDateTime = (earliestDateTime == DateTime.MinValue) ? new DateTime(1900, 1, 1) : earliestDateTime;

                var contractsListQuery = from c in xrmContext.sfa_contractSet
                                         where c.sfa_HierarchyType.Value.Equals(sfa_contracthierarchytype.Contract)
                                         /* 22 Dec 2015
                                            'Replaced' condition added as we are now updating contracts other than the last approved version
                                         */
                                         where (c.sfa_ContractStatus.Value.Equals(sfa_contractstatus.Approved) ||
                                                c.sfa_ContractStatus.Value.Equals(sfa_contractstatus.Replaced))

                                         /* 18 Dec 2015
                                            Condition removed based on a conversation with Anita Holcroft -
                                            we no longer want to restrict this to only the last approved version of a contract
                                         where c.sfa_LastApprovedVersion.Value.Equals(true)
                                         */
                                         where c.ModifiedOn.Value >= earliestDateTime
                                         orderby c.ModifiedOn
                                         select new corporateContract.ContractSummary
                                         {
                                             // Id = c.Id,
                                             ContractNumber = c.sfa_number,
                                             ContractVersionNumber = c.sfa_Version,
                                             MasterContractNumber = (c.sfa_ParentContractId != null) ? c.sfa_ParentContractId.Name : string.Empty
                                         };

                var approvedContracts = contractsListQuery.ToList();

                return approvedContracts;
            }
        }

        internal virtual corporateContract.Contract GetMatchingCorporateContract(string contractNumber, string masterContractNumber, bool lastApproved)
        {
            // ReSharper disable AccessToDisposedClosure
            using (var xrmContext = new XrmServiceContext(OrganizationService))
            {
                var contractsList = from m in xrmContext.sfa_contractSet
                                    join o in xrmContext.AccountSet on m.sfa_ProviderName.Id equals o.AccountId
                                    join f in xrmContext.sfa_fundingtypeSet on m.sfa_FundingType.Id equals f.sfa_fundingtypeId
                                    where m.sfa_number == masterContractNumber
                                    orderby m.CreatedOn descending
                                    select new corporateContract.Contract
                                    {
                                        contractNumber = m.sfa_number,
                                        description = m.sfa_Description,
                                        contractVersionNumber = m.sfa_Version.GetValueOrDefault(),
                                        contractType1 = m.sfa_ContractType != null ? m.sfa_ContractType.Name : string.Empty,
                                        fundingType = GetCorporateFundingType(m, f),
                                        contractor = GetCorporateContractor(m, o),
                                        hierarchyType = hierarchyType.MASTERCONTRACT,
                                        contracts = GetCorporateChildContracts(contractNumber, xrmContext, m, lastApproved),
                                        // Removed contractStatus, period and parentContractVersionNumber as per requirement ref:12328
                                        parentContractVersionNumber = null,
                                        period = null,
                                        contractStatus = null,
                                        // Changed for contractValue,startDate,endDate as that can be null with new schema change ref:12328
                                        startDate = GetNullableDateTime(m.sfa_StartDate),
                                        endDate = GetNullableDateTime(m.sfa_EndDate),
                                        contractValue = m.sfa_ContractValue.Value == 0.0M ? (decimal?)null : m.sfa_ContractValue.Value
                                    };
                return contractsList.FirstOrDefault();
            }
            // ReSharper restore AccessToDisposedClosure
        }

        internal virtual corporateContract.Contract GetMatchingCorporateContractForSpecificVersion(string contractNumber, string masterContractNumber, int versionNumber)
        {
            // ReSharper disable AccessToDisposedClosure
            using (var xrmContext = new XrmServiceContext(OrganizationService))
            {
                var contractsList = from m in xrmContext.sfa_contractSet
                                    join o in xrmContext.AccountSet on m.sfa_ProviderName.Id equals o.AccountId
                                    join f in xrmContext.sfa_fundingtypeSet on m.sfa_FundingType.Id equals f.sfa_fundingtypeId
                                    where m.sfa_number == masterContractNumber
                                    orderby m.CreatedOn descending
                                    select new corporateContract.Contract
                                    {
                                        contractNumber = m.sfa_number,
                                        description = m.sfa_Description,
                                        contractVersionNumber = m.sfa_Version.GetValueOrDefault(),
                                        contractType1 = m.sfa_ContractType != null ? m.sfa_ContractType.Name : string.Empty,
                                        fundingType = GetCorporateFundingType(m, f),
                                        contractor = GetCorporateContractor(m, o),
                                        hierarchyType = hierarchyType.MASTERCONTRACT,
                                        contracts = GetCorporateChildContractForSpecificVersion(contractNumber, xrmContext, m, versionNumber),
                                        parentContractVersionNumber = null,
                                        period = null,
                                        contractStatus = null,
                                        startDate = m.sfa_StartDate == null ? (DateTime?)null : m.sfa_StartDate.Value.ToUniversalTime(),
                                        endDate = m.sfa_EndDate == null ? (DateTime?)null : m.sfa_EndDate.Value.ToUniversalTime(),
                                        contractValue = m.sfa_ContractValue.Value == 0.0M ? (decimal?)null : m.sfa_ContractValue.Value
                                    };
                return contractsList.FirstOrDefault();
            }
            // ReSharper restore AccessToDisposedClosure
        }

        private SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.Contract GetMatchingCorporateContractForSpecificVersion(
           string contractNumber,
           int versionNumber,
           int subVersionNumber)
        {
            // ReSharper disable AccessToDisposedClosure
            using (var xrmContext = new XrmServiceContext(OrganizationService))
            {
                var contractsList = from m in xrmContext.sfa_contractSet
                                    join o in xrmContext.AccountSet on m.sfa_ProviderName.Id equals o.AccountId
                                    join f in xrmContext.sfa_fundingtypeSet on m.sfa_FundingType.Id equals f.sfa_fundingtypeId
                                    join c in xrmContext.sfa_contractSet on m.sfa_contractId.Value equals c.sfa_ParentContractId.Id
                                    where c.sfa_number == contractNumber &&
                                          c.sfa_Version == versionNumber &&
                                          c.sfa_SubVersion == subVersionNumber

                                    select new SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.Contract
                                    {
                                        contractNumber = m.sfa_number,
                                        description = m.sfa_Description,
                                        contractVersionNumber = m.sfa_Version.GetValueOrDefault(),
                                        contractType1 = m.sfa_ContractType != null ? m.sfa_ContractType.Name : string.Empty,
                                        fundingType = GetCorporateFundingType(m, f),
                                        contractor = GetCorporateContractor(m, o),
                                        hierarchyType = hierarchyType.MASTERCONTRACT,
                                        contracts = GetCorporateChildContractForSpecificVersion(contractNumber, xrmContext, m, versionNumber, subVersionNumber),
                                        parentContractVersionNumber = null,
                                        period = null,
                                        contractStatus = null,
                                        startDate = m.sfa_StartDate == null ? (DateTime?)null : m.sfa_StartDate.Value.ToUniversalTime(),
                                        endDate = m.sfa_EndDate == null ? (DateTime?)null : m.sfa_EndDate.Value.ToUniversalTime(),
                                        contractValue = m.sfa_ContractValue.Value == 0.0M ? (decimal?)null : m.sfa_ContractValue.Value
                                    };
                return contractsList.FirstOrDefault();
            }
            // ReSharper restore AccessToDisposedClosure
        }

        /// <summary>
        /// Gets a matching child contract(s) from the master contract by contract number, if more than one contract with the same contract number is returned this will not be filtered
        /// </summary>
        /// <param name="contractNumber">The child contract number</param>
        /// <param name="xrmContext">The Early-bound Xrm Service Context</param>
        /// <param name="m">The entity of the master contract</param>
        /// <param name="lastApproved"></param>
        /// <returns>A list of child contracts</returns>
        [SuppressMessage("ReSharper", "MergeConditionalExpression")]
        private static List<contractType> GetCorporateChildContracts(string contractNumber, XrmServiceContext xrmContext, sfa_contract m, bool lastApproved)
        {
            //// I tried reusing the original query and switch the where on the lastApproved flag but CRM didn't seem to like doing this sort of thing:
            //// "where (lastApproved && LastApproved == true) || (!lastApproved && LatestVersion == true)"
            //// or this
            //// "where (!lastApproved || LastApproved == true)
            //// where (lastApproved || LatestVersion == true)"
            //// Instead you get a separate query for Last Approved / Latest Version determined by lastApproved true/false
            if (!lastApproved)
            {
                return (from c in xrmContext.sfa_contractSet
                        join o in xrmContext.AccountSet on c.sfa_ProviderName.Id equals o.AccountId
                        join f in xrmContext.sfa_fundingtypeSet on c.sfa_FundingType.Id equals f.sfa_fundingtypeId
                        where c.sfa_ParentContractId.Id == m.Id
                        where c.sfa_number == contractNumber
                        /* 18 Dec 2015
                           Condition removed based on a conversation with Anita Holcroft -
                           we no longer want to restrict this to only the latest version of a contract
                        where c.sfa_LatestVersion == true
                        */
                        orderby c.sfa_Version descending
                        orderby c.sfa_SubVersion descending
                        select new contractType
                        {
                            fundingType = GetCorporateFundingType(m, f),
                            period = GetCorpContractPeriod(xrmContext, c.sfa_PeriodId),
                            contractAllocations = GetCorporateContractAllocationsForContract(xrmContext, c.Id),
                            contractNumber = c.sfa_number,
                            contractVersionNumber = c.sfa_Version.GetValueOrDefault(),
                            contractSubVersionNumber = c.sfa_SubVersion.GetValueOrDefault(),
                            description = GetNullableString(c.sfa_Description),
                            contractor = GetCorporateContractor(m, o),
                            hierarchyType = hierarchyType.CONTRACT,
                            contractType1 = c.sfa_ContractType != null ? c.sfa_ContractType.Name : string.Empty,
                            startDate = c.sfa_StartDate.GetValueOrDefault().ToUniversalTime(),
                            endDate = GetNullableDateTime(c.sfa_EndDate),
                            contractStatus = GetContractStatusType(c.sfa_ContractStatus, c.sfa_SubStatus.Name),
                            contractValue = c.sfa_ContractValue != null ? c.sfa_ContractValue.Value : 0,
                            parentContractNumber = m.sfa_number,
                            parentContractVersionNumber = m.sfa_Version.GetValueOrDefault(),
                            amendmentType = c.sfa_AmendmentTypeEnum != null ? c.sfa_AmendmentTypeEnum.ToString() : null,
                            ContractApprovalDate = c.sfa_ContractApprovalDate,
                            LastModifiedDate = c.ModifiedOn,
                            StatusLastUpdatedDate = c.sfa_StatusLastUpdatedDate,
                            DocumentationRequired = c.sfa_DocumentationRequired,
                            SkipDocumentMerge = c.sfa_skipdocumentmerge.GetValueOrDefault(),
                            TerminationDate = c.sfa_terminationdate,
                            TerminationReason = c.sfa_terminationreasonEnum.ToString()
                        }).Take(1).ToList();
            }

            return (from c in xrmContext.sfa_contractSet
                    join o in xrmContext.AccountSet on c.sfa_ProviderName.Id equals o.AccountId
                    join f in xrmContext.sfa_fundingtypeSet on c.sfa_FundingType.Id equals f.sfa_fundingtypeId
                    where c.sfa_ParentContractId.Id == m.Id
                    where c.sfa_number == contractNumber
                    where c.sfa_LastApprovedVersion == true
                    orderby c.sfa_Version descending
                    orderby c.sfa_SubVersion descending
                    select new contractType
                    {
                        fundingType = GetCorporateFundingType(m, f),
                        period = GetCorpContractPeriod(xrmContext, c.sfa_PeriodId),
                        contractAllocations = GetCorporateContractAllocationsForContract(xrmContext, c.Id),
                        contractNumber = c.sfa_number,
                        contractVersionNumber = c.sfa_Version.GetValueOrDefault(),
                        contractSubVersionNumber = c.sfa_SubVersion.GetValueOrDefault(),
                        description = GetNullableString(c.sfa_Description),
                        contractor = GetCorporateContractor(m, o),
                        hierarchyType = hierarchyType.CONTRACT,
                        contractType1 = c.sfa_ContractType != null ? c.sfa_ContractType.Name : string.Empty,
                        startDate = c.sfa_StartDate.GetValueOrDefault().ToUniversalTime(),
                        endDate = GetNullableDateTime(c.sfa_EndDate),
                        contractStatus = GetContractStatusType(c.sfa_ContractStatus, c.sfa_SubStatus.Name),
                        contractValue = c.sfa_ContractValue != null ? c.sfa_ContractValue.Value : 0,
                        parentContractNumber = m.sfa_number,
                        parentContractVersionNumber = m.sfa_Version.GetValueOrDefault(),
                        amendmentType = c.sfa_AmendmentTypeEnum != null ? c.sfa_AmendmentTypeEnum.ToString() : null,
                        ContractApprovalDate = c.sfa_ContractApprovalDate,
                        LastModifiedDate = c.ModifiedOn,
                        StatusLastUpdatedDate = c.sfa_StatusLastUpdatedDate,
                        DocumentationRequired = c.sfa_DocumentationRequired,
                        SkipDocumentMerge = c.sfa_skipdocumentmerge.GetValueOrDefault(),
                        TerminationDate = c.sfa_terminationdate,
                        TerminationReason = c.sfa_terminationreasonEnum.ToString()
                    }).Take(1).ToList();
        }

        /// <summary>
        /// Gets a child contract of specific version
        /// </summary>
        /// <param name="contractNumber">The child contract number</param>
        /// <param name="xrmContext">The Early-bound Xrm Service Context</param>
        /// <param name="m">The entity of the master contract</param>
        /// <param name="versionNumber">Version number to return</param>
        /// <returns>A specific child contract version</returns>
        [SuppressMessage("ReSharper", "MergeConditionalExpression")]
        private static List<contractType> GetCorporateChildContractForSpecificVersion(string contractNumber,
            XrmServiceContext xrmContext, sfa_contract m, int versionNumber)
        {
            var contractVersion = (from c in xrmContext.sfa_contractSet
            join o in xrmContext.AccountSet on c.sfa_ProviderName.Id equals o.AccountId
            join f in xrmContext.sfa_fundingtypeSet on c.sfa_FundingType.Id equals f.sfa_fundingtypeId
            where c.sfa_ParentContractId.Id == m.Id
            where c.sfa_number == contractNumber && c.sfa_Version == versionNumber
            orderby c.sfa_Version descending
            orderby c.sfa_SubVersion descending
            select new contractType
            {
                fundingType = GetCorporateFundingType(m, f),
                period = GetCorpContractPeriod(xrmContext, c.sfa_PeriodId),
                contractAllocations = GetCorporateContractAllocationsForContract(xrmContext, c.Id),
                contractNumber = c.sfa_number,
                contractVersionNumber = c.sfa_Version.GetValueOrDefault(),
                contractSubVersionNumber = c.sfa_SubVersion.GetValueOrDefault(),
                description = GetNullableString(c.sfa_Description),
                contractor = GetCorporateContractor(m, o),
                hierarchyType = hierarchyType.CONTRACT,
                contractType1 = c.sfa_ContractType != null ? c.sfa_ContractType.Name : string.Empty,
                startDate = c.sfa_StartDate.GetValueOrDefault().ToUniversalTime(),
                endDate = GetNullableDateTime(c.sfa_EndDate),
                contractStatus = GetContractStatusType(c.sfa_ContractStatus, c.sfa_SubStatus.Name),
                contractValue = c.sfa_ContractValue != null ? c.sfa_ContractValue.Value : 0,
                parentContractNumber = m.sfa_number,
                parentContractVersionNumber = m.sfa_Version.GetValueOrDefault(),
                amendmentType = c.sfa_AmendmentTypeEnum != null ? c.sfa_AmendmentTypeEnum.ToString() : null,
                ContractApprovalDate = c.sfa_ContractApprovalDate,
                LastModifiedDate = c.ModifiedOn,
                StatusLastUpdatedDate = c.sfa_StatusLastUpdatedDate
            }).FirstOrDefault();

            return contractVersion != null ? new List<contractType>() {{contractVersion}} : new List<contractType>();
        }

        [SuppressMessage("ReSharper", "MergeConditionalExpression")]
        private static List<contractType> GetCorporateChildContractForSpecificVersion(
          string contractNumber,
          XrmServiceContext xrmContext,
          sfa_contract masterContract,
          int versionNumber,
          int subVersionNumber)
        {
            var contractVersion = (from c in xrmContext.sfa_contractSet
                                   join o in xrmContext.AccountSet on c.sfa_ProviderName.Id equals o.AccountId
                                   join f in xrmContext.sfa_fundingtypeSet on c.sfa_FundingType.Id equals f.sfa_fundingtypeId
                                   where c.sfa_ParentContractId.Id == masterContract.Id
                                   where c.sfa_number == contractNumber &&
                                         c.sfa_Version == versionNumber &&
                                         c.sfa_SubVersion == subVersionNumber
                                   select new contractType
                                   {
                                       fundingType = GetCorporateFundingType(masterContract, f),
                                       period = GetCorpContractPeriod(xrmContext, c.sfa_PeriodId),
                                       contractAllocations = GetCorporateContractAllocationsForContract(xrmContext, c.Id),
                                       contractNumber = c.sfa_number,
                                       contractVersionNumber = c.sfa_Version.GetValueOrDefault(),
                                       contractSubVersionNumber = c.sfa_SubVersion.GetValueOrDefault(),
                                       description = GetNullableString(c.sfa_Description),
                                       contractor = GetCorporateContractor(masterContract, o),
                                       hierarchyType = hierarchyType.CONTRACT,
                                       contractType1 = c.sfa_ContractType != null ? c.sfa_ContractType.Name : string.Empty,
                                       startDate = c.sfa_StartDate.GetValueOrDefault().ToUniversalTime(),
                                       endDate = GetNullableDateTime(c.sfa_EndDate),
                                       contractStatus = GetContractStatusType(c.sfa_ContractStatus, c.sfa_SubStatus.Name),
                                       contractValue = c.sfa_ContractValue != null ? c.sfa_ContractValue.Value : 0,
                                       parentContractNumber = masterContract.sfa_number,
                                       parentContractVersionNumber = masterContract.sfa_Version.GetValueOrDefault(),
                                       amendmentType = c.sfa_AmendmentTypeEnum != null ? c.sfa_AmendmentTypeEnum.ToString() : null,
                                       ContractApprovalDate = c.sfa_ContractApprovalDate,
                                       LastModifiedDate = c.ModifiedOn,
                                       StatusLastUpdatedDate = c.sfa_StatusLastUpdatedDate,
                                       DocumentationRequired = c.sfa_DocumentationRequired,
                                       SkipDocumentMerge = c.sfa_skipdocumentmerge.GetValueOrDefault(),
                                       TerminationDate = c.sfa_terminationdate,
                                       TerminationReason = c.sfa_terminationreasonEnum.ToString(),
                                       PreviousVersionId = (c.sfa_PreviousVersion != null) ? c.sfa_PreviousVersion.Id : Guid.Empty,
                                       ContractAdvisorId = (c.sfa_ContractAdviser != null) ? c.sfa_ContractAdviser.Id : Guid.Empty,
                                       ParentContractId = c.sfa_ParentContractId.Id,
                                       Owner = GetOwner(c),
                                       CrmContractId = c.sfa_contractId
                                   }).FirstOrDefault();

            return contractVersion != null ? new List<contractType>() { { contractVersion } } : new List<contractType>();
        }

        private static corporateContract.contractStatusType GetContractStatusType(OptionSetValue contractStatusOptionSetValue, string contractSubStatus)
        {
            string contractStatus = Enum.GetName(typeof(sfa_contractstatus), contractStatusOptionSetValue.Value);
            return new corporateContract.contractStatusType
            {
                status = contractSubStatus,

                // the parent is required by the xsd
                parentStatus = contractStatus
            };
        }

        /// <summary>
        /// Gets a list of child allocations for a particular contract, based on the contract Id
        /// </summary>
        /// <param name="xrmContext">The Early-bound Xrm Service Context</param>
        /// <param name="contractId">The Id of the parent contract</param>
        /// <returns>A list of Contract Allocations</returns>
        private static List<corporateContract.contractAllocationsContractAllocation> GetCorporateContractAllocationsForContract(XrmServiceContext xrmContext, Guid contractId)
        {
            return (from a in xrmContext.sfa_contractallocationSet
                    join fs in xrmContext.sfa_fundingstreamSet on a.sfa_FundingStreamId.Id equals fs.sfa_fundingstreamId
                    join fsp in xrmContext.sfa_fundingstreamperiodSet on a.sfa_FundingStreamPeriodId.Id equals fsp.sfa_fundingstreamperiodId
                    join c in xrmContext.sfa_contractSet on a.sfa_ContractId.Id equals c.sfa_contractId
                    where c.sfa_contractId == contractId
                    orderby a.sfa_contractallocationnumber
                    select new corporateContract.contractAllocationsContractAllocation
                    {
                        period = GetCorpContractPeriod(xrmContext, a.sfa_PeriodId),
                        fundingStream = GetCorporateFundingStream(a, fs),
                        //// allocationDimensionRelationships = 
                        allocationOrganisationRelationships = GetAllocationOrganisationRelationships(xrmContext, a),
                        contractDeliverables = GetCorporateContractDeliverablesForAllocation(xrmContext, a.Id, null, null),
                        contractAllocationNumber = a.sfa_contractallocationnumber,
                        description = GetNullableString(a.sfa_description),
                        hierarchyType = corporateContract.contractAllocationsContractAllocationHierarchyType.CONTRACTALLOCATION,
                        fundingStreamPeriodCode = GetNullableString(fsp.sfa_fundingstreamperiodcode),
                        startDate = a.sfa_startdate.GetValueOrDefault().ToUniversalTime(),
                        endDate = GetNullableDateTime(a.sfa_enddate),
                        maximumContractValue = a.sfa_maximumcontractvalue.GetValueOrDefault(),
                        reasonForAmendment = GetNullableString(a.sfa_AmendmentReason),
                        uopCode = GetNullableString(a.sfa_UoPcode),
                        tenderSpecificationReference = GetNullableString(a.sfa_ITTReference),
                        lotReference = GetNullableString(a.sfa_lotreference),
                        tenderAwardReference = GetNullableString(a.sfa_awardreference),
                        LEPCode = GetNullableString(a.sfa_LEPcode),
                        LEPName = GetNullableString(a.sfa_LEPName),
                        ActivityDescription = GetNullableString(a.sfa_ProjectDescription),
                        AgreementNumber = GetNullableString(a.sfa_AgreementNumber),
                        InvestmentPriority = GetNullableString(a.sfa_Priority),
                        SpecificationTitle = GetNullableString(a.sfa_SpecificationTitle),
                        RegionType = GetNullableString(a.sfa_RegionType),
                        LearningRatePremium = GetNullableString(a.sfa_LearningRatePremium),
                        DeliveryOrganisation = a.sfa_deliveryorganisationukprn,
                        DeliveryOrganisationDetail = GetContractorForUkprn(a.sfa_deliveryorganisationukprn, xrmContext),
                        FundingCessationDate = a.sfa_terminationdate,
                        StopNewStartsDate = a.sfa_stopnewstartsdate,
                        NewStartsSuspendedReason = a.sfa_newstartssuspendedreason.GetNewStartSuspendedReasonText()
                    }).ToList();
        }

        private static Contractor GetContractorForUkprn(string ukprn, XrmServiceContext xrmContext)
        {
            Contractor contractor = null;
            if (!string.IsNullOrEmpty(ukprn))
            {
                SimpleOrg simpleOrg = GetSimpleOrg(ukprn, xrmContext);

                if (simpleOrg != null)
                {
                    contractor = new Contractor
                    {
                        organisationIdentifier = simpleOrg.OrgId,
                        ukprn = int.Parse(ukprn),
                        legalName = simpleOrg.Name
                    };
                }
            }

            return contractor;
        }

        private static SimpleOrg GetSimpleOrg(string ukprn, XrmServiceContext xrmContext)
        {
            return xrmContext.AccountSet.Where(a => a.sfa_UKPRN == ukprn)
            .Select(o => new {o.sfa_OrganisationID, o.Name })
            .AsEnumerable()
            .Select(o => new SimpleOrg(o.sfa_OrganisationID, o.Name))
            .FirstOrDefault();  
        }

        private static List<corporateContract.organisationRelationship> GetAllocationOrganisationRelationships(XrmServiceContext xrmContext, sfa_contractallocation contractallocation)
        {
            var orgList = new List<corporateContract.organisationRelationship>();

            // Check and add LEP
            if (!string.IsNullOrWhiteSpace(contractallocation.sfa_LEPcode) && contractallocation.sfa_LEPId != null)
            {
                var org = (from o in xrmContext.AccountSet
                           where o.AccountId.Equals(contractallocation.sfa_LEPId.Id)
                           select o).FirstOrDefault();

                if (org != null)
                {
                    int orgId;
                    if (int.TryParse(org.sfa_OrganisationID, out orgId))
                    {
                        orgList.Add(new corporateContract.organisationRelationship
                        {
                            organisationIdentifier = int.Parse(org.sfa_OrganisationID),
                            organisationRelationshipType = corporateContract.organisationRelationshipType.LEP
                        });
                    }
                }
            }

            if (orgList.Count > 0)
            {
                return orgList;
            }

            return null;
        }

        /// <summary>
        /// Gets a list of contract deliverables for a particular allocation based on allocation Id
        /// </summary>
        /// <param name="xrmContext">The Early-bound Xrm Service Context</param>
        /// <param name="allocationId">The Id of the parent allocation</param>
        /// <param name="parentDeliverable">The the parent deliverable</param>
        /// <param name="fundingstream">The the funding stream</param>
        /// <returns>A list of Contract Deliverables</returns>
        /// <remarks>This method will need to be extended to cater for a heirarchical structure of deliverables, this may require a new method</remarks>
        private static List<corporateContract.contractDeliverablesTypeContractDeliverable> GetCorporateContractDeliverablesForAllocation(
            XrmServiceContext xrmContext,
            Guid allocationId,
            sfa_contractdeliverable parentDeliverable,
            sfa_fundingstream fundingstream)
        {
            IQueryable<corporateContract.contractDeliverablesTypeContractDeliverable> deliverables;
            if (parentDeliverable != null)
            {
                deliverables = from d in xrmContext.sfa_contractdeliverableSet
                               where d.sfa_ParentDeliverableId.Id == parentDeliverable.Id
                               select new corporateContract.contractDeliverablesTypeContractDeliverable
                               {
                                   contractDeliverables = GetCorporateContractDeliverablesForAllocation(xrmContext, allocationId, d, fundingstream),
                                   unitCost = d.sfa_UnitCost.GetValueOrDefault(),
                                   deliverableDescription = d.sfa_DeliverableDescription,
                                   deliverable = GetCorporateDeliverable(d, fundingstream),
                                   plannedValue = d.sfa_PlannedValue.GetValueOrDefault(),
                                   plannedVolume = d.sfa_PlannedVolume.GetValueOrDefault(),
                                   contractDeliverablePeriods = GetCorporateDeliverablePeriodsForDeliverable(xrmContext, d.Id),
                               };
            }
            else
            {
                deliverables = from d in xrmContext.sfa_contractdeliverableSet
                               join a in xrmContext.sfa_contractallocationSet on d.sfa_ContractAllocationId.Id equals a.sfa_contractallocationId
                               join f in xrmContext.sfa_fundingstreamSet on a.sfa_FundingStreamId.Id equals f.sfa_fundingstreamId
                               where d.sfa_ContractAllocationId.Id == allocationId && d.sfa_ParentDeliverableId == null
                               select new corporateContract.contractDeliverablesTypeContractDeliverable
                               {
                                   contractDeliverables = GetCorporateContractDeliverablesForAllocation(xrmContext, allocationId, d, f),
                                   deliverable = GetCorporateDeliverable(d, f),
                                   contractDeliverablePeriods = GetCorporateDeliverablePeriodsForDeliverable(xrmContext, d.Id),
                                   //// deliverableOrganisationRelationships = ??
                                   //// deliverableDimensionRelationships = ??
                                   deliverableDescription = d.sfa_DeliverableDescription,
                                   unitCost = d.sfa_UnitCost.GetValueOrDefault(),
                                   plannedVolume = d.sfa_PlannedVolume.GetValueOrDefault(),
                                   plannedValue = d.sfa_PlannedValue.GetValueOrDefault()
                               };
            }

            return deliverables.ToList();
        }

        private static DateTime? GetNullableDateTime(DateTime? dateTime)
        {
            return dateTime?.ToUniversalTime();
        }

        private static string GetNullableString(string s)
        {
            if (string.IsNullOrWhiteSpace(s))
            {
                return null;
            }

            return s;
        }

        /// <summary>
        /// Gets a list of Contract Deliverable Periods for a particular deliverable based on deliverable Id
        /// </summary>
        /// <param name="xrmContext">The Early-bound Xrm Service Context</param>
        /// <param name="deliverableId">The Id of the parent deliverable</param>
        /// <returns>A list of Contract Deliverable Periods</returns>
        private static List<corporateContract.contractDeliverablePeriodsTypeContractDeliverablePeriod> GetCorporateDeliverablePeriodsForDeliverable(XrmServiceContext xrmContext, Guid deliverableId)
        {
            return (from p in xrmContext.sfa_contractdeliverableperiodSet
                    join pt in xrmContext.sfa_periodtypeSet on p.sfa_PeriodTypeId.Id equals pt.sfa_periodtypeId
                    where p.sfa_ContractDeliverableId.Id == deliverableId
                    orderby p.sfa_DisplayOrder
                    select new corporateContract.contractDeliverablePeriodsTypeContractDeliverablePeriod
                    {
                        year = p.sfa_Year.GetValueOrDefault(),
                        period = p.sfa_Period.GetValueOrDefault(),
                        periodType = TransformCrmPeriodTypeType(pt),
                        unitCost = p.sfa_UnitCost.GetValueOrDefault(),
                        plannedVolume = p.sfa_PlannedVolume.GetValueOrDefault(),
                        plannedValue = p.sfa_PlannedValue.GetValueOrDefault(),
                        aggregate = p.sfa_aggregate.GetValueOrDefault()
                    }).ToList();
        }

        /// <summary>
        /// Helper method to get a Contractor object from a CRM Contract - from the assigned provider
        /// </summary>
        /// <param name="contract">The CRM Contract object</param>
        /// <param name="account"></param>
        /// <returns></returns>
        private static Contractor GetCorporateContractor(sfa_contract contract, Account account)
        {
            int parsedUkprn;
            int.TryParse(contract.sfa_UKPRN, out parsedUkprn);

            return new Contractor
            {
                organisationIdentifier = account.sfa_OrganisationID,
                ukprn = parsedUkprn,
                legalName = contract.sfa_ProviderName.Name
            };
        }

        /// <summary>
        /// Helper method to get a Contractor object from a CRM Contract - from the assigned provider
        /// </summary>
        /// <param name="contract">The CRM Contract object</param>
        /// <param name="fundingtype"></param>
        /// <returns></returns>
        private static corporateContract.fundingType GetCorporateFundingType(sfa_contract contract, CrossDomain.Integration.Entities.Xrm.sfa_fundingtype fundingtype)
        {
            if (contract.sfa_FundingType != null)
            {
                return new corporateContract.fundingType
                {
                    fundingTypeCode = fundingtype.sfa_fundingtypecode,
                    fundingTypeName = fundingtype.sfa_name
                };
            }

            return null;
        }

        /// <summary>
        /// GetCorporateFundingStream
        /// </summary>
        /// <param name="allocation"></param>
        /// <param name="fundingStream"></param>
        /// <returns></returns>
        private static corporateContract.fundingStream GetCorporateFundingStream(sfa_contractallocation allocation, sfa_fundingstream fundingStream)
        {
            if (allocation.sfa_FundingStreamId != null)
            {
                return new corporateContract.fundingStream
                {
                    fundingStreamCode = fundingStream.sfa_fundingstreamcode,
                    fundingStreamName = fundingStream.sfa_fundingstreamname,
                    fundingTypeCode = " "
                    ////  fundingTypeCode Not applicable, as could relate to many
                };
            }

            return null;
        }

        /// <summary>
        /// Helper method to return a formatted period object from a contract
        /// </summary>
        /// <param name="xrmContext">The early-bound Xrm Service Context</param>
        /// <param name="periodId">periodId </param>
        /// <returns>A period</returns>
        private static corporateContract.Period GetCorpContractPeriod(XrmServiceContext xrmContext, EntityReference periodId)
        {
            corporateContract.Period period = null;
            if (periodId != null)
            {
                period = (
                    from p in xrmContext.sfa_periodSet
                    join pt in xrmContext.sfa_periodtypeSet on
                        p.sfa_PeriodTypeId.Id equals pt.sfa_periodtypeId
                    where p.sfa_periodId.Equals(periodId.Id)
                    select new corporateContract.Period
                    {
                        period1 = p.sfa_Period,
                        periodType = TransformCrmPeriodTypeType(pt),
                        startDate = p.sfa_StartDate.GetValueOrDefault().ToUniversalTime(),
                        endDate = p.sfa_EndDate.GetValueOrDefault().ToUniversalTime()
                    }).FirstOrDefault();
            }

            return period;
        }

        private static corporateContract.periodTypeType TransformCrmPeriodTypeType(sfa_periodtype crmPeriodType)
        {
            return new corporateContract.periodTypeType
            {
                periodTypeCode = (corporateContract.periodTypeCodeType)Enum.Parse(typeof(corporateContract.periodTypeCodeType), crmPeriodType.sfa_periodtypecode, true),
                periodTypeName = (corporateContract.periodTypeNameType)Enum.Parse(typeof(corporateContract.periodTypeNameType), crmPeriodType.sfa_PeriodTypeName.Replace(" ", string.Empty).Replace("-",string.Empty), true)
            };
        }

        /// <summary>
        /// Helper method to return a formatted deliverable object from the CRM Contract Deliverable
        /// </summary>
        /// <param name="d">The CRM Deliverable entity</param>
        /// <param name="f">The CRM Funding Stream entity</param>
        /// <returns>A deliverableType</returns>
        private static deliverableType GetCorporateDeliverable(sfa_contractdeliverable d, sfa_fundingstream f)
        {
            return new deliverableType
            {
                deliverableCode = int.Parse(d.sfa_DeliverableCode),
                deliverableName = d.sfa_deliverablename
            };
        }

        private void AdjustCRMDates(corporateContract.Contract matchingContract)
        {
            if (matchingContract.contracts.Any())
            {
                var firstContract = matchingContract.contracts[0];

                // Changed for Nullable start and end date
                if (firstContract?.startDate == null)
                {
                    return;
                }

                DateTime newDate = RetrieveLocalTimeFromUTCTime(firstContract.startDate.Value, OrganizationService);
                TimeSpan difference = newDate - firstContract.startDate.Value;

                matchingContract.startDate += difference;
                matchingContract.endDate += difference;

                matchingContract.contracts.ForEach(cn =>
                {
                    cn.startDate += difference;
                    cn.endDate += difference;

                    if (cn.period != null)
                    {
                        cn.period.startDate += difference;
                        cn.period.endDate += difference;
                    }

                    cn.contractAllocations.ForEach(ca =>
                    {
                        ca.startDate += difference;
                        ca.endDate += difference;

                        if (ca.period != null)
                        {
                            ca.period.startDate += difference;
                            ca.period.endDate += difference;
                        }
                    });
                });
            }
        }

        private void AddMissingFieldsToContractAllocations(corporateContract.Contract matchingContract)
        {
            var firstContract = matchingContract.contracts.FirstOrDefault();
            if (firstContract != null)
            {
                matchingContract.contracts.ForEach(c => c.contractAllocations.Where(a => a.period == null).ToList().ForEach(ca => ca.period = firstContract.period));
                matchingContract.contracts.ForEach(c => c.contractAllocations.ForEach(ca => ca.fundingStream.fundingTypeCode = firstContract.fundingType.fundingTypeCode));
            }
        }

        private DateTime RetrieveLocalTimeFromUTCTime(DateTime utcTime, IOrganizationService service)
        {
            int? timeZoneCode = RetrieveCurrentUsersSettings(service);

            if (!timeZoneCode.HasValue)
            {
                throw new Exception("Can't find time zone code");
            }

            var request = new LocalTimeFromUtcTimeRequest
            {
                TimeZoneCode = timeZoneCode.Value,
                UtcTime = utcTime.ToUniversalTime()
            };

            var response = (LocalTimeFromUtcTimeResponse)service.Execute(request);

            return response.LocalTime;
        }

        private int? RetrieveCurrentUsersSettings(IOrganizationService service)
        {
            var currentUserSettings = service.RetrieveMultiple(
                new QueryExpression("usersettings")
                {
                    ColumnSet = new ColumnSet("localeid", "timezonecode"),
                    Criteria = new FilterExpression
                    {
                        Conditions =
                        {
                            new ConditionExpression("systemuserid", ConditionOperator.EqualUserId)
                        }
                    }
                }).Entities[0].ToEntity<Entity>();

            return (int?)currentUserSettings.Attributes["timezonecode"];
        }

        private class SimpleOrg
        {
            public SimpleOrg(string orgId, string name)
            {
                OrgId = orgId;
                Name = name;
            }

            public string OrgId { get; }
            public string Name { get; }
        }
    }
}