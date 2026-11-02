namespace DocumentsDomain.Endpoint.Xrm.Services
{
    using System;
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Documents;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using Microsoft.Xrm.Sdk;

    public class XrmDocumentManager : IXrmDocumentManager
    {
        public IOrganizationService OrganizationService { get; set; }

        public bool UpdateContractWithDocumentMergeStatus(contractType contractToUpdate, MergeStatus mergeStatus)
        {
            var updateContractObject = new sfa_contract { Id = GetXrmContractId(contractToUpdate.contractNumber, contractToUpdate.contractVersionNumber, contractToUpdate.contractSubVersionNumber) };

            if (mergeStatus.IsMergeSuccessful)
            {
                updateContractObject.sfa_ServiceResponse =
                    new OptionSetValue((int)sfa_serviceresponse.DocumentMergeSuccessful);
            }
            else
            {
                updateContractObject.sfa_ServiceResponse =
                    new OptionSetValue((int)sfa_serviceresponse.DocumentMergeFailed);

                updateContractObject.sfa_ReasonForRejection =
                    mergeStatus.ReasonForFailure.Replace("{UKPRN}", contractToUpdate.contractor.ukprn.ToString())
                        .Replace("{ContractNumber}", contractToUpdate.contractNumber);
            }

            updateContractObject.EntityState = EntityState.Changed;
            OrganizationService.Update(updateContractObject);

            return true;
        }

        /// <summary>
        /// Updates the service response field for a contract in CRM. This causes other actions i.e status updates 
        /// </summary>
        /// <param name="contractToUpdate">Instance of contract to update.</param>
        public void UpdateContractPublishedToProviderManualApproval(contractType contractToUpdate)
        {
            UpdateContractPublishedToProvider(contractToUpdate, sfa_serviceresponse.DocumentPublishSuccessful);
        }

        /// <summary>
        /// Updates the service response field for a contract in CRM. This causes other actions i.e status updates 
        /// </summary>
        /// <param name="contractToUpdate">Instance of contract to update.</param>
        public void UpdateContractPublishedToProviderForElectronicApproval(contractType contractToUpdate)
        {
            UpdateContractPublishedToProvider(contractToUpdate, sfa_serviceresponse.DocumentPublishedForElectronicSignOff);
        }

        public void UpdateContractPublishedToProviderForAutoApproval(contractType contractToUpdate)
        {
            UpdateContractPublishedToProvider(contractToUpdate, sfa_serviceresponse.DocumentPublishedForAutoApproval);
        }

        private void UpdateContractPublishedToProvider(contractType contractToUpdate, sfa_serviceresponse response)
        {
            var xrmContractIdAndSubStatus = GetXrmContractIdAndSubStatus(contractToUpdate.contractNumber,
                contractToUpdate.contractVersionNumber, contractToUpdate.contractSubVersionNumber);

            if (!xrmContractIdAndSubStatus.SubStatus.Equals("Published to Provider", StringComparison.OrdinalIgnoreCase))
            {
                var updateContractObject = new sfa_contract
                {
                    Id = xrmContractIdAndSubStatus.ContractId,
                    sfa_ServiceResponse = new OptionSetValue((int) response),
                    sfa_ContractPublishedDate = contractToUpdate.StatusLastUpdatedDate,
                    EntityState = EntityState.Changed
                };

                OrganizationService.Update(updateContractObject);
            }
        }

        /// <summary>
        /// Updates the service response field for a contract in CRM. This causes other actions i.e status updates 
        /// </summary>
        /// <param name="contractToUpdate">Instance of contract to update.</param>
        /// <param name="reasonForFailure">The reason for failure.</param>
        public void UpdateContractPublishedToProviderFailed(contractType contractToUpdate, string reasonForFailure)
        {
            var updateContractObject = new sfa_contract
            {
                Id = GetXrmContractId(contractToUpdate.contractNumber, contractToUpdate.contractVersionNumber, contractToUpdate.contractSubVersionNumber),
                sfa_ServiceResponse = new OptionSetValue((int)sfa_serviceresponse.DocumentPublishFailed),
                sfa_ReasonForRejection = reasonForFailure,
                EntityState = EntityState.Changed
            };

            OrganizationService.Update(updateContractObject);
        }

        public void UpdateContractSubStatus(contractType contract, string subStatus)
        {
            var updateContractObject = new sfa_contract { Id = GetXrmContractId(contract.contractNumber, contract.contractVersionNumber, contract.contractSubVersionNumber) };

            Guid? statusId = new Guid();
            using (var xrmContext = new XrmServiceContext(OrganizationService))
            {
                var firstOrDefault = (from c in xrmContext.sfa_statusSet
                                      where c.sfa_name == subStatus
                                      select c).FirstOrDefault();
                if (firstOrDefault != null)
                {
                    statusId = firstOrDefault.sfa_statusId;
                }
            }

            if (statusId != null)
            {
                updateContractObject.sfa_SubStatus = new EntityReference
                {
                    LogicalName = "sfa_status",
                    Id = statusId.Value
                };

                updateContractObject.EntityState = EntityState.Changed;
                OrganizationService.Update(updateContractObject);
            }

        }

        private Guid GetXrmContractId(string contractNumber, int versionNumber, int subVersionNumber)
        {
            using (var xrmContext = new XrmServiceContext(OrganizationService))
            {
                return (from c in xrmContext.sfa_contractSet
                        join m in xrmContext.sfa_contractSet on c.sfa_ParentContractId.Id equals m.sfa_contractId
                        where c.sfa_number == contractNumber
                            && c.sfa_Version == versionNumber
                            && c.sfa_SubVersion == subVersionNumber
                        select c.Id).Single();
            }
        }

        private XrmContractIdSubStatus GetXrmContractIdAndSubStatus(string contractNumber, int versionNumber, int subVersionNumber)
        {
            using (var xrmContext = new XrmServiceContext(OrganizationService))
            {
                return (from c in xrmContext.sfa_contractSet
                        join m in xrmContext.sfa_contractSet on c.sfa_ParentContractId.Id equals m.sfa_contractId
                        join s in xrmContext.sfa_statusSet on c.sfa_SubStatus.Id equals s.Id
                        where c.sfa_number == contractNumber
                            && c.sfa_Version == versionNumber
                            && c.sfa_SubVersion == subVersionNumber
                        select new XrmContractIdSubStatus(c.Id, s.sfa_name)).Single();
            }
        }

        private struct XrmContractIdSubStatus
        {
            public XrmContractIdSubStatus(Guid contractId, string subStatus)
            {
                ContractId = contractId;
                SubStatus = subStatus;
            }

            public Guid ContractId { get; }

            public string SubStatus { get; }
        }
    }

    public class ContractDoesntExistException : Exception
    {
        public ContractDoesntExistException()
        {
        }

        public ContractDoesntExistException(string message)
            : base(message)
        {
        }
    }
}
